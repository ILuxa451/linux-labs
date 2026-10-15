# Lab 02 — Управление службами и таймеры в systemd

## Среда
- Ubuntu Server 22.04 LTS в VirtualBox
- VM: `server01.example.com` (192.168.3.50)
- Продолжение [Lab 01](../01-server-basics/)

## Цель
Настроить автоматическое резервное копирование через systemd:
скрипт + сервис + таймер. Освоить `systemctl`, `journalctl`,
написание unit-файлов и директивы безопасности.

## Что сделано

### Скрипт резервного копирования
- Файл: `/usr/local/bin/my-backup.sh`
- Создаёт `tar.gz`-архив `/home/important-data/` в `/backup/`
- Имя архива: `backup-YYYYMMDD-HHMMSS.tar.gz` — **уникальное**,
  чтобы бэкапы не перезаписывались
- Логирование в `/var/log/my-backup.log`
- `set -euo pipefail`, проверки директорий, обработка ошибок
- → [my-backup.sh](./my-backup.sh)

### Пользователь сервиса
- `backup-user` — системный пользователь без shell (`/bin/false`)
- Владелец `/backup/` и `/var/log/my-backup.log`
- Принцип минимальной доступности: сервис не работает от root

### systemd-юнит
- Файл: `/etc/systemd/system/my-backup.service`
- Тип: `oneshot` — однократное выполнение
- `User=backup-user`, `Group=backup-user`
- Директивы безопасности:
  - `NoNewPrivileges=true` — запрет на получение новых привилегий
  - `PrivateTmp=true` — изолированный `/tmp`
  - `ReadWritePaths=/backup /var/log/my-backup.log` — только эти пути
- → [my-backup.service](./my-backup.service)

### systemd-таймер
- Файл: `/etc/systemd/system/my-backup.timer`
- `OnCalendar=daily` — запуск раз в день
- `Persistent=true` — догоняет пропущенные срабатывания после reboot
- `Unit=my-backup.service` — что запускать
- → [my-backup.timer](./my-backup.timer)

## Схема работы

    my-backup.timer (daily, enabled, Persistent=true)
            │
            │ в 00:00
            ▼
    my-backup.service (oneshot, User=backup-user)
            │
            │ ExecStart
            ▼
    /usr/local/bin/my-backup.sh
            │
            ├─ tar → /backup/backup-YYYYMMDD-HHMMSS.tar.gz
            └─ log → /var/log/my-backup.log

## Проверка

### Сервис
    systemctl status my-backup.service --no-pager
    # Active: inactive (dead) — норма для oneshot после успеха
    # Process: ... (code=exited, status=0/SUCCESS)

    journalctl -u my-backup.service -n 20 --no-pager
    # Starting / Deactivated successfully / Finished

### Таймер
    systemctl status my-backup.timer --no-pager
    # active (waiting), enabled

    systemctl list-timers --all | grep my-backup
    # NEXT = следующий запуск, ACTIVATES = my-backup.service

### Архивы
    sudo -u backup-user ls -la /backup/
    sudo -u backup-user cat /var/log/my-backup.log

### После reboot
    sudo reboot
    # После загрузки:
    systemctl status my-backup.timer --no-pager     # active (waiting)
    systemctl list-timers --all | grep my-backup    # виден в списке
    # Бэкап создаётся немедленно — сработал catch-up (Persistent=true)

## Чему научился
- Написание и управление systemd-юнитами (`[Unit]`, `[Service]`, `[Install]`)
- Тип `oneshot` и семантика статуса: `inactive (dead)` после успеха ≠ провал
- Написание таймеров systemd как альтернатива cron
- `Persistent=true` и `catch-up` поведение
- Директивы безопасности сервисов: `NoNewPrivileges`, `PrivateTmp`, `ReadWritePaths`
- Разделение логов: свой `/var/log/` vs системный `journalctl`
- Тестирование сервиса от того же пользователя, что запускает systemd
