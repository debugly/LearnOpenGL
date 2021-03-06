## GLKit Introduction

GLKit 是 iOS5 推出的一个框架，旨在简化 OpenGL（ES） 的使用，从 iOS 12 开始废弃！

从 GLKit 的头文件可以看出包含了以下几个部分：

```objective-c
#import <GLKit/GLKitBase.h>

#if TARGET_OS_IPHONE

#import <GLKit/GLKView.h>

#import <GLKit/GLKViewController.h>
#endif

#import <GLKit/GLKModel.h>

#import <GLKit/GLKEffects.h>

#import <GLKit/GLKMath.h>

#import <GLKit/GLKTextureLoader.h>
```



- GLKitBase：GLKit 是对 OpenGL（ES）的封装，因此需要对此依赖，Base 主要是引入相关的头文件。
- GLKView/GLKViewController：**iOS 平台特有的**，抽取了大量的模板代码，完成了 OpenGL ES 项目的基本配置。
- GLKModel：包含了几个 Model 类。
- GLKEffects：简化了从 1.0 到 2.0 的转化，提供了让光照和纹理处理工作简单的方法。
- GLKMath：在 iOS 5之前，每个游戏都需要有自己的数学库，用来处理向量矩阵，GLKMath 提供了这些方法。
- GLKTextureLoader：用于加载图像作为 OpenGL 使用的纹理，不再需要自己写个方法去处理大量不同的图像格式了。



## Demos

- 0x01-GLKitView：红色呼吸灯；感受 5 行代码实现使用 OpenGL 绘制的便利！
- 0x02-GLKitViewController：进一步简化了 0x01 的逻辑；感受 GLKitViewController 的便利！
- 0x03-VBO-GLKBaseEffect：彩色三角形，感受无形 shader 的力量！
- 0x04-VBO-GLKBaseEffect：彩色矩形=两个三角形拼接
- 0x05-VBO-GLKBaseEffect：使用 8 个顶点绘制 12 个三角形拼成立方体
- 0x06-VBO-GLKBaseEffect：使用 8 个顶点绘制 12 条线段组成立方体
- 0x07-VBO-GLKBaseEffect：正多边形的极限是圆吗？
- 0x08-GLKTextureLoader：纹理贴图之 Hello Cat
- 0x09-EBO-GLKTextureLoader：使用 4 个顶点+EBO绘制猫女郎
- 0x0a-EBO-GLKTextureLoader：多重纹理之猫女郎合体
- 0x0b-EBO-GLKTextureLoader：多平面纹理之猫女郎分离（使用了两个shader）



以上 Demo 里没有一个是画点的，这是为什么？

因为上面的 Demo 都没有手动编写 shader，而是使用 GLKBaseEffect ，这是很便利的！由于 OpengGL ES2/ES3 绘制点时需要在顶点着色器里设置 gl_PointSize，但是 GLKBaseEffect 没有提供设置点大小的属性或方法，所以想要使用 GLKit 绘制点的话需要自己写 shader 了！ 

https://stackoverflow.com/questions/19614939/glkit-doesnt-draw-gl-points-or-gl-lines

## Reference

- https://www.raywenderlich.com/3002-beginning-opengl-es-2-0-with-glkit-part-1
- https://www.raywenderlich.com/3001-beginning-opengl-es-2-0-with-glkit-part-2

