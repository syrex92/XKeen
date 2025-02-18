opkg install tar bind-dig cron ipset xray
curl -s -L https://github.com/Skrill0/XKeen/releases/latest/download/xkeen.tar --output xkeen.tar && tar -xvf xkeen.tar -C /opt/sbin --overwrite > /dev/null && rm xkeen.tar
xkeen -i
mkdir /opt/etc/unblock
curl -s -L https://raw.githubusercontent.com/syrex92/XKeen/main/unblock/config --output /opt/etc/unblock/config
curl -s -L https://raw.githubusercontent.com/syrex92/XKeen/main/unblock/xkeen_parser.sh --output /opt/sbin/xkeen_parser
curl -s -L https://raw.githubusercontent.com/syrex92/XKeen/main/unblock/S24xray --output /opt/etc/init.d/S24xray
chmod +x /opt/sbin/xkeen_parser
echo "Настройте xray в папке /opt/etc/xray/configs и адреса для разблокировки в /opt/etc/unblock/config"
echo "После настройки запустите парсер xkeen_parser"