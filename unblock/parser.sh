#!/bin/sh


logger_msg() {
  logger -s -t parser "$1"
}

logger_failure() {
  logger_msg "Error: ${1}"
  exit 1
}

CONFIG="/opt/etc/unblock/config"
if [ -f "$CONFIG" ]; then
  . "$CONFIG"
else
  logger_failure "Не удалось обнаружить файл \"config\"."
fi

for _tool in dig grep ip rm seq sleep; do
  command -v "$_tool" >/dev/null 2>&1 || \
  logger_failure "Для работы скрипта требуется \"${_tool}\"."
done

PIDFILE="${PIDFILE:-/tmp/parser.sh.pid}"
[ -e "$PIDFILE" ] && logger_failure "Обнаружен файл \"${PIDFILE}\"."
( echo $$ > "$PIDFILE" ) 2>/dev/null || logger_failure "Не удалось создать файл \"${PIDFILE}\"."
trap 'rm -f "$PIDFILE"' EXIT
trap 'exit 2' INT TERM QUIT HUP

logger_msg "Удаляем файл и скачиваем новые диапазоны IP по кодам стран"
rm $TEMPFILE
cp $FILE $TEMPFILE
for code in $COUNTRIES
do
  logger_msg "Скачиваем диапазоны для $code"
  curl -s https://raw.githubusercontent.com/ipverse/rir-ip/master/country/$code/ipv4-aggregated.txt | grep -v '^#' >> $TEMPFILE
done
rm $TEMPFILE.sh
cp $TEMPFILE $TEMPFILE.sh
sed -i '/^#/d' $TEMPFILE.sh
sed -i 's/^/ipset add ru /g' $TEMPFILE.sh
sed -i '1i ipset create ru nethash' $TEMPFILE.sh
sed -i '1i ipset flush ru' $TEMPFILE.sh
chmod +x $TEMPFILE.sh
$TEMPFILE.sh
ipset add ru $COUNTRIES
xkeen -start

exit 0