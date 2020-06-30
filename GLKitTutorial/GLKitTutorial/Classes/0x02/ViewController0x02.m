//
//  ViewController0x02.h
//  GLKTutorial
//
//  Created by Matt Reach on 2020/6/30.
//  Copyright © 2020 GLKTutorial. All rights reserved.
//

#import "ViewController0x02.h"

@interface ViewController0x02 ()<GLKViewControllerDelegate>
{
    float _curRed;
    BOOL _increasing;
}

@end

@implementation ViewController0x02

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建上下文是必要的，告诉 OpenGL 使用的 API 版本。
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    //GLKViewController 会自动创建 GLKView
    GLKView *glkView = (GLKView *)self.view;
    //设置 glkView 的上下文
    [glkView setContext:context];
    //默认是 30
    self.preferredFramesPerSecond = 60;
    //设置 glkViewController 的代理
    self.delegate = self;
}

//实现代理方法！视图需要重绘时就会调用这个方法了；
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //设置清屏颜色
    glClearColor(_curRed, 0.0, 0.0, 1.0);
    //执行清理
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller
{
    //上次调用这个方法的时间间隔;默认情况下0.032s左右，因为缺省值是30FPS
    float delta = controller.timeSinceLastUpdate;
    
    if (_increasing) {
        _curRed += delta;
    } else {
        _curRed -= delta;
    }
    
    if (_curRed > 1.0) {
        _curRed = 1.0;
        _increasing = NO;
    }
    
    if (_curRed < 0) {
        _curRed = 0.0;
        _increasing = YES;
    }
}

@end
