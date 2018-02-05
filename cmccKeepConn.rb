#!/usr/bin/env ruby
# Data 2018-2-5

require 'net/http'
require 'socket'
require 'readline'
require 'timeout'

$__program__ = 'cmccKeepConn'
$__version__ = '2.0.3'
$__author__  = 'L'
$__github__  = 'https://github.com/L-codes/cmccKeepConn'

trap("INT"){ abort "\r [!!!] Interrupt. " }


class CMCCFree

  def initialize(iplist='cmccfreeip.txt', host='github.com')
    puts " [+] auto keep connect ..."
    @filename = iplist
    @keep_interval = 50
    @uri_head = 'http://221.176.66.85:81/wlan-portal-web/'
    @user_agent = 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW6 4; Trident/6.0)'
    @phone_range = 13500000000...13599999999
    @wlanacname, @myip = get_info host
    @myphone = rand(@phone_range)
    @ips = create_ips || []
    @current_keep_thread = keepconn @keep_interval 
  end


  def keepconn minute
    Thread.new do 
      loop do 
        keep_post @myip, @myphone
        @ips.each{|ip, phone| keep_post(ip, phone)}
        sleep 60 * minute
      end
    end
  end


  def keep_post(wlanuserip, phone)
    path = 'service/portalAccountService.loginByPortal.rest?t=%s' % (Time.now.to_f * 1000).truncate
    uri = URI(@uri_head + path)
    headers = {
      :'Referer'             => @uri_head + 'portal?wlanacname=' + @wlanacname + 
                                '&wlanuserip=' + wlanuserip + 
                                '&wlanacssid=CMCC-FREE&spe=ggmb',
      :'User-Agent'          => @user_agent,
      :'Content-Type'        => 'application/x-www-form-urlencoded; charset=utf-8',
      :'X-Requested-With'    => 'XMLHttpRequest',
      :'Accept'              => 'application/json, text/javascript, */*; q=0.01',
      :'Accept-Encoding'     => 'gzip, deflate',
      :'Pragma'              => 'no-cache',
      :'DNT'                 => '1'
    }
    data = {
      :'paramMap.USER'       => phone,
      :'paramMap.PWD'        => ' ' * 6,
      :'paramMap.wlanacname' => @wlanacname,
      :'paramMap.wlanuserip' => wlanuserip,
      :'paramMap.actiontype' => 'LOGIN',
      :'paramMap.wlanacssid' => 'CMCC-FREE',
      :'paramMap.forceflag'  => 1,
      :'paramMap.useragent'  => @user_agent,
      :'paramMap.spe'        => 'ggmb'
    }
    data = URI.encode_www_form(data)
    2.times{ Net::HTTP.post(uri, data, headers) rescue retry }
  end


  def get_info host
    loop do
      begin
        Timeout::timeout 3 do 
          puts 'test1'
          TCPSocket.open(host, 80) do |sock|
            sock.write("GET / HTTP/1.1\r\n")
            wlanuserip = sock.local_address.ip_address
            data = sock.read
            /wlanacname=(?<wlanacname>.*?)&/ =~ data
            return wlanacname, wlanuserip if wlanacname
          end
        end
      rescue Timeout::Error
        redo
      rescue SocketError
        abort "[!] Please check the Proxy and DNS settings"
      end
    end
  end


  def create_ips
    if File.exist? @filename
      ip_head = @myip.split(?.)[0] + ?.
      File.readlines(@filename)
          .map{|ip| [ip.strip, rand(@phone_range)]}
          .keep_if{|ip,_| ip.start_with? ip_head}
    end
  end


  def list
    @ips.each_with_index{|(ip,phone),i| puts " [%d] Phone: %s, IP: %s" % [i,phone,ip]}
  end


  def add *ip_list
    ip_list.each do |ip|
      @ips << [ip, rand(@phone_range)]
      keep_post *@ips[-1]
      puts " [+] Add IP: %s, Phone: %s" % @ips[-1]
    end
  end


  def del *index
    del_items = index.map{|i| @ips[i.to_i]}
    @ips -= del_items
    del_items.each{|item| puts " [-] Delete IP: %s, Phone: %s" % item}
  end


  def clear
    @ips.clear
    puts " [!] Clear all IPs"
  end


  def save
    open(@filename, ?w){ |f| @ips.each{|ip,| f.puts ip} }
    puts " [+] Save #{@ips.size} IPs to the '#@filename'"
  end


  def renew(minute=@keep_interval)
    Thread.kill @current_keep_thread
    @current_keep_thread = keepconn minute
    puts " [+] Renew Successful. (interval: #{minute} minutes)"
  end

end


class CUI

  def initialize
    banner
    @cmcc = CMCCFree.new
    @cmds = %w[list del clear add save renew exit quit help ?]
    @cmd_prompt = '-> '
  end


  def loop
    puts " [+] Initialize Successful\n\n"
    comp = proc { |s| @cmds.grep(/^#{Regexp.escape(s)}/) }
    Readline.completion_append_character = " "
    Readline.completion_proc = comp

    while line = Readline.readline(@cmd_prompt, true)
      handle line
    end
  end
    

  def banner
    puts "
  ____                    _  __                ____
 / ___|_ __ ___   ___ ___| |/ /___  ___ _ __  / ___|___  _ __  _ __
| |   | '_ ` _ \\ / __/ __| ' // _ \\/ _ \\ '_ \\| |   / _ \\| '_ \\| '_ \\
| |___| | | | | | (_| (__| . \\  __/  __/ |_) | |__| (_) | | | | | | |
 \\____|_| |_| |_|\\___\\___|_|\\_\\___|\\___| .__/ \\____\\___/|_| |_|_| |_|
                                       |_|
               [ Author #$__author__       Version #$__version__ ]

 [ Github ] #$__github__
    "
  end


  def handle line
    cmd, *args = line.downcase.strip.split
    if cmd
      case cmd
      when 'list', 'clear', 'save'
        @cmcc.send(cmd)
      when 'del', 'add'
        @cmcc.send(cmd, *args)
      when 'renew'
        minutes = args.empty? ? 50: args[0].to_i
        @cmcc.send(cmd, minutes)
      when 'exit', 'quit'
        puts " I guess you're off duty~"
        exit
      when '?', 'help'
        puts " help(?) "
        puts " ======== "
        puts " list                List IPs info"
        puts " add ip1,ip2...      Add IPs"
        puts " del idx1, idx2...   Deletes the IP at the specified index"
        puts " clear               Clear all IPs"
        puts " save                Save all IPs to file"
        puts " renew MIN           Renew request. (interval: 50 min)"
        puts " exit/quit           Exit the program"
      else
        puts "[!!] Command not found: #{cmd}"
      end
      puts
    end
  end

end

CUI.new.loop
