# Lab 10 - Развертывание системы мониторинга Prometheus

Этот проект содержит Ansible-роль для автоматической установки и настройки системы мониторинга **Prometheus** и агента **Node Exporter** на серверах.

## 📦 Что разворачивается?
1.  **Prometheus** — сервер сбора и хранения метрик (слушает порт 9090). Работает по Pull-модели.
2.  **Node Exporter** — агент, который собирает системные метрики (CPU, RAM, диски, сеть) и отдает их на порт 9100.

## 🚀 Как запустить?
1.  Убедитесь, что у вас установлен Ansible (`sudo apt install ansible`).
2.  Проверьте файл инвентаря `inventories/production/hosts.ini`. Убедитесь, что там указаны нужные вам группы серверов (`monitoring`, `appservers`, `dbservers`).
3.  Запустите главный плейбук (потребуется ввести пароль от `sudo`):
    ```bash
    ansible-playbook site.yml -i inventories/production/hosts.ini -K

## 🔍 Как проверить, что всё работает?

После успешного завершения плейбука (вывод failed=0), откройте в браузере интерфейс Prometheus:

## 👉 http://<IP-адрес_сервера>:9090

    Перейдите в раздел Status -> Targets.

    Напротив таргетов (Prometheus и Node Exporter) должен гореть статус UP зеленым цветом.

## 🐞 Решенные проблемы (Troubleshooting)

    Ошибка sudo: a password is required при локальном запуске:

        Причина: Ansible не мог получить права root для установки пакетов и создания systemd-юнитов.

        Решение: Использование флага -K при запуске плейбука для интерактивного ввода пароля (безопаснее, чем NOPASSWD).

    Ошибка Could not find or access 'Debian.yml':

        Причина: Роль пыталась загрузить переменные для семейства ОС Debian, но файла не существовало.

        Решение: Создан пустой файл roles/prometheus/vars/Debian.yml.

    Ошибка 'when' is not a valid attribute for a Play:

        Причина: В методичке атрибут when был ошибочно указан на уровне всего Play.

        Решение: Атрибут when перенесен внутрь блока roles для применения только к нужной роли.

    Веб-интерфейс Prometheus не открывался в браузере:

        Причина: Порт 9090 блокировался файрволом UFW.

        Решение: Открыт порт командой sudo ufw allow 9090/tcp.

## 📸 Визуализация

    Успешное выполнение Ansible-плейбука (идемпотентность):
    https://images/ansible-run-success.png

    Статус всех таргетов UP в веб-интерфейсе Prometheus:
    https://images/prometheus-targets-up.png

    Выполнение PromQL-запроса (график загрузки CPU):
    https://images/prometheus-cpu-graph.png
