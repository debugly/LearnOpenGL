//
//  ViewController0x01.m
//  Demo01-GLKitView
//
//  Created by Matt Reach on 2020/6/30.
//  Copyright © 2020 Demo. All rights reserved.
//

#import "ViewController0x01.h"
#import <GLKit/GLKit.h>

@interface ViewController0x01 ()<GLKViewDelegate>

@end

@implementation ViewController0x01

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建上下文是必要的，告诉 OpenGL 使用的 API 版本。
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    //在 storyboard 里设置 view 的类型为 GLKView，并设置代理为当前 Controller。
    GLKView *glkView = (GLKView *)self.view;
    glkView.delegate = self;
    //设置 glkView 的上下文
    [glkView setContext:context];
}

//实现代理方法！视图需要重绘时就会调用这个方法了；
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //设置清屏颜色
    glClearColor(1.0, 0.0, 0.0, 1.0);
    //执行清理
    glClear(GL_COLOR_BUFFER_BIT);
}

@end
