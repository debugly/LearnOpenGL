//
//  ViewController0x07.h
//  GLKTutorial
//
//  Created by Matt Reach on 2020/7/1.
//  Copyright © 2020 GLKTutorial. All rights reserved.
//

#import "ViewController0x07.h"

/*
OpenGL 坐标系(忽略 Z 轴)
圆点在中心时，R = 1
 
v2 (-1,1) | (1,1)  v1
   -------|------
v3 (-1,-1)| (1,-1) v0
*/

//定义结构和宏
typedef float Position[3];
typedef float Color[4];

typedef struct {
    Position position;//XYZ
    Color color;   //RGBA
} Vertex;

// 最大可设置为 255
#define kPoints 100

typedef struct VertexData {
    GLuint indexBuffer;
    GLuint vertexBuffer;
    
    GLubyte indices[kPoints];
    Vertex Vertices[kPoints];
    //当前容量
    int capacity;
} VertexData;

@interface ViewController0x07 ()<GLKViewControllerDelegate>
{
    VertexData vertexData;
}

@property (nonatomic, weak) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *effect;

@end

@implementation ViewController0x07

- (void)dealloc
{
    [EAGLContext setCurrentContext:self.context];
    
    if (vertexData.vertexBuffer > 0) {
        glDeleteBuffers(sizeof(vertexData.Vertices), &vertexData.vertexBuffer);
        vertexData.vertexBuffer = 0;
    }

    if (vertexData.indexBuffer > 0) {
        glDeleteBuffers(vertexData.capacity, &vertexData.indexBuffer);
        vertexData.indexBuffer = 0;
    }
    
    [EAGLContext setCurrentContext:nil];
}

- (void)setupGL {
    
    [EAGLContext setCurrentContext:self.context];
    //创建顶点缓存对象（VBO）
    glGenBuffers(1, &vertexData.vertexBuffer);
    glGenBuffers(1, &vertexData.indexBuffer);
    //为第一次 draw 初始化数据
    [self updateVerticsData];
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
    //帧率越大，变化越快！
    self.preferredFramesPerSecond = 10;
    self.delegate = self;
    //初始化OpenGL
    [self setupGL];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //点击后重新开始绘制
    vertexData.capacity = 1;
}

- (void)updateVerticsData {
    
    vertexData.capacity ++;
    if (vertexData.capacity > kPoints) {
        vertexData.capacity = 1;
    }
    
    const int count = vertexData.capacity;
    const float R = 1;
    for (int i = 0; i < count; i++) {
        Vertex v = {0};
        v.color[0] = arc4random() % 100000 / 100000.0;
        v.color[1] = arc4random() % 100000 / 100000.0;
        v.color[2] = arc4random() % 100000 / 100000.0;
        v.color[3] = 1.0;
        float cos = cos(2 * M_PI/count * i);
        float sin = sin(2 * M_PI/count * i);
        v.position[0] = R * cos;
        v.position[1] = R * sin;
        v.position[2] = 1.0;
        vertexData.Vertices[i] = v;
        vertexData.indices[i] = (GLubyte)i;
    }
    
    //将顶点数据发送数据到 OpenGL
    glBindBuffer(GL_ARRAY_BUFFER, vertexData.vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData.Vertices), vertexData.Vertices, GL_STREAM_DRAW);
    //将顶点索引数据发送数据到 OpenGL
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertexData.indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, vertexData.capacity, vertexData.indices, GL_STREAM_DRAW);
}

//实现代理方法！视图需要重绘时就会调用这个方法了；
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //设置可视区域为正方形，这样会出来的才是个圆形，否则你会看到一个椭圆！！
    int width  = CGRectGetWidth(self.view.bounds)  * [[UIScreen mainScreen] scale];
    int height = CGRectGetHeight(self.view.bounds) * [[UIScreen mainScreen] scale];
    GLsizei sizei = MIN(width, height);
    glViewport((width - sizei)/2.0, (height - sizei)/2.0, sizei, sizei);
    
    //清屏
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    //让着色器准备好
    [self.effect prepareToDraw];

    //创建的时候绑定过了，由于期间没有绑定过别的顶点缓冲区对象，所以这里即使不绑定也OK，但绘制前先绑定是个好习惯！
    glBindBuffer(GL_ARRAY_BUFFER, vertexData.vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertexData.indexBuffer);

    //开始使用顶点着色器的颜色
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //设置具体位置值（属性名，值个数，类型，通常FALSE，跨度（一组值的多少个字节），开始值在跨度里的偏移量）
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, position));
    //开始使用顶点着色器的颜色
    glEnableVertexAttribArray(GLKVertexAttribColor);
    //设置具体颜色值
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, color));
    //线条宽度
    glLineWidth(5);
    //绘制元素（线段类型(连续两点会连接起来)，顶点数量，数据类型，使用VBO时表示偏移量）
    glDrawElements(GL_LINE_LOOP, vertexData.capacity, GL_UNSIGNED_BYTE, 0);
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller
{
    //更新顶点数据
    [self updateVerticsData];
}

@end
