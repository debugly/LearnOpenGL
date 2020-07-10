/*
     File: RippleModel.m
 Abstract: Ripple model class that simulates the ripple effect.
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "RippleModel.h"

@interface RippleModel () {

    unsigned int _texWidth;
    unsigned int _texHeight;
    
    unsigned int _screenWidth;
    unsigned int _screenHeight;
    unsigned int _poolWidth;
    unsigned int _poolHeight;
    unsigned int _touchRadius;
    
    unsigned int _meshFactor;
    
    float texCoordFactorS;
    float texCoordOffsetS;
    float texCoordFactorT;
    float texCoordOffsetT;
    
    // ripple coefficients
    float *rippleCoeff;
    
    // ripple simulation buffers
    float *rippleSource;
    float *rippleDest;
    
    // data passed to GL
    GLfloat *rippleVertices;
    GLfloat *rippleTexCoords;
    GLushort *rippleIndicies;    
}

@end

@implementation RippleModel

- (void)initRippleMap
{
    // +2 for padding the border
    memset(rippleSource, 0, (_poolWidth+2)*(_poolHeight+2)*sizeof(float));
    memset(rippleDest, 0, (_poolWidth+2)*(_poolHeight+2)*sizeof(float));
}

- (void)initRippleCoeff
{
    for (int y=0; y<=2*_touchRadius; y++)
    {
        for (int x=0; x<=2*_touchRadius; x++)
        {        
            float distance = sqrt((x-_touchRadius)*(x-_touchRadius)+(y-_touchRadius)*(y-_touchRadius));
            
            if (distance <= _touchRadius)
            {
                float factor = (distance/_touchRadius);

                // goes from -512 -> 0
                rippleCoeff[y*(_touchRadius*2+1)+x] = -(cos(factor*M_PI)+1.f) * 256.f;
            }
            else 
            {
                rippleCoeff[y*(_touchRadius*2+1)+x] = 0.f;
            }
        }
    }    
}

- (void)initMesh
{
    for (int i=0; i<_poolHeight; i++)
    {
        for (int j=0; j<_poolWidth; j++)
        {
            rippleVertices[(i*_poolWidth+j)*2+0] = -1.f + j*(2.f/(_poolWidth-1));
            rippleVertices[(i*_poolWidth+j)*2+1] = 1.f - i*(2.f/(_poolHeight-1));

            rippleTexCoords[(i*_poolWidth+j)*2+0] = (float)i/(_poolHeight-1) * texCoordFactorS + texCoordOffsetS;
            rippleTexCoords[(i*_poolWidth+j)*2+1] = (1.f - (float)j/(_poolWidth-1)) * texCoordFactorT + texCoordFactorT;
        }            
    }
    
    unsigned int index = 0;
    for (int i=0; i<_poolHeight-1; i++)
    {
        for (int j=0; j<_poolWidth; j++)
        {
            if (i%2 == 0)
            {
                // emit extra index to create degenerate triangle
                if (j == 0)
                {
                    rippleIndicies[index] = i*_poolWidth+j;
                    index++;                    
                }
                
                rippleIndicies[index] = i*_poolWidth+j;
                index++;
                rippleIndicies[index] = (i+1)*_poolWidth+j;
                index++;
                
                // emit extra index to create degenerate triangle
                if (j == (_poolWidth-1))
                {
                    rippleIndicies[index] = (i+1)*_poolWidth+j;
                    index++;                    
                }
            }
            else
            {
                // emit extra index to create degenerate triangle
                if (j == 0)
                {
                    rippleIndicies[index] = (i+1)*_poolWidth+j;
                    index++;
                }
                
                rippleIndicies[index] = (i+1)*_poolWidth+j;
                index++;
                rippleIndicies[index] = i*_poolWidth+j;
                index++;
                
                // emit extra index to create degenerate triangle
                if (j == (_poolWidth-1))
                {
                    rippleIndicies[index] = i*_poolWidth+j;
                    index++;
                }
            }
        }
    }
}

- (GLfloat *)getVertices
{
    return rippleVertices;
}

- (GLfloat *)getTexCoords
{
    return rippleTexCoords;
}

- (GLushort *)getIndices
{
    return rippleIndicies;
}

- (unsigned int)getVertexSize
{
    return _poolWidth*_poolHeight*2*sizeof(GLfloat);
}

- (unsigned int)getIndexSize
{
    return (_poolHeight-1)*(_poolWidth*2+2)*sizeof(GLushort);
}

- (unsigned int)getIndexCount
{
    return [self getIndexSize]/sizeof(*rippleIndicies);
}

- (void)freeBuffers
{
    free(rippleCoeff);
    
    free(rippleSource);
    free(rippleDest);
    
    free(rippleVertices);
    free(rippleTexCoords);
    free(rippleIndicies);    
}

- (id)initWithScreenWidth:(unsigned int)width
             screenHeight:(unsigned int)height
               meshFactor:(unsigned int)factor
              touchRadius:(unsigned int)radius
             textureWidth:(unsigned int)texWidth
            textureHeight:(unsigned int)texHeight
{
    self = [super init];
    
    if (self)
    {
        _texWidth = texWidth;
        _texHeight = texHeight;
        _screenWidth = width;
        _screenHeight = height;
        _meshFactor = factor;
        _poolWidth = width/factor;
        _poolHeight = height/factor;
        _touchRadius = radius;
        
        if ((float)_screenHeight/_screenWidth < (float)_texWidth/_texHeight)
        {            
            texCoordFactorS = (float)(texHeight*_screenHeight)/(_screenWidth*texWidth);
            texCoordOffsetS = (1.f - texCoordFactorS)/2.f;
            
            texCoordFactorT = 1.f;
            texCoordOffsetT = 0.f;
        }
        else
        {
            texCoordFactorS = 1.f;
            texCoordOffsetS = 0.f;            
            
            texCoordFactorT = (float)(_screenWidth*texWidth)/(texHeight*_screenHeight);
            texCoordOffsetT = (1.f - texCoordFactorT)/2.f;
        }
        
        rippleCoeff = (float *)malloc((_touchRadius*2+1)*(_touchRadius*2+1)*sizeof(float));
        
        // +2 for padding the border
        rippleSource = (float *)malloc((_poolWidth+2)*(_poolHeight+2)*sizeof(float));
        rippleDest = (float *)malloc((_poolWidth+2)*(_poolHeight+2)*sizeof(float));
        
        rippleVertices = (GLfloat *)malloc(_poolWidth*_poolHeight*2*sizeof(GLfloat));
        rippleTexCoords = (GLfloat *)malloc(_poolWidth*_poolHeight*2*sizeof(GLfloat));
        rippleIndicies = (GLushort *)malloc((_poolHeight-1)*(_poolWidth*2+2)*sizeof(GLushort));
        
        if (!rippleCoeff || !rippleSource || !rippleDest || 
            !rippleVertices || !rippleTexCoords || !rippleIndicies)
        {
            [self freeBuffers];
            return nil;
        }
        
        [self initRippleMap];
        
        [self initRippleCoeff];
        
        [self initMesh];
    }
    
    return self;
}

- (void)runSimulation
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // first pass for simulation buffers...
    dispatch_apply(_poolHeight, queue, ^(size_t y) {
        for (int x=0; x<_poolWidth; x++)
        {
            // * - denotes current pixel
            //
            //       a 
            //     c * d
            //       b 
            
            // +1 to both x/y values because the border is padded
            float a = rippleSource[(y)*(_poolWidth+2) + x+1];
            float b = rippleSource[(y+2)*(_poolWidth+2) + x+1];
            float c = rippleSource[(y+1)*(_poolWidth+2) + x];
            float d = rippleSource[(y+1)*(_poolWidth+2) + x+2];
            
            float result = (a + b + c + d)/2.f - rippleDest[(y+1)*(_poolWidth+2) + x+1];
            
            result -= result/32.f;
            
            rippleDest[(y+1)*(_poolWidth+2) + x+1] = result;
        }            
    });
    
    // second pass for modifying texture coord
    dispatch_apply(_poolHeight, queue, ^(size_t y) {
        for (int x=0; x<_poolWidth; x++)
        {
            // * - denotes current pixel
            //
            //       a
            //     c * d
            //       b
            
            // +1 to both x/y values because the border is padded
            float a = rippleDest[(y)*(_poolWidth+2) + x+1];
            float b = rippleDest[(y+2)*(_poolWidth+2) + x+1];
            float c = rippleDest[(y+1)*(_poolWidth+2) + x];
            float d = rippleDest[(y+1)*(_poolWidth+2) + x+2];
            
            float s_offset = ((b - a) / 2048.f);
            float t_offset = ((c - d) / 2048.f);
            
            // clamp
            s_offset = (s_offset < -0.5f) ? -0.5f : s_offset;
            t_offset = (t_offset < -0.5f) ? -0.5f : t_offset;
            s_offset = (s_offset > 0.5f) ? 0.5f : s_offset;
            t_offset = (t_offset > 0.5f) ? 0.5f : t_offset;
            
            float s_tc = (float)y/(_poolHeight-1) * texCoordFactorS + texCoordOffsetS;
            float t_tc = (1.f - (float)x/(_poolWidth-1)) * texCoordFactorT + texCoordOffsetT;
            
            rippleTexCoords[(y*_poolWidth+x)*2+0] = s_tc + s_offset;
            rippleTexCoords[(y*_poolWidth+x)*2+1] = t_tc + t_offset;
        }
    });
    
    float *pTmp = rippleDest;
    rippleDest = rippleSource;
    rippleSource = pTmp;    
}

- (void)initiateRippleAtLocation:(CGPoint)location
{
    unsigned int xIndex = (unsigned int)((location.x / _screenWidth) * _poolWidth);
    unsigned int yIndex = (unsigned int)((location.y / _screenHeight) * _poolHeight);
    
    for (int y=(int)yIndex-(int)_touchRadius; y<=(int)yIndex+(int)_touchRadius; y++)
    {
        for (int x=(int)xIndex-(int)_touchRadius; x<=(int)xIndex+(int)_touchRadius; x++)
        {        
            if (x>=0 && x<_poolWidth &&
                y>=0 && y<_poolHeight)
            {
                // +1 to both x/y values because the border is padded
                rippleSource[(_poolWidth+2)*(y+1)+x+1] += rippleCoeff[(y-(yIndex-_touchRadius))*(_touchRadius*2+1)+x-(xIndex-_touchRadius)];
            }
        }
    }    
}

- (int)textureWidth
{
    return _texWidth;
}

- (int)textureHeight
{
    return _texHeight;
}

- (void)dealloc
{
    [self freeBuffers];
}

@end
