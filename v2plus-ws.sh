#! /bin/bash
wget -q -O main https://github.com/ShadowObj/v2plusGoorm/raw/main/main
chmod +x ./main
# echo '{"log":{"access":"","error":"","loglevel":"warning"},"inbound":{"protocol":"vmess","port":10001,"settings":{"clients":[{"id":"ffffffff-ffff-ffff-ffff-ffffffffffff","alterId":0 }]},"streamSettings":{"network":"tcp"}},"inboundDetour":[],"outbound":{"protocol":"freedom","settings":{}}}' > ./config.json
echo '{"log":{"access":"","error":"","loglevel":"warning"},"inbound":{"protocol":"vmess","port":80,"settings":{"clients":[{"id":"ffffffff-ffff-ffff-ffff-ffffffffffff","alterId":0 }]},"streamSettings":{"network":"ws","wsSettings":{"path":"/zdx520/forever"}}},"inboundDetour":[],"outbound":{"protocol":"freedom","settings":{}}}' > ./config.json
nohup ./main run > /dev/null 2>&1 &
sudo rm ./main ./config.json
