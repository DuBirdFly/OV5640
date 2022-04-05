连通域识别算法动画演示(建议下载后0.05倍速(用Pr)看): https://www.bilibili.com/video/BV16S4y1U7ZG
连通域标记算法FPGA流水线实现思路-无需DDR缓存图像: https://www.bilibili.com/video/BV1c94y1Z7dV

## 常见参数
640*480(60Hz)   VGA_CLK = 25.175MHz

## 文件夹说明
### rtl/clock_pll
- quartus ii 的 ip 文件, 输入50MHz时钟, 输出 24MHz的VGA时钟(输出端口c0), 输出25.175MHz的OV5640时钟(输出端口c1), 
- c0对接color_bar的iClk和Sdram_Control_4Port的RD1_CLK和RD2_CLK
- c1对接COMS_Capture的iCLK和cmos2_reg_config的clk_25M

### rtl/cmos
- 对I2C协议的双目摄像头(OV5640*2=OV5642)的初始化文件(寄存器配置)
- COMS_Capture.v 是对OV5640输出的数据的合并. 因为OV5640输出的是类似VGA格式, 但是用连续发送两个8bit的数据代替一次16bit的RGB565数据, 这个文件实现数据拼接和时序变换
- 其中cmos1_reg_config.v, cmos2_reg_config.v, cmos3_reg_config.v 分别为寄存器配置文件(主要有三个参数可以配置横纵像素和帧率, 具体请用文本对比工具看看是哪三个参数, 然后去配置文档里找), 这里全使用cmos2_reg_config. 我记得cmos2_reg_config是320x240输出, 帧率(好像是)60帧

### rtl/image_process
- 图像处理模块

### rtl/mid_ware
- 一些没有具体分类, 但是起到作用的模块, 自作主张得偷用了'中间件(middle Ware)'的名头, 希望以后能更好地为这个文件夹命名

### rtl/sdram_4port
- 例程自带的4端口sdram, 我没敢动(好像删去了几个无用信号), 我只是在"rtl/sdram_4port/Sdram_Control_4Port.v"中例化"rtl/sdram_4port/sdram_pll/Sdram_PLL"的前面(大概200行的地方)加了关于CLK注释

### rtl/useless
- 没用(上)的文件, 绝大多数是参考文件, 或者我写了一个相同功能的plus版代替的原文件

### rtl/vga
- vga时序文件, color_bar.v包含头文件video_define.v, 要适配不同的屏幕请改video_define.v, 改完根据color_bar.v中parameter的部分修改"rtl/clock_pll"文件输出的时钟值(在quartus ii中改IP)


用color_bar代替了VGA_Controller































