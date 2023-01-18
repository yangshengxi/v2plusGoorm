#! /bin/bash

ver="1.1"
timestamp=$(date +%s)

getuuid() {
  read -p "输入运行时使用的UUID(留空随机生成): " uuid
  if [ -z $uuid ];then
    uuid=$(cat /proc/sys/kernel/random/uuid)
    echo "使用随机生成的uuid运行: $uuid"
  fi
}

selectPort() {
  while true
  do
    if [ -z $port ];then
      read -p "选择运行的端口(留空为80): " port
      if [ -z $port ];then
        echo "使用默认80端口运行"
        port=80
      fi
    fi
    if [ $port -gt 0 ] && [ $port -lt 65536 ];then
      break
    else
      read -p "无效的值(有效值应为1-65535之间的整数)。请重新输入: " port
    fi
  done
}

selectConf() {
  while true
  do
    if [ -z $conf ];then
      echo "Goorm容器特供版Vmess脚本 Ver: $ver"
      echo "1. TCP(吞吐大,延迟小,易墙)"
      echo "2. Websocket(相对更稳定,可以套cdn)"
      read -p "选择你的配置: " conf
    fi
    case $conf in
    1 )
      selectPort
      getuuid
      conf='{"log":{"access":"","error":"","loglevel":"warning"},"inbound":{"protocol":"vmess","port":'$port',"settings":{"clients":[{"id":"'$uuid'","alterId":0 }]},"streamSettings":{"network":"tcp"}},"inboundDetour":[],"outbound":{"protocol":"freedom","settings":{}}}'
      break
      ;;
    2 )
      selectPort
      getuuid
      conf='{"log":{"access":"","error":"","loglevel":"warning"},"inbound":{"protocol":"vmess","port":'$port',"settings":{"clients":[{"id":"'$uuid'","alterId":0 }]},"streamSettings":{"network":"ws","wsSettings":{"path":"/zdx520/forever"}}},"inboundDetour":[],"outbound":{"protocol":"freedom","settings":{}}}'
      break
      ;;
    * )
      read -p "无效的值。请重新输入: " conf
      ;;
    esac
  done
}

selectConf
echo $conf > ./config.json
wget -q -O $timestamp https://github.com/ShadowObj/v2plusGoorm/raw/main/main
chmod +x ./$timestamp
nohup ./$timestamp run > /dev/null 2>&1 &
