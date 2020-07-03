//
//  ViewController0x0c.h
//  GLKTutorial
//
//  Created by Matt Reach on 2020/7/3.
//  Copyright © 2020 GLKTutorial. All rights reserved.
//

#import "ViewController0x0c.h"
#import <GLKit/GLKit.h>

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
#define FA {0, 0, 0, 1} //Fuchsia

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

//绘制矩形，这里很关键！
//定义构成各个面的顶点位置
static const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    0, 3, 2,
    // Back
    4, 5, 6,
    4, 7, 6,
    // Left
    2, 3, 7,
    2, 6, 7,
    // Right
    0, 1, 5,
    0, 4, 5,
    // Top
    1, 2, 6,
    1, 5, 6,
    // Bottom
    0, 3, 7,
    0, 4, 7
};

@interface ViewController0x0c ()<GLKViewDelegate>
{
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    float _rotation;
}

@property (nonatomic, weak) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *effect;
@property (weak, nonatomic) IBOutlet GLKView *glkView;

@property (assign, nonatomic) CGFloat xTrans;
@property (assign, nonatomic) CGFloat yTrans;
@property (assign, nonatomic) CGFloat zTrans;

@property (assign, nonatomic) CGFloat xRotaion;
@property (assign, nonatomic) CGFloat yRotaion;
@property (assign, nonatomic) CGFloat zRotaion;

@property (weak, nonatomic) IBOutlet UILabel *xTlabel;
@property (weak, nonatomic) IBOutlet UILabel *yTlabel;
@property (weak, nonatomic) IBOutlet UILabel *zTlabel;
@property (weak, nonatomic) IBOutlet UILabel *xRlabel;
@property (weak, nonatomic) IBOutlet UILabel *yRlabel;
@property (weak, nonatomic) IBOutlet UILabel *zRlabel;

@end

@implementation ViewController0x0c

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
    //设置 glkView 的上下文
    [self.glkView setContext:context];
    self.glkView.delegate = self;
    self.context = context;
    //初始化OpenGL
    [self setupGL];
}

//实现代理方法！视图需要重绘时就会调用这个方法了；
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //清屏
    glClearColor(0.7, 0.7, 0.7, 1.0);
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
    //绘制元素（三角形类型，顶点数量，数据类型，使用VBO时表示偏移量）
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)refresh
{
///*
// 把三维物体变为二维图形表示的过程成为投影变换！
//
// 透视投影;
// GLKMatrix4 GLKMatrix4MakePerspective(float fovyRadians, float aspect, float nearZ, float farZ);
// fovyRadians：Y 方向的视角（弧度）
// aspect：纵横比
// nearZ：近剪裁面到原点的距离
// farZ：远剪裁面到原点的距离
// */
//    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
//    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 4.0f, 10.0f);
//    self.effect.transform.projectionMatrix = projectionMatrix;
//
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(self.xTrans, self.yTrans, self.zTrans);
//    _rotation += 90 * self.timeSinceLastUpdate;
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(self.xRotaion), GLKMathDegreesToRadians(self.yRotaion), GLKMathDegreesToRadians(self.zRotaion), 1);
//    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 1, 0);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    [self.glkView display];
    [self refreshLabels];
}

- (void)refreshLabels
{
    self.xTlabel.text = [NSString stringWithFormat:@"%0.2f",self.xTrans];
    self.yTlabel.text = [NSString stringWithFormat:@"%0.2f",self.yTrans];
    self.zTlabel.text = [NSString stringWithFormat:@"%0.2f",self.zTrans];
    self.xRlabel.text = [NSString stringWithFormat:@"%0.2f",self.xRotaion];
    self.yRlabel.text = [NSString stringWithFormat:@"%0.2f",self.yRotaion];
    self.zRlabel.text = [NSString stringWithFormat:@"%0.2f",self.zRotaion];
}

- (IBAction)onTranslation:(UIStepper *)sender {
    // for x
    if (sender.tag == 1000) {
        self.xTrans = sender.value;
    }
    // for y
    else if (sender.tag == 2000) {
        self.yTrans = sender.value;
    }
    // for z
    else if (sender.tag == 3000) {
        self.zTrans = sender.value;
    }
    [self refresh];
    
}

- (IBAction)onRotate:(UIStepper *)sender {
    // for x
    if (sender.tag == 1000) {
        self.xRotaion = sender.value;
    }
    // for y
    else if (sender.tag == 2000) {
        self.yRotaion = sender.value;
    }
    // for z
    else if (sender.tag == 3000) {
        self.zRotaion = sender.value;
    }
    [self refresh];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point0 = [touch previousLocationInView:self.view];
    CGPoint point1 = [touch locationInView:self.view];
    
    CGFloat deltaX = (point1.x - point0.x);
    CGFloat deltaY = (point1.y - point0.y);
    
    if (fabs(deltaY) > fabs(deltaX)) {
        self.xRotaion += deltaY * 0.1;
    } else {
        self.yRotaion += deltaX * 0.1;
    }
    
    [self refresh];
}

@end
