cd /v2raybin
if [ "${CONFIG}" ]
then
    echo -e "${CONFIG}" > config.json
else
    echo -e -n "$CONFIG_JSON1" > config.json
    echo -e -n "$UUID" >> config.json
    echo -e -n "$CONFIG_JSON2" >> config.json
fi
if [ "$CERT_PEM" != "$KEY_PEM" ]; then
echo -e "$CERT_PEM" > cert.pem
echo -e "$KEY_PEM"  > key.pem
fi
./v2ray
