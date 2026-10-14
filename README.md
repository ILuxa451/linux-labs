# Linux Labs

Практические лабораторные по администрированию Linux.
Стек: Ubuntu Server 22.04, VirtualBox, netplan, systemd, UFW, OpenSSH.

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

### Lab 02 — (будет)

## Что дальше
- systemd-юниты для своих сервисов
- nginx как reverse proxy
- Ansible для управления несколькими хостами
- Docker

## Использование
Репозиторий носит учебный характер. Все конфиги обезличены,
приватные ключи и пароли не хранятся.
