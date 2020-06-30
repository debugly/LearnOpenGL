//
//  ViewController0x01.m
//  GLKTutorial
//
//  Created by Matt Reach on 2020/6/30.
//  Copyright © 2020 GLKTutorial. All rights reserved.
//

#import "ViewController0x01.h"
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController0x01 ()<GLKViewDelegate>
{
    float _curRed;
    BOOL _increasing;
}

@end

@implementation ViewController0x01

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建上下文是必要的，告诉 OpenGL 使用的 API 版本。
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    //在 xib 里设置 view 的类型为 GLKView
    GLKView *glkView = (GLKView *)self.view;
    //设置代理为当前 Controller。
    glkView.delegate = self;
    //设置 glkView 的上下文
    [glkView setContext:context];
    
    //自主控制刷新时机
    glkView.enableSetNeedsDisplay = NO;
    //跟屏幕刷新频率保持一致
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)render:(CADisplayLink *)sender
{
    GLKView *glkView = (GLKView *)self.view;
    [glkView display];
}

//实现代理方法！视图需要重绘时就会调用这个方法了；
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //假设屏幕刷新率是 60 HZ，则间隔为 16ms.
    float delta = 0.016;
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
    
    //设置清屏颜色
    glClearColor(_curRed, 0.0, 0.0, 1.0);
    //执行清理
    glClear(GL_COLOR_BUFFER_BIT);
}

@end
