# v2plus脚本通常不会被检测到v2ray
# v2ray经upx -9 NRV算法压缩
# v2ray以go1.19.4基于v2ray5.1.0UserPreview源码修改后自编译
# 仅简单修改main包main.go入口代码
wget -q -O main https://github.com/ShadowObj/v2plusGoorm/raw/main/main
sudo echo "helloworld" > /home/helloworld.txt
chmod +x ./main
echo '{"log":{"access":"","error":"","loglevel":"warning"},"inbound":{"protocol":"vmess","port":80,"settings":{"clients":[{"id":"ffffffff-ffff-ffff-ffff-ffffffffffff","alterId":0 }]},"streamSettings":{"network":"ws","wsSettings":{"path":"/zdx520/forever"}}},"inboundDetour":[],"outbound":{"protocol":"freedom","settings":{}}}' > ./config.json
nohup ./main run > /dev/null 2>&1 &
sudo rm /home/helloworld.txt ./main ./config.json
