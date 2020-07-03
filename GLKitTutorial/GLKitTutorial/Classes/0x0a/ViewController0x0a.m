//
//  ViewController0x0a.h
//  GLKTutorial
//
//  Created by Matt Reach on 2020/7/2.
//  Copyright © 2020 GLKTutorial. All rights reserved.
//

#import "ViewController0x0a.h"

/*
OpenGL 坐标系(忽略 Z 轴)
圆点在中心时，R = 1
          ^
v2 (-1,1) | (1,1)  v1
   -------|------>
v3 (-1,-1)| (1,-1) v0
*/


/*
 OpenGL 纹理坐标系
    y^
(0,1)|
     |
     |---------> x
    (0,0)      (1,0)
 */


//定义结构和宏
typedef float Position[3];
typedef float TexCoord0[2];

typedef struct {
    Position position;//XYZ
    TexCoord0 coord0; //纹理0坐标
    TexCoord0 coord1; //纹理1坐标
} Vertex;

// 4个顶点
#define v0 {1, -1, 1}
#define v1 {1, 1, 1}
#define v2 {-1, 1, 1}
#define v3 {-1, -1, 1}
// 定义纹理位置
#define C0 {1.0,0.0}
#define C1 {1.0,1.0}
#define C2 {0,1.0}
#define C3 {0.0,0.0}

//定义顶点结构
static const Vertex Vertices[] = {
    {v0, C0, C0},
    {v1, C1, C1},
    {v2, C2, C2},
    {v3, C3, C3}
};

//6个顶点位置
static const GLubyte Indices[] = {
   0, 1, 2,
   0, 3, 2
};

typedef struct VertexData {
    GLuint indexBuffer;
    GLuint vertexBuffer;
    
    GLubyte indices[6];
    Vertex  vertices[4];
} VertexData;

@interface ViewController0x0a ()
{
    VertexData vertexData;
    float _rotation;
}

@property (nonatomic, weak) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *effect;

@end

@implementation ViewController0x0a

- (void)dealloc
{
    [EAGLContext setCurrentContext:self.context];
    
    if (vertexData.vertexBuffer > 0) {
        glDeleteBuffers(sizeof(vertexData.vertices), &vertexData.vertexBuffer);
        vertexData.vertexBuffer = 0;
    }
    
    [EAGLContext setCurrentContext:nil];
}

- (void)setupGL {
    
    [EAGLContext setCurrentContext:self.context];
    
    //为第一次 draw 初始化数据
    [self updateVerticsData];
    
    NSBundle *fmwkBundle = [NSBundle bundleForClass:[self class]];
    NSString *localBundlePath = [fmwkBundle pathForResource:@"GLKitTutorial" ofType:@"bundle"];
    NSBundle *localBundle = [NSBundle bundleWithPath:localBundlePath];
    
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];//GLKTextureLoaderOriginBottomLeft 纹理坐标系和图片的坐标上下是相反的
    
    NSString* filePath = [localBundle pathForResource:@"cat" ofType:@"jpg"];
    NSString* filePath2 = [localBundle pathForResource:@"Lenna" ofType:@"jpg"];
    
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    GLKTextureInfo* textureInfo2 = [GLKTextureLoader textureWithContentsOfFile:filePath2 options:options error:nil];
    
    //内部会创建好 shader
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.name = textureInfo.name;
    self.effect.texture2d0.target = textureInfo.target;
    
    self.effect.texture2d1.enabled = GL_TRUE;
    self.effect.texture2d1.name = textureInfo2.name;
    self.effect.texture2d1.target = textureInfo2.target;
    //默认如此
    self.effect.texture2d1.envMode = GLKTextureEnvModeModulate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //排除掉导航下面的区域
    self.edgesForExtendedLayout = UIRectEdgeAll & ~UIRectEdgeTop;
    // 创建上下文是必要的，告诉 OpenGL 使用的 API 版本。
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    //GLKViewController 会自动创建 GLKView
    GLKView *glkView = (GLKView *)self.view;
    //设置 glkView 的上下文
    [glkView setContext:context];
    self.context = context;
    //帧率越大，变化越快！
    self.preferredFramesPerSecond = 1;
    //初始化OpenGL
    [self setupGL];
}

- (void)updateVerticsData {
    
    memcpy(vertexData.vertices, Vertices, sizeof(Vertices));
    memcpy(vertexData.indices, Indices, sizeof(Indices));
    //创建顶点缓存对象（VBO）
    glGenBuffers(1, &vertexData.vertexBuffer);
    //将顶点数据发送数据到 OpenGL
    glBindBuffer(GL_ARRAY_BUFFER, vertexData.vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData.vertices), vertexData.vertices, GL_STATIC_DRAW);
    
    //创建索引缓冲对象（EBO）
    glGenBuffers(1, &vertexData.indexBuffer);
    //将顶点数据发送数据到 OpenGL
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertexData.indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(vertexData.indices), vertexData.indices, GL_STATIC_DRAW);

    //开始使用顶点着色器的颜色
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //设置具体位置值（属性名，值个数，类型，通常FALSE，跨度（一组值的多少个字节），开始值在跨度里的偏移量）
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, position));
    //设置纹理0可用
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    //设置纹理0位置
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, coord0));
    
    //设置纹理1可用
    glEnableVertexAttribArray(GLKVertexAttribTexCoord1);
    //设置纹理1位置
    glVertexAttribPointer(GLKVertexAttribTexCoord1, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, coord1));
    
    //设置过滤模式
    GLint param = GL_NEAREST;//临近->马赛克
    param = GL_LINEAR;//线性->模糊
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, param);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, param);
}

//实现代理方法！视图需要重绘时就会调用这个方法了；
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //清屏
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    //让着色器准备好
    [self.effect prepareToDraw];

    //绘制元素（三角形类型，顶点数量，数据类型，使用VBO时表示偏移量）
    glDrawElements(GL_TRIANGLES, sizeof(vertexData.indices), GL_UNSIGNED_BYTE, 0);
}

@end
