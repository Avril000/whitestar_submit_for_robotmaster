# whitestar_submit_for_robotmaster
用来交作业ing，新手仓库喵，没什么有价值的东西

> 仓库所有者/提交人：26 百步梯 AI班 吕博翰@Whitestar000@Avril000
>
> p.s 两个账号都是我的，@Whitestar000绑在Gmail上，@Avril000绑在QQ邮箱上。因为最近梯子异常的难翻，我新注册了一个QQ邮箱绑定的GitHub账号用来提交。

**因为README大概率是最先被阅读的文档，所以请允许我在这里先重复几件事情。**

* zip压缩包内容：全套的代码、笔记、演示运行视频。（因为这是我现学并且第一次尝试使用git，这里做双重保险。如果无法打开我的仓库或者仓库里的东西有问题的话，麻烦检测一下这个压缩包里的文件。）

* 仓库内容：全套的代码、笔记。

* 我为什么没有用Keil编辑：

  我的ST-Link是国产山寨货……而我并没有找到能让Keil忽略这个问题的办法，因此，我会遇到……

  * Keil 5.38+ 的 ST-Link 驱动会拒绝山寨调试器。在我尝试下载时，Keil虽然能读取我的ST-Link和芯片，但他拒绝进一步的服务，将我的芯片型号读取为空值。而我没有找到绕过这个问题的方法，我可以在Keil中构造代码，但无法编译调试我的代码。

  但我找到了把C Lion中编辑的代码输出为Keil中项目的方法，因此，我能做的是……

  * 同时学习C Lion和Keil两个软件的使用方法。
  * 用C Lion编写代码并进行调试，然后转换为Keil能懂的格式。
  * Work Buddy帮我写了一个小程序，可以让我的代码在Keil中编译，然后强制使用Cube Programmer 进行烧录，我可以查看我的代码在Keil环境下跑的情况，但终究无法直接用Keil完成调试。


## Part1 点灯工程

* 开发板：STM32F103C8T6

* 工程软件：STM32CubeMX+C Lion/Keil

  > 软件学习产出：
  >
  > * 在CLion中创建新的项目.md
  > * 在Keil中创建新的项目.md

* 工程文件：`Start_With_GPIO`

* 预期结果：小灯以250ms,250ms,500ms的循环点亮

* 运行方式：

  * C Lion打开方式：将整个文件夹在C Lion中作为项目打开

  * Keil打开方式：`Start_With_GPIO\MDK-ARM`路径下的`Start_With_GPIO.uvprojx`文件

  * Agent给我写的小程序：`Start_With_GPIO\MDK-ARM`路径下的`build_and_flash.bat`

    ***使用正版烧录器的话，我的代码应该能直接从Keil中烧录进板子，大概率用不到这个程序，放在这里供检查。***

## Part2 GPIO学习

* 预备资源：

  * 江协科技 《STM32入门教程》 第3章
    * 公认STM32最佳入门课
  * ST Wiki 《Getting started with GPIO》
    * 官方文档补充
  * 百度、CSDN 《我所有看不懂的名词》
* 产出：
  * `GPIO学习笔记.md`笔记本体
  * `photo`配图文件夹
