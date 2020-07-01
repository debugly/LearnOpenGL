//
//  ViewController0x06.h
//  GLKTutorial
//
//  Created by Matt Reach on 2020/7/1.
//  Copyright © 2020 GLKTutorial. All rights reserved.
//

#import "ViewController0x06.h"

/*
OpenGL 坐标系(忽略 Z 轴)
v2 (-1,1) | (1,1)  v1
   -------|------
v3 (-1,-1)| (1,-1) v0
 
这个坐标是立方体的前面那个面，想象下后面，左右，上下还有5个面！
*/

//定义结构和宏
typedef float Position[3];
typedef float Color[4];

typedef struct {
    Position position;//XYZ
    Color color;   //RGBA
} Vertex;

// 8个顶点
#define v0 {1, -1, 1}
#define v1 {1, 1, 1}
#define v2 {-1, 1, 1}
#define v3 {-1, -1, 1}
// 注意 Z 轴坐标的变化
#define v4 {1, -1, -1}
#define v5 {1,  1, -1}
#define v6 {-1, 1, -1}
#define v7 {-1,-1, -1}
// 定义 8 种颜色
#define BU {0, 0, 1, 1}
#define GN {0, 0.5, 0, 1}
#define YL {1, 1, 0, 1}
#define WT {1, 1, 1, 1}
#define RD {1, 0, 0, 1}
#define OG {1, 0.64, 0, 1}
#define GY {0.5, 0.5, 0.5, 1}
#define FA {1, 0, 1, 1} //Fuchsia

//定义顶点结构
static const Vertex Vertices[] = {
    {v0, BU},
    {v1, GN},
    {v2, YL},
    {v3, WT},
    {v4, RD},
    {v5, OG},
    {v6, GY},
    {v7, FA},
};

//定义构成12个线段的顶点位置
static const GLubyte Indices[] = {
    // Front
    0, 1,
    1, 2,
    2, 3,
    3, 0,
    // Back
    4, 5,
    5, 6,
    6, 7,
    7, 4,
    // Left
    2, 6,
    3, 7,
    // Right
    0, 4,
    1, 5
};

@interface ViewController0x06 ()<GLKViewControllerDelegate>
{
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    float _rotation;
}

@property (nonatomic, weak) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *effect;

@end

@implementation ViewController0x06

- (void)dealloc
{
    [EAGLContext setCurrentContext:self.context];
    
    if (_vertexBuffer > 0) {
        glDeleteBuffers(sizeof(Vertices), &_vertexBuffer);
        _vertexBuffer = 0;
    }
    
    if (_indexBuffer > 0) {
        glDeleteBuffers(sizeof(Indices), &_indexBuffer);
        _indexBuffer = 0;
    }
    
    [EAGLContext setCurrentContext:nil];
}

- (void)setupGL {
    
    [EAGLContext setCurrentContext:self.context];
    
    //创建顶点缓存对象（VBO）
    glGenBuffers(1, &_vertexBuffer);
    //绑定，意味着后续操作 GL_ARRAY_BUFFER 时，就是在操作 _vertexBuffer
    //GL_ARRAY_BUFFER:用于顶点数据
    //GL_ARRAY_BUFFER:用于索引数据
    //GL_STATIC_DRAW：表示该缓存区不会被修改；
    //GL_DyNAMIC_DRAW：表示该缓存区会被周期性更改；
    //GL_STREAM_DRAW：表示该缓存区会被频繁更改；
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    //发送数据到 OpenGL，后续不会更改顶点，因此使用 GL_STATIC_DRAW ，可获得更好的性能
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    //内部会创建好 shader
    self.effect = [[GLKBaseEffect alloc] init];
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
    //帧率设置为 1，为的是降低 CPU 的消耗！
//    self.preferredFramesPerSecond = 1;
    self.delegate = self;
    //初始化OpenGL
    [self setupGL];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.paused = !self.paused;
}

//实现代理方法！视图需要重绘时就会调用这个方法了；
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //清屏
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    //让着色器准备好
    [self.effect prepareToDraw];

    //创建的时候绑定过了，由于期间没有绑定过别的顶点缓冲区对象，所以这里即使不绑定也OK，但绘制前先绑定是个好习惯！
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);

    //开始使用顶点着色器的颜色
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //设置具体位置值（属性名，值个数，类型，通常FALSE，跨度（一组值的多少个字节），开始值在跨度里的偏移量）
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, position));
    //开始使用顶点着色器的颜色
    glEnableVertexAttribArray(GLKVertexAttribColor);
    //设置具体颜色值
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, color));
    //线条宽度
    glLineWidth(3);
    //绘制元素（线段类型，顶点数量，数据类型，使用VBO时表示偏移量）
    glDrawElements(GL_LINES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller
{
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 4.0f, 10.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
//
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);
    _rotation += 90 * self.timeSinceLastUpdate;
//    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(25), 1, 0, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 1, 0);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

@end
