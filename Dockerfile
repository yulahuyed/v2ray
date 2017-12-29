FROM alpine:latest

ENV CONFIG_JSON1="{\n  \"log\": {\n    \"loglevel\": \"warning\"\n  },\n  \"inbound\": {\n    \"protocol\": \"vmess\",\n    \"port\": 8080,\n    \"settings\": {\n      \"clients\": [\n        {\n          \"id\": \""
ENV UUID="38c9e20b-f90f-4bc6-a909-fa2b10917925"
ENV CONFIG_JSON2="\",\n          \"alterId\": 64,\n          \"security\": \"none\"\n        }\n      ]\n    },\n    \"streamSettings\": {\n      \"network\": \"ws\"\n    }\n  },\n  \"inboundDetour\": [],\n  \"outbound\": {\n    \"protocol\": \"freedom\",\n   \"settings\": {}\n  }\n}"
ENV CERT_PEM=none
ENV KEY_PEM=none
ENV VER=3.5

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && mkdir -m 777 /v2raybin \ 
 && cd /v2raybin \
 && curl -L -H "Cache-Control: no-cache" -o v2ray.zip https://github.com/v2ray/v2ray-core/releases/download/v$VER/v2ray-linux-64.zip \
 && unzip v2ray.zip \
 && mv /v2raybin/v2ray-v$VER-linux-64/v2ray /v2raybin/ \
 && mv /v2raybin/v2ray-v$VER-linux-64/v2ctl /v2raybin/ \
 && mv /v2raybin/v2ray-v$VER-linux-64/geoip.dat /v2raybin/ \
 && mv /v2raybin/v2ray-v$VER-linux-64/geosite.dat /v2raybin/ \
 && chmod +x /v2raybin/v2ray \
 && rm -rf v2ray.zip \
 && rm -rf v2ray-v$VER-linux-64 \
 && chgrp -R 0 /v2raybin \
 && chmod -R g+rwX /v2raybin 
 
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh 

ENTRYPOINT  /entrypoint.sh 

EXPOSE 8080
