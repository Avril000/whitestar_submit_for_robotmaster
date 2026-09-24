# 在CLion中创建新的项目

## 首先，在CubeMX中创建项目

1. 选择芯片型号

2. 在`SYS`中选择Debug参数

   > F103C8T6的Debug模式为Serial Wire 也就是SW

3. 设置你需要的输出引脚并加上标签

4. 在`Project Manager`中给工程命名并选择地址

   > 使用CLion编辑时，工程的保存Toolchain应该选择**CMake**，否则CLion将无法正确读取文件

***

## 然后，将工程在CLion中启动

1. 通过上方的打开文件夹功能即可打开

   > 你需要信任你的项目

2. 配置你的工具链，一般用自带的就行

3. 因为我的ST-Link是国产山寨的，我需要额外配置一个OpenOCD用来绕过对正版烧录器的检测。

   > CLion添加了对ST-Link的原生支持，但他支持的是正版ST-Link……
   >
   > 在目录`D:\STM32\ST\openocd\xpack-openocd-0.12.0-7\openocd\scripts\board`中选择需要的板件型号

***

# 在CLion中写代码

1. 选中代码，选择`转到`→`声明或用例`可以跳转到相应的页面

2. 点击右上方`小锤子`编译代码

3. 点击`小三角` 让代码在电脑上运行~~（虽然大概没用）~~

4. 点击调试按钮让代码在板件上运行

   > **所有的代码必须写在`User Code`框定的区域！！**

***

# 把CLion写好的代码转为Keil能看懂的格式

* 用CubeMX打开项目，直接在保存的时候选择Keil对应的`MDK-Arm`即可