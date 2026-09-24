# 在Keil中创建项目

> 我为什么没有用Keil编辑：
>
> 见README

## 首先，在Cube MX中创建项目

1. 选择芯片型号

2. 在`SYS`中选择Debug参数

   > F103C8T6的Debug模式为Serial Wire 也就是SW

3. 设置你需要的输出引脚并加上标签

4. 在`Project Manager`中给工程命名并选择地址

   > 使用Keil编辑时，工程的保存Toolchain应该选择**MDK-ARM**，否则Keil将无法正确读取文件

5. 使用Keil时，Cube MX创建完项目后可以自主帮你打开Keil，选择打开即可。

***

# 在Keil中写代码

1. 选中一条主代码，然后选择`Goto`可以跳转Keil中相应的页面
2. 制造一个`断点`可以让你的代码在断点处停下来
3. 右键将一个数据添加到观测窗口，可以直观的显示数据的变化

> **所有的代码必须写在`User Code`框定的区域！！**

