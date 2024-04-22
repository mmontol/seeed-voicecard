# seeed-voicecard

seeed-voicecard详细信息请参考[README.md](README.md)。

## 板卡和seeed-voicecard物理引脚对应连接

| lubancat-1/2的40pin物理引脚  | seeed-voicecard的40pin物理引脚   | 引脚说明 |
| ------------------ | ------------------------------ | ---------- |
| 2           | 2                | 5V |
| 3           | 3                | I2C SDA|
| 5           | 5                | I2C SCL |
| 6           | 6                | GND |
| 17           | 17              | 3.3V|
| 19           | 12              | I2S_CLK |
| 21           | 40              | I2S_DAC |
| 24           | 38              | I2S_ADC |
| 26           | 35              | I2S_LRCLK |

## 在lubancat 1/2系列板卡上下载seeed-voicecard

下载仓库源码，然后安装驱动：

```bash
git clone https://github.com/mmontol/seeed-voicecard
cd seeed-voicecard
sudo ./install_lubancat.sh 
sudo reboot
```

重启后（seeed-4mic-voicecard）：

```bash
cat@lubancat~$ arecord -L
null
    Discard all samples (playback) or generate zero samples (capture)
jack
    JACK Audio Connection Kit
pulse
    PulseAudio Sound Server
default
playback
ac108
usbstream:CARD=rockchiphdmi
    rockchip,hdmi
    USB Stream Output
sysdefault:CARD=rockchiprk809co
    rockchip,rk809-codec, fe410000.i2s-rk817-hifi rk817-hifi-0
    Default Audio Device
dmix:CARD=rockchiprk809co,DEV=0
    rockchip,rk809-codec, fe410000.i2s-rk817-hifi rk817-hifi-0
    Direct sample mixing device
dsnoop:CARD=rockchiprk809co,DEV=0
    rockchip,rk809-codec, fe410000.i2s-rk817-hifi rk817-hifi-0
    Direct sample snooping device
hw:CARD=rockchiprk809co,DEV=0
    rockchip,rk809-codec, fe410000.i2s-rk817-hifi rk817-hifi-0
    Direct hardware device without any conversions
plughw:CARD=rockchiprk809co,DEV=0
    rockchip,rk809-codec, fe410000.i2s-rk817-hifi rk817-hifi-0
    Hardware device with all software conversions
usbstream:CARD=rockchiprk809co
    rockchip,rk809-codec
    USB Stream Output
sysdefault:CARD=seeed4micvoicec
    seeed-4mic-voicecard, fe430000.i2s-ac10x-codec0 ac10x-codec.3-003b-0
    Default Audio Device
dmix:CARD=seeed4micvoicec,DEV=0
    seeed-4mic-voicecard, fe430000.i2s-ac10x-codec0 ac10x-codec.3-003b-0
    Direct sample mixing device
dsnoop:CARD=seeed4micvoicec,DEV=0
    seeed-4mic-voicecard, fe430000.i2s-ac10x-codec0 ac10x-codec.3-003b-0
    Direct sample snooping device
hw:CARD=seeed4micvoicec,DEV=0
    seeed-4mic-voicecard, fe430000.i2s-ac10x-codec0 ac10x-codec.3-003b-0
    Direct hardware device without any conversions
plughw:CARD=seeed4micvoicec,DEV=0
    seeed-4mic-voicecard, fe430000.i2s-ac10x-codec0 ac10x-codec.3-003b-0
    Hardware device with all software conversions
usbstream:CARD=seeed4micvoicec
    seeed-4mic-voicecard
    USB Stream Output

cat@lubancat~$ aplay -L
null
    Discard all samples (playback) or generate zero samples (capture)
jack
    JACK Audio Connection Kit
pulse
    PulseAudio Sound Server
default
playback
ac108
sysdefault:CARD=rockchiphdmi
    rockchip,hdmi, fe400000.i2s-i2s-hifi i2s-hifi-0
    Default Audio Device
dmix:CARD=rockchiphdmi,DEV=0
    rockchip,hdmi, fe400000.i2s-i2s-hifi i2s-hifi-0
    Direct sample mixing device
dsnoop:CARD=rockchiphdmi,DEV=0
    rockchip,hdmi, fe400000.i2s-i2s-hifi i2s-hifi-0
    Direct sample snooping device
hw:CARD=rockchiphdmi,DEV=0
    rockchip,hdmi, fe400000.i2s-i2s-hifi i2s-hifi-0
    Direct hardware device without any conversions
plughw:CARD=rockchiphdmi,DEV=0
    rockchip,hdmi, fe400000.i2s-i2s-hifi i2s-hifi-0
    Hardware device with all software conversions
usbstream:CARD=rockchiphdmi
    rockchip,hdmi
    USB Stream Output
sysdefault:CARD=rockchiprk809co
    rockchip,rk809-codec, fe410000.i2s-rk817-hifi rk817-hifi-0
    Default Audio Device
dmix:CARD=rockchiprk809co,DEV=0
    rockchip,rk809-codec, fe410000.i2s-rk817-hifi rk817-hifi-0
    Direct sample mixing device
dsnoop:CARD=rockchiprk809co,DEV=0
    rockchip,rk809-codec, fe410000.i2s-rk817-hifi rk817-hifi-0
    Direct sample snooping device
hw:CARD=rockchiprk809co,DEV=0
    rockchip,rk809-codec, fe410000.i2s-rk817-hifi rk817-hifi-0
    Direct hardware device without any conversions
plughw:CARD=rockchiprk809co,DEV=0
    rockchip,rk809-codec, fe410000.i2s-rk817-hifi rk817-hifi-0
    Hardware device with all software conversions
usbstream:CARD=rockchiprk809co
    rockchip,rk809-codec
    USB Stream Output
usbstream:CARD=seeed4micvoicec
    seeed-4mic-voicecard
    USB Stream Output
```

## 卸载seeed-voicecard

```bash
cat@lubancat:~/seeed-voicecard $ sudo ./uninstall.sh 
...
------------------------------------------------------
Please reboot your lubancat to apply all settings
Thank you!
------------------------------------------------------
```

## 注意！

1. 适配lubancat1/2系列板卡（测试系统debian10）
2. 目前只测试了seeed-4mic-voicecard
3. seeed-4mic-voicecard的LED没有使用
4. 注意引脚复用
