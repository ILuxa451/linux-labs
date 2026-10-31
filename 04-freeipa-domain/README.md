# Lab 04 — Развертывание FreeIPA

Практическая работа по развертыванию доменной инфраструктуры на базе Linux (альтернатива ALD/Astra Linux Directory). Выбран OpenSource-стек FreeIPA.

##  Стек
*   Docker (образ `freeipa/freeipa-server:almalinux-9`)
*   389 Directory Server (LDAP), Kerberos, BIND (DNS), Dogtag CA.

##  Файлы проекта
*   [`docker-compose.yml`](./docker-compose.yml) — конфигурация для запуска контейнера.
*   [`troubleshooting.md`](./troubleshooting.md) — разбор возникших ошибок и способы их решения.

## Как запустить
1. Перейдите в папку с лабой:
   ```bash
   cd 04-freeipa-domain
