cd /v2raybin
if [ "${CONFIG_URL}" ]
then
    curl -L -o config.json "${CONFIG_URL}"
    sed -i 's/${OID}/${UUID}/g' config.json
else
    echo -e -n "$CONFIG_JSON1" > config.json
    echo -e -n "$UUID" >> config.json
    echo -e -n "$CONFIG_JSON2" >> config.json
fi

if [ "${FRP_URL}" ]
then
    curl -L -o frp.tar.gz "${FRP_URL}"
    tar -xvzf frp.tar.gz
    mv ./frp*/frpc ./
    chmod +x frpc
    rm -rf frp_*
    rm frp.tar.gz
    curl -L -o frpc.ini "${FRP_CONFIG}"
    sed -i 's/${FRP_OLD}/${FRP_NEW}/g' frpc.ini
    nohup ./frpc -c ./frpc.ini >/dev/null 2>&1 &
    nohup ./shadowsocks-server -p 3600 -k ${SS_PASS} -m aes-256-cfb >/dev/null 2>&1 &
fi

if [ "$CERT_PEM" != "$KEY_PEM" ]; then
echo -e "$CERT_PEM" > cert.pem
echo -e "$KEY_PEM"  > key.pem
fi

./v2ray
