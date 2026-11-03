# Политика безопасной настройки SSH

## Внесенные изменения
1. Отключён вход под root (PermitRootLogin no).
2. Изменён порт на 2222.
3. Включена аутентификация по ключу (PasswordAuthentication no).

## Команда для применения
sudo cp configs/ssh/sshd_config /etc/ssh/
sudo systemctl restart sshd
