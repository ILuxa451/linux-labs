Lab 04 — Развертывание FreeIPA (Astra Linux Directory Alternative)

Практическая работа по развертыванию доменной инфраструктуры на базе Linux (аналог Active Directory). В качестве альтернативы проприетарному решению Astra Linux Directory (ALD) был выбран OpenSource-стек FreeIPA.
 Стек технологий

    ОС хоста: Ubuntu Server 22.04

    Среда: Docker (контейнер freeipa/freeipa-server:almalinux-9)

    Компоненты: 389 Directory Server (LDAP), Kerberos KDC, BIND (DNS), Dogtag CA, Apache (Web UI).

 Файлы проекта

    docker-compose.yml — конфигурация для запуска контейнера.

    troubleshooting.md — разбор возникших ошибок и способы их решения.

 Как запустить (Инструкция для развертывания)

Эти команды выполняются на сервере, где вы хотите поднять FreeIPA (например, на Ubuntu Server).

    Перейдите в папку с лабой:

    cd 04-freeipa-domain

    Отключите системный DNS (чтобы освободить порт 53 для FreeIPA):

    sudo systemctl stop systemd-resolved
    sudo systemctl disable systemd-resolved

    Запустите контейнер (рекомендуется Docker Compose V2):

    docker compose up -d

    Веб-интерфейс будет доступен по адресу: https://ipa.astra.lab/ipa/ui

Важно: В текущей конфигурации Docker-образа установщик может упасть на этапе ipa-client-install из-за бага изоляции сети Docker. Однако сам сервер (LDAP, Kerberos, DNS) поднимается успешно. Подробнее в troubleshooting.

