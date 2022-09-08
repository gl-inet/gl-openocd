# GL OpenOCD

该项目是编译好的openocd linux版本，并且应用了patch目录下的相关补丁
源代码及编译方法请参考官方仓库
https://github.com/xpack-dev-tools/openocd

该项目目前主要用于MT7981的调试和烧录

## 使用方法
1. 克隆当前项目
2. 安装jlink驱动
去jlink官网下载对应平台的驱动安装
https://www.segger.com/downloads/jlink/

3. 连接好jlink硬件和目标板
4. 进入项目根目录并连接
```
cd gl-openocd
./bin/openocd -f scripts/interface/jlink.cfg -f scripts/chip/mt7981.cfg
```
5. 如果第四步执行无报错，打开另一个命令行窗口，通过telnet登录并执行命令
```
telnet 127.0.0.1 4444
```

## MT7981调试
对于完全无法启动的设备，执行以下命令
```
halt
mww 0x10212000 0x22000000
mt7981.cpu0 configure -work-area-phys 0x101000 -work-area-size 8096

set cp [aarch64 mrc 15 0 1 0 0]
set cp [expr {($cp & ~1)}]
aarch64 mcr 15 0 1 0 0 $cp

reg cpsr 0x1d3


load_image ./img/switch_mode_32_64.bin 0x100000 bin
load_image ./img/aarch64_stall.bin 0x100100 bin
reg pc 0x100000
resume

halt
load_image ./img/bl2.bin 0x201000 bin
reg pc 0x201000
resume
sleep 3000

halt
load_image ./img/fip.bin 0x40020000 bin
mww 0x100200 1
resume
```
执行以上命令流程后，可以启动目标板
利用load_image命令，可以将正常的镜像加载到内存，然后从内存烧录到flash
