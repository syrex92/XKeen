#!/bin/sh
read_input() {
    local prompt="$1"
    local default="$2"
    read -p "$prompt [$default]: " input
    echo "${input:-$default}"
}

curl -s -L https://github.com/Skrill0/XKeen/releases/latest/download/xkeen.tar --output xkeen.tar && tar -xvf xkeen.tar -C /opt/sbin --overwrite > /dev/null && rm xkeen.tar
opkg install tar bind-dig cron ipset xray
xkeen -i
mkdir /opt/etc/unblock

GATEWAY=$(read_input "Введите адрес VPN сервера" "123.123.123.123")
COUNTRIES=$(read_input "Введите коды стран (разделите пробелом)" "ru by")
cat << EOF > /opt/etc/unblock/config
GATEWAY="$GATEWAY"
COUNTRIES="$COUNTRIES"
FILE="/opt/etc/unblock/unblock-list.txt"
TEMPFILE="/opt/etc/unblock/temp.txt"
EOF

echo "" > /opt/etc/unblock/unblock-list.txt

curl -s -L https://raw.githubusercontent.com/syrex92/XKeen/main/unblock/parser.sh --output /opt/sbin/xkeen_parser
curl -s -L https://raw.githubusercontent.com/syrex92/XKeen/main/unblock/S24xray --output /opt/etc/init.d/S24xray
chmod +x /opt/sbin/xkeen_parser
echo "Настройте xray в папке /opt/etc/xray/configs"
echo "После настройки запустите парсер xkeen_parser"