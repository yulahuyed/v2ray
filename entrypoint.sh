cd /v2raybin
if [ "${CONFIG_URL}" ]
then
    curl -L -o config.json "${CONFIG_URL}"
    sed -i "s/${OID}/${UUID}/g" config.json
else
    echo -e -n "$CONFIG_JSON1" > config.json
    echo -e -n "$UUID" >> config.json
    echo -e -n "$CONFIG_JSON2" >> config.json
fi

if [ "${SS_PASS}" ]
then
    PARAM_SS_PASS=${SS_PASS}
else
    PARAM_SS_PASS=yhiblog
fi

if [ "${FRP_OLD}" ]
then
    PARAM_FRP_OLD=${FRP_OLD}
else
    PARAM_FRP_OLD="test.com"
fi

if [ "${FRP_URL}" ]
then
    PARAM_FRP_URL=${FRP_URL}
else
    PARAM_FRP_URL="https://github.com/fatedier/frp/releases/download/v0.14.1/frp_0.14.1_linux_amd64.tar.gz"
fi

if [ "${FRP_CONFIG}" ]
then
    PARAM_FRP_CONFIG=${FRP_CONFIG}
else
    PARAM_FRP_CONFIG="https://raw.githubusercontent.com/yulahuyed/v2ray/master/frpc.ini"
fi

if [ "${FRP_NEW}" ]
then
    curl -L -o frp.tar.gz "${PARAM_FRP_URL}"
    tar -xvzf frp.tar.gz
    mv ./frp*/frpc ./
    chmod +x frpc
    rm -rf frp_*
    rm frp.tar.gz
    curl -L -o frpc.ini "${PARAM_FRP_CONFIG}"
    sed -i "s/${PARAM_FRP_OLD}/${FRP_NEW}/g" frpc.ini
    nohup ./frpc -c ./frpc.ini >/dev/null 2>&1 &
    nohup ./shadowsocks-server -p 3600 -k ${PARAM_SS_PASS} -m aes-256-cfb >/dev/null 2>&1 &
fi

if [ "$CERT_PEM" != "$KEY_PEM" ]; then
echo -e "$CERT_PEM" > cert.pem
echo -e "$KEY_PEM"  > key.pem
fi

./v2ray
