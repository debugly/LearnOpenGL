//
//  MRVideoRenderer.h
//  FFmpegTutorial-iOS
//
//  Created by Matt Reach on 2020/7/10.
//

#import <GLKit/GLKit.h>
#import "RippleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRVideoRenderer : GLKView

@property (nonatomic, assign) BOOL isFullYUVRange;
@property (nonatomic, strong) RippleModel *ripple;

- (void)setupGL;

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END
