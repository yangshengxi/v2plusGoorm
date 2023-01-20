#! /bin/bash

ver="1.1β"
timestamp=$(date +%s)

getpath() {
  read -p "请配置path(留空以使用默认值): " path
  if [ -z $path ];then
    echo "使用默认path: /zdx520/forever"
    path="/zdx520/forever"
  fi
  while true
  do
    if ! [[ `echo $path | grep -oP "^[A-Za-z0-9|/]+"` == $path && ${path:0:1} = "/" ]];then
      read -p "V2ray社区建议Path只应包含字母数字及斜线。请重新输入: " path
    else
      return 0
    fi
  done
}

checkuuid() {
  local uuidLengths=(8 4 4 4 12)
  local uuid=$1
  # 表达式一判断uuid字符数;表达式二判断uuid是否只包含字母数字及短横线
  if [[ ${#uuid} -eq 36 && `echo $uuid | grep -oP "^[A-Za-z0-9|-]+"` == $uuid ]];then
    # 判断uuid是否分为五段
    IFS="-"
    read -a uuidArr <<<$uuid
    local uuidArrLength=${#uuidArr[*]}
    if [ $uuidArrLength -eq 5 ];then
      #判断uuid每段字符数是否正确
      for (( i=0;i<$uuidArrLength;i++ ))  
      do
        local element=${uuidArr[i]}
        if ! [[ ${#element} -eq ${uuidLengths[i]} ]];then
          return 1
        fi
      done
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

getuuid() {
  read -p "输入运行时使用的UUID(留空以随机生成): " uuid
  if [ -z $uuid ];then
    uuid=$(cat /proc/sys/kernel/random/uuid)
    echo "使用随机生成的UUID运行: $uuid"
  else
    while true
    do
      checkuuid "$uuid"
      if [ $? -eq 1 ];then
        read -p "无效的UUID。请重新输入: " uuid
      else
        return 0
      fi
    done
  fi
}

selectPort() {
  read -p "选择运行的端口(留空为80): " port
  if [ -z $port ];then
    echo "使用默认80端口运行"
    port=80
  fi
  while true
  do
    if [ $port -gt 0 ] && [ $port -lt 65536 ];then
      break
    else
      read -p "无效的值(有效值应为1-65535之间的整数)。请重新输入: " port
    fi
  done
}

selectConf() {
  echo "Goorm容器特供版Vmess脚本 Ver: $ver"
  echo "1. TCP(吞吐大,延迟小,易墙)"
  echo "2. Websocket(相对更稳定,可以套cdn)"
  read -p "选择你的配置: " conf
  while true
  do
    case $conf in
    1 )
      selectPort
      getuuid
      conf='{"log":{"access":"","error":"","loglevel":"warning"},"inbound":{"protocol":"vmess","port":'$port',"settings":{"clients":[{"id":"'$uuid'","alterId":0 }]},"streamSettings":{"network":"tcp"}},"inboundDetour":[],"outbound":{"protocol":"freedom","settings":{}}}'
      return 0
      ;;
    2 )
      selectPort
      getuuid
      getpath
      conf='{"log":{"access":"","error":"","loglevel":"warning"},"inbound":{"protocol":"vmess","port":'$port',"settings":{"clients":[{"id":"'$uuid'","alterId":0 }]},"streamSettings":{"network":"ws","wsSettings":{"path":"'$path'"}}},"inboundDetour":[],"outbound":{"protocol":"freedom","settings":{}}}'
      return 0
      ;;
    * )
      read -p "无效的值。请重新输入: " conf
      ;;
    esac
  done
}

deletecheck() {
  read -p "是否删除core和config.json? [y/n]: " deletecheck
  while true
  do
    case $deletecheck in
    y | Y)
      rm ./$timestamp ./config.json
      echo "删除core和config.json成功!"
      return 0
      ;;
    n | N)
      echo "不删除core和config.json!"
      return 0
      ;;
    * )
      read -p "无效的值。请重新选择。[y/n]: " deletecheck
      ;;
    esac
    done
}

selectConf
echo $conf > ./config.json
wget -q -O $timestamp https://github.com/ShadowObj/v2plusGoorm/raw/main/main
chmod +x ./$timestamp
nohup ./$timestamp run > /dev/null 2>&1 &
sleep 3
deletecheck
clear
echo "VMess连接信息: "
echo "协议 VMESS"
case $conf in
1 )
  echo "传输方式 TCP"
  ;;
2 )
  echo "传输方式 Websocket"
  ;;
esac
echo "AlterID 0"
echo "UUID $uuid"
if [ ! -z $path ];then
  echo "Path $path"
  echo "注:在Path后加上?ed=2048以降低握手延迟"
fi