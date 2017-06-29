__program__='cmccKeepConn'
__version__='1.0.0'
__author__='L'
__github__='https://github.com/L-codes/cmccKeepConn'

trap "echo \"\r    \n[Interrupt] I guess you're off duty\"; exit" INT

cat << EOF
  ____                    _  __                ____                 
 / ___|_ __ ___   ___ ___| |/ /___  ___ _ __  / ___|___  _ __  _ __  
| |   | '_ \` _ \ / __/ __| ' // _ \/ _ \ '_ \| |   / _ \| '_ \| '_ \ 
| |___| | | | | | (_| (__| . \  __/  __/ |_) | |__| (_) | | | | | | |
 \____|_| |_| |_|\___\___|_|\_\___|\___| .__/ \____\___/|_| |_|_| |_|
                                       |_|                           
               [ Author $__author__       Version $__version__ ]

[ Github ] $__github__

[+] auto keep connect ...
EOF


create_phone()
{
    phone='135'

    for i in `seq 8`
    do
        phone+=$((RANDOM % 10))  
    done
}


times=0
print_keep_status()
{
    times=$[$times+1]
    echo "[+] `date +%H:%M:%S` - The ${times}st certification was successful"
}


get_url_info()
{
    while true
    do
        r=`curl http://github.com --connect-timeout 3 2> /dev/null | grep NextURL`

        if [[ $r =~ wlanacname=(.{16})\& ]]; then
            wlanacname=${BASH_REMATCH[1]}
            if [[ $r =~ wlanuserip=([1234567890]{1,3}\.[1234567890]{1,3}\.[1234567890]{1,3}\.[1234567890]{1,3})\& ]]; then
                wlanuserip=${BASH_REMATCH[1]}
            fi 
            break
        fi
        sleep 3
    done
}


keep_request()
{
    url_head="http://221.176.66.85:81/wlan-portal-web/"
    url_path="service/portalAccountService.loginByPortal.rest?t=1459479089251"

    for i in `seq 2`
    do
        curl -i -s -k -X 'POST' --connect-timeout 3\
            -H 'User-Agent: Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)' \
            -H 'Content-Type: application/x-www-form-urlencoded; charset=utf-8'\
            -H 'X-Requested-With: XMLHttpRequest'\
            -H "Referer: ${url_head}portal?wlanacname=${wlanacname}&wlanuserip=${wlanuserip}&wlanacssid=CMCC-FREE&spe=ggmb"\
            -d "paramMap.USER=${phone}&paramMap.PWD=      &paramMap.wlanacname=${wlanacname}&paramMap.wlanuserip=${wlanuserip}&paramMap.actiontype=LOGIN&paramMap.wlanacssid=CMCC-FREE&paramMap.forceflag=1&paramMap.useragent=Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)&paramMap.spe=ggmb"\
            ${url_head}${url_path} 2> /dev/null > /dev/null
    done
    print_keep_status
} 


main()
{
    create_phone
    get_url_info
    
    echo "[+] IP: ${wlanuserip}, Phone: ${phone}\n"

    while true
    do
        keep_request
        sleep $((50 * 60))
    done
}

main
