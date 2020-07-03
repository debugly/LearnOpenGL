//
//  ViewController0x0b.h
//  GLKTutorial
//
//  Created by Matt Reach on 2020/7/2.
//  Copyright © 2020 GLKTutorial. All rights reserved.
//

#import "ViewController0x0b.h"

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
} Vertex;

// 4个顶点
#define v0 {1, -1, 1}
#define v1 {1, 1, 1}
#define v2 {-1, 1, 1}
#define v3 {-1, -1, 1}
#define v4 {0.5, -0.5, -1}
#define v5 {0.5,  0.5, -1}
#define v6 {-0.5, 0.5, -1}
#define v7 {-0.5,-0.5, -1}

// 定义纹理位置
#define C0 {1.0,0.0}
#define C1 {1.0,1.0}
#define C2 {0,1.0}
#define C3 {0.0,0.0}

//定义顶点结构
static const Vertex Vertices[] = {
    {v0, C0},
    {v1, C1},
    {v2, C2},
    {v3, C3},
    {v4, C0},
    {v5, C1},
    {v6, C2},
    {v7, C3},
};

//定义两个平面类型
typedef struct PlanarIndices {
    GLubyte front[6];
    GLubyte back[6];
}PlanarIndices;

//定义两个平面
static const PlanarIndices Indices = {
    // Front
    {0, 1, 2, 0, 3, 2},
    // Back
    {4, 5, 6, 4, 7, 6}
};

typedef struct VertexData {
    GLuint indexBuffer;
    GLuint vertexBuffer;
    
    PlanarIndices indices;
    Vertex vertices[8];
} VertexData;

@interface ViewController0x0b ()<GLKViewControllerDelegate>
{
    VertexData vertexData;
    float _rotation;
}

@property (nonatomic, weak) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *effect0;
@property (nonatomic, strong) GLKBaseEffect *effect1;

@end

@implementation ViewController0x0b

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
    NSString* filePath0 = [localBundle pathForResource:@"cat" ofType:@"jpg"];
    NSString* filePath1 = [localBundle pathForResource:@"Lenna" ofType:@"jpg"];
    GLKTextureInfo* textureInfo0 = [GLKTextureLoader textureWithContentsOfFile:filePath0 options:options error:nil];
    GLKTextureInfo* textureInfo1 = [GLKTextureLoader textureWithContentsOfFile:filePath1 options:options error:nil];
    
    //内部会创建好 shader
    self.effect0 = [[GLKBaseEffect alloc] init];
    self.effect0.texture2d0.enabled = GL_TRUE;
    self.effect0.texture2d0.name = textureInfo0.name;
    self.effect0.texture2d0.target = textureInfo0.target;
    
    self.effect1 = [[GLKBaseEffect alloc] init];
    self.effect1.texture2d0.enabled = GL_TRUE;
    self.effect1.texture2d0.name = textureInfo1.name;
    self.effect1.texture2d0.target = textureInfo1.target;
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
    self.preferredFramesPerSecond = 10;
    self.delegate = self;
    //初始化OpenGL
    [self setupGL];
}

- (void)updateVerticsData {
    
    memcpy(vertexData.vertices, Vertices, sizeof(Vertices));
    memcpy(&vertexData.indices, &Indices, sizeof(Indices));
    //创建顶点缓存对象（VBO）
    glGenBuffers(1, &vertexData.vertexBuffer);
    //将顶点数据发送数据到 OpenGL
    glBindBuffer(GL_ARRAY_BUFFER, vertexData.vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData.vertices), vertexData.vertices, GL_STATIC_DRAW);
    
    //创建索引缓冲对象（EBO）
    glGenBuffers(1, &vertexData.indexBuffer);
    //将顶点数据发送数据到 OpenGL
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertexData.indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(vertexData.indices), &vertexData.indices, GL_STATIC_DRAW);

    //开始使用顶点着色器的颜色
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //设置具体位置值（属性名，值个数，类型，通常FALSE，跨度（一组值的多少个字节），开始值在跨度里的偏移量）
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, position));
    
//    //设置过滤模式
//    GLint param = GL_NEAREST;//临近->马赛克
//    param = GL_LINEAR;//线性->模糊
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, param);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, param);
}

//实现代理方法！视图需要重绘时就会调用这个方法了；
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //清屏
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //让front平面的着色器准备下
    [self.effect0 prepareToDraw];
    //设置纹理0可用
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    //设置纹理0位置
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, coord0));
    //绘制元素（三角形类型，顶点数量，数据类型，使用VBO时表示偏移量）
    glDrawElements(GL_TRIANGLES, sizeof(Indices.front), GL_UNSIGNED_BYTE, (const GLvoid *)offsetof(PlanarIndices, front));
    
    //让back平面的着色器准备下
    [self.effect1 prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    //设置纹理0位置
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *)offsetof(Vertex, coord0));
    //绘制元素（三角形类型，顶点数量，数据类型，使用VBO时表示偏移量）
    glDrawElements(GL_TRIANGLES, sizeof(Indices.back), GL_UNSIGNED_BYTE, (const GLvoid *)offsetof(PlanarIndices, back));
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller
{
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 4.0f, 10.0f);
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);
    _rotation += 90 * self.timeSinceLastUpdate;
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 1, 0);

    self.effect0.transform.modelviewMatrix = modelViewMatrix;
    self.effect0.transform.projectionMatrix = projectionMatrix;
    
    self.effect1.transform.modelviewMatrix = modelViewMatrix;
    self.effect1.transform.projectionMatrix = projectionMatrix;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.paused = !self.paused;
}

@end
