# Linux Labs

Практические лабораторные по администрированию Linux.
Стек: Ubuntu Server 22.04, VirtualBox, netplan, systemd, UFW, OpenSSH.

## Использование
Репозиторий носит учебный характер. Все конфиги обезличены,
приватные ключи и пароли не хранятся.

## Цель
Систематизировать практические навыки и документировать решения
реальных проблем, с которыми сталкиваюсь при настройке.

## Лабораторные

### [Lab 01 — Базовая настройка сервера](./01-server-basics/)
- Статический IP через Netplan
- Hostname (FQDN), NTP
- UFW с минимально необходимыми правилами
- Hardening SSH (порт, отключение root/паролей, ключи Ed25519)

**Разобранные проблемы:** [troubleshooting](./01-server-basics/troubleshooting.md)
- `Network is unreachable` — неверный шлюз в netplan
- `Connection refused` на SSH
- DHCP после reboot — конфликт netplan ↔ cloud-init ↔ subiquity
- Зависание `ssh -T` при нескольких ключах
- Дублирование параметров в sshd_config

### [Lab 02 — systemd: службы и таймеры](./02-systemd/)
- Bash-скрипт резервного копирования с обработкой ошибок и логированием
- Системный пользователь `backup-user` без shell (принцип минимальных привилегий)
- `my-backup.service` типа `oneshot` с директивами безопасности
  (`NoNewPrivileges`, `PrivateTmp`, `ReadWritePaths`)
- `my-backup.timer` — ежедневный запуск с `Persistent=true`
- Проверена персистентность после reboot

### [Lab 03 — systemd: Socket Activation](#lab-03--systemd-socket-activation)

*   Реализация легковесного HTTP-сервера на Bash/awk
*   Шаблонный юнит `.service` (`Accept=yes`) с изоляцией от `hello-user`
*   Юнит `.socket` для запуска службы только при входящем запросе
*   Настройка `StandardInput/Output=socket` и отладка ошибок передачи дескрипторов

**Разобранные проблемы:** [troubleshooting](#troubleshooting)

*   Ошибка `126` из-за ограничений `ProtectHome`
*   Ошибка `Got no socket` при сокет-активации
*   Исправление ответа `HTTP/0.9` через корректные заголовки в `awk`

### [Lab 04 — FreeIPA: Развертывание Linux-домена](./04-freeipa-domain/)

*   Развертывание FreeIPA в Docker (LDAP, Kerberos, DNS, CA).
*   Настройка статического IP, FQDN и освобождение порта 53 (DNS).
*   Автоматизация установки через `--unattended` с параметрами домена.
*   Диагностика и ручной запуск служб (`dirsrv`, `krb5kdc`, `httpd`).

**Разобранные проблемы:** [troubleshooting](./04-freeipa-domain/)

*   Конфликт cgroups v2 (`--skip-mem-check`).
*   Конфликт с системным `systemd-resolved`.
*   Ошибка `ipa-client-install` в Docker и правка `resolv.conf`.
