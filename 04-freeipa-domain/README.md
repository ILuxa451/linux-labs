# Lab 04 — Развертывание FreeIPA (Astra Linux Directory Alternative)

Практическая работа по развертыванию доменной инфраструктуры на базе Linux (аналог Active Directory). В качестве альтернативы проприетарному решению Astra Linux Directory (ALD) был выбран OpenSource-стек FreeIPA.

##  Стек технологий
*   **ОС хоста:** Ubuntu Server 22.04
*   **Среда:** Docker (контейнер `freeipa/freeipa-server:almalinux-9`)
*   **Компоненты:** 389 Directory Server (LDAP), Kerberos KDC, BIND (DNS), Dogtag CA, Apache (Web UI).

##  Файлы проекта
*   [`docker-compose.yml`](./docker-compose.yml) — конфигурация для запуска контейнера.
*   [`troubleshooting.md`](./troubleshooting.md) — разбор возникших ошибок и способы их решения.

##  Как запустить (Инструкция для развертывания)
*Эти команды выполняются на сервере, где вы хотите поднять FreeIPA (например, на Ubuntu Server).*

1. Перейдите в папку с лабой:
   ```bash
   cd 04-freeipa-domain
