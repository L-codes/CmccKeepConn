# 0x00 CmccKeepConn
cmccKeepConn 是一个可以在CMCC-FREE WIFI上自动认证的工具，区别于其它的自动认证脚本不管认证状态，只要启动脚本就不会断开认证
还新增了[bash shell](https://github.com/L-codes/CmccKeepConn/blob/master/cmccKeepConn.sh)版本

项目地址：[https://github.com/L-codes/cmccKeepConn](https://github.com/L-codes/cmccKeepConn)

# 0x01 Features
- 支持python 2.x和3.x
- 支持自动检测网络状态，无需启动和关闭脚本
- 支持各地CMCC-FREE自动认证
- 支持系统进入睡眠打开后保持连接

# 0x03 Use examples
```
$ python cmccKeepConn.py

  ____                    _  __                ____                  
 / ___|_ __ ___   ___ ___| |/ /___  ___ _ __  / ___|___  _ __  _ __  
| |   | '_ ` _ \ / __/ __| ' // _ \/ _ \ '_ \| |   / _ \| '_ \| '_ \ 
| |___| | | | | | (_| (__| . \  __/  __/ |_) | |__| (_) | | | | | | |
 \____|_| |_| |_|\___\___|_|\_\___|\___| .__/ \____\___/|_| |_|_| |_|
                                       |_|                           
               [ Author L       Version 1.0.0 ]

[ Github ] https://github.com/L-codes/cmccKeepConn

[+] auto keep connect ...
[+] IP: 10.177.31.136, Phone: 13571410356

[+] 11:35:59 - The 1st certification was successful
[+] 12:25:59 - The 2nd certification was successful

[Interrupt] I guess you're off duty
```

# 0x04 Problem
如在使用过程中发现bug或有好的建议，欢迎提交[Issues](https://github.com/L-codes/cmccKeepConn/issues)和[Pull Requests](https://github.com/L-codes/cmccKeepConn/pulls)
