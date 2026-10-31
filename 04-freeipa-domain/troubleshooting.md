# Troubleshooting: FreeIPA в Docker на Ubuntu

В процессе развертывания мы столкнулись с рядом проблем, характерных для запуска FreeIPA в контейнерах на хостах с cgroups v2 (Ubuntu 22.04+).

## 1. Unable to determine the amount of available RAM
**Причина:** Установщик FreeIPA не может прочитать лимиты памяти из `/sys/fs/cgroup/memory.max` из-за изоляции Docker.
**Решение:** Добавлен флаг `--skip-mem-check` в команду запуска.

## 2. address already in use (port 53)
**Причина:** На хосте работает `systemd-resolved`, который занимает 53 порт (DNS).
**Решение:** Выполнено отключение службы: `systemctl stop systemd-resolved && systemctl disable systemd-resolved`.

## 3. ipa-client-install падает с ошибкой "LDAP server is not responding"
**Причина:** Известный баг образа `freeipa-server:almalinux-9` при работе с сетью Docker. Установщик не может завершить настройку клиентской части, так как не видит сервер LDAP по внутреннему имени.
**Решение:** Серверные компоненты (LDAP, Kerberos, DNS) были успешно установлены. После падения установщика службы были запущены вручную:
```bash
systemctl start dirsrv@ASTRA-LAB.service
systemctl start krb5kdc
systemctl restart httpd
