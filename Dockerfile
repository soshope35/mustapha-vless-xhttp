FROM alpine:3.22

ARG XRAY_VERSION=26.9.8

RUN apk add --no-cache \
    ca-certificates \
    curl \
    unzip \
    tzdata

RUN set -eux; \
    curl -fsSL \
      "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip" \
      -o /tmp/xray.zip; \
    unzip /tmp/xray.zip xray -d /usr/local/bin/; \
    chmod +x /usr/local/bin/xray; \
    rm -f /tmp/xray.zip

WORKDIR /etc/xray

COPY config.json /etc/xray/config.json

# التحقق من صحة إعدادات Xray أثناء بناء الصورة
RUN /usr/local/bin/xray run -test -config /etc/xray/config.json

EXPOSE 8080

CMD ["/usr/local/bin/xray", "run", "-config", "/etc/xray/config.json"]
