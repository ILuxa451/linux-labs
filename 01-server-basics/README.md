# Lab 01 — Базовая настройка Ubuntu Server

## Среда
- Ubuntu Server 22.04 LTS в VirtualBox (Bridged Adapter)
- Подсеть: 192.168.3.0/24, шлюз 192.168.3.1
- Хост-машина: Linux Mint

## Что сделано

### Сеть
- Статический IP: `192.168.3.50/24`
- Маршрут по умолчанию: `via 192.168.3.1`
- DNS: `192.168.3.1`, `8.8.8.8`, `1.1.1.1`
- На роутере разделены диапазоны:
  - DHCP: `192.168.3.100–254`
  - Статика: `192.168.3.2–99`
- Файл: `/etc/netplan/50-cloud-init.yaml` → [netplan.yaml](./netplan.yaml)

### Идентификация
- Hostname: `server01.example.com`
- `/etc/hosts`: строка `127.0.1.1 server01.example.com server01`

### Время
- Timezone: `Europe/Moscow`
- NTP: `systemd-timesyncd`, активен, synchronized: yes

### Безопасность
- UFW: `active`, разрешён только `2222/tcp` → [ufw-status.txt](./ufw-status.txt)
- SSH:
  - порт `2222`
  - `PermitRootLogin no`
  - `PasswordAuthentication no`
  - `PubkeyAuthentication yes`
  - `MaxAuthTries 3`
  - `X11Forwarding no`
  - → [sshd_config](./sshd_config)
- Аутентификация: ключи Ed25519
- Клиентский `~/.ssh/config` → [ssh-config-example](./ssh-config-example)

## Ключевые проблемы, разобранные в процессе
→ [troubleshooting.md](./troubleshooting.md)

## Проверка
- `ssh vm` работает по ключу
- `sudo sshd -T | grep port` → `port 2222`
- `timedatectl` → Europe/Moscow, NTP active
- Конфигурация переживает `reboot`
