# 0x00 CmccKeepConn
cmccKeepConn 是一个可以在CMCC-FREE WIFI上自动认证的工具，区别于其它的自动认证脚本不管认证状态，只要启动脚本就不会断开认证，具有添加IP的功能，可以使你的手机或者多个设备的认证在一台主机上实现

v2.0版本，使用Ruby对原[v1.x版本](https://github.com/L-codes/CmccKeepConn/releases/tag/v1.x)重构，使用多线程控制和友好的CUI界面

项目地址：[https://github.com/L-codes/cmccKeepConn](https://github.com/L-codes/cmccKeepConn)

# 0x01 Features
- 兼容windows/linux/osx等平台
- 支持自动检测网络状态，无需重启脚本
- 支持各地CMCC-FREE自动认证
- 支持系统进入睡眠打开后保持连接
- 支持添加多个IP进行认证，并且对其IP池进行管理
- 遇到网络不稳定等因素，无需重启脚本等待断网进行再次初始化(使用renew命令)

# 0x03 Use examples
```
$ ruby cmccKeepConn.rb

  ____                    _  __                ____
 / ___|_ __ ___   ___ ___| |/ /___  ___ _ __  / ___|___  _ __  _ __
| |   | '_ ` _ \ / __/ __| ' // _ \/ _ \ '_ \| |   / _ \| '_ \| '_ \
| |___| | | | | | (_| (__| . \  __/  __/ |_) | |__| (_) | | | | | | |
 \____|_| |_| |_|\___\___|_|\_\___|\___| .__/ \____\___/|_| |_|_| |_|
                                       |_|
               [ Author L       Version 2.0.0 ]

 [ Github ] https://github.com/L-codes/cmccKeepConn

 [+] auto keep connect ...
 [+] Initialize Successful

-> ?
 help(?)
 ========
 list                List IPs info
 add ip1,ip2...      Add IPs
 del idx1, idx2...   Deletes the IP at the specified index
 clear               Clear all IPs
 save                Save all IPs to file
 renew MIN           Renew request. (interval: 50 min)
 exit/quit           Exit the program

-> add 10.177.25.55
 [+] Add IP: 10.177.25.55, Phone: 13539465216

-> add 10.177.25.56 10.177.25.4
 [+] Add IP: 10.177.25.56, Phone: 13517533844
 [+] Add IP: 10.177.25.4, Phone: 13509925580

-> list
 [0] Phone: 13565911967, IP: 10.177.25.192
 [1] Phone: 13539465216, IP: 10.177.25.55
 [2] Phone: 13517533844, IP: 10.177.25.56
 [3] Phone: 13509925580, IP: 10.177.25.4

-> del 0 2
 [-] Delete IP: 10.177.25.192, Phone: 13565911967
 [-] Delete IP: 10.177.25.56, Phone: 13517533844

-> list
 [0] Phone: 13539465216, IP: 10.177.25.55
 [1] Phone: 13509925580, IP: 10.177.25.4
```

# 0x04 Preload IP list file -- cmccfreeip.txt

## Method 1
```
$ cat << EOF > cmccfreeip.txt
10.177.30.145
10.177.23.12
EOF

$ ruby cmccKeepConn.rb

  ____                    _  __                ____
 / ___|_ __ ___   ___ ___| |/ /___  ___ _ __  / ___|___  _ __  _ __
| |   | '_ ` _ \ / __/ __| ' // _ \/ _ \ '_ \| |   / _ \| '_ \| '_ \
| |___| | | | | | (_| (__| . \  __/  __/ |_) | |__| (_) | | | | | | |
 \____|_| |_| |_|\___\___|_|\_\___|\___| .__/ \____\___/|_| |_|_| |_|
                                       |_|
               [ Author L       Version 2.0.0 ]

 [ Github ] https://github.com/L-codes/cmccKeepConn

 [+] auto keep connect ...
 [+] Initialize Successful

-> list
 [0] Phone: 13565911967, IP: 10.177.30.145
 [1] Phone: 13539465216, IP: 10.177.23.12
```

## Method 2
```
$ ruby cmccKeepConn.rb

  ____                    _  __                ____
 / ___|_ __ ___   ___ ___| |/ /___  ___ _ __  / ___|___  _ __  _ __
| |   | '_ ` _ \ / __/ __| ' // _ \/ _ \ '_ \| |   / _ \| '_ \| '_ \
| |___| | | | | | (_| (__| . \  __/  __/ |_) | |__| (_) | | | | | | |
 \____|_| |_| |_|\___\___|_|\_\___|\___| .__/ \____\___/|_| |_|_| |_|
                                       |_|
               [ Author L       Version 2.0.0 ]

 [ Github ] https://github.com/L-codes/cmccKeepConn

 [+] auto keep connect ...
 [+] Initialize Successful

-> list
 [0] Phone: 13565911967, IP: 10.177.30.145
 [1] Phone: 13539465216, IP: 10.177.23.12

-> save
 [+] Save 2 IPs to the 'cmccfreeip.txt'
```

# 0x05 Problem
如在使用过程中发现bug或有好的建议，欢迎提交[Issues](https://github.com/L-codes/cmccKeepConn/issues)和[Pull Requests](https://github.com/L-codes/cmccKeepConn/pulls)
