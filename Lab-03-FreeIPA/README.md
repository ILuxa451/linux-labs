# Lab 03 — Развертывание FreeIPA (Astra Linux Directory Alternative)

Практическая работа по развертыванию доменной инфраструктуры на базе Linux (аналог Active Directory). В качестве альтернативы проприетарному решению Astra Linux Directory (ALD) был выбран OpenSource-стек FreeIPA.

## 🛠️ Стек технологий
*   **ОС хоста:** Ubuntu Server 22.04
*   **Среда:** Docker (контейнер `freeipa/freeipa-server:almalinux-9`)
*   **Компоненты:** 389 Directory Server (LDAP), Kerberos KDC, BIND (DNS), Dogtag CA, Apache (Web UI).

## 🚀 Что было сделано:
1.  **Подготовка среды:** Настроен статический IP и FQDN (`ipa.astra.lab`), отключен конфликтующий `systemd-resolved` (освобожден порт 53).
2.  **Развертывание контейнера:** Запущен контейнер FreeIPA с пробросом портов (80, 443, 389, 636, 88, 464, 53) и флагами `--privileged` и `--cgroupns=host` для корректной работы systemd внутри Docker.
3.  **Установка домена:** Автоматизирована установка через `--unattended` (настройка домена `astra.lab`, realm `ASTRA.LAB`, DNS forwarder `8.8.8.8`).
4.  **Ручное восстановление служб:** После падения установщика на этапе настройки клиента, вручную запущены службы `dirsrv`, `krb5kdc`, `httpd` и исправлен `/etc/resolv.conf`.
5.  **Веб-интерфейс:** Панель управления FreeIPA успешно запущена и доступна по адресу `https://ipa.astra.lab/ipa/ui`.

## 🐞 Разобранные проблемы (Troubleshooting):
*   **`Unable to determine the amount of available RAM`:** Конфликт cgroups v2 в Ubuntu. Решено добавлением флага `--skip-mem-check`.
*   **`address already in use (port 53)`:** Конфликт с системным DNS. Решено отключением `systemd-resolved` на хосте.
*   **`ipa-client-install` падает с ошибкой `LDAP server is not responding`:** Известный баг контейнера на Ubuntu (изоляция сети Docker). Установка прерывается на этапе настройки клиентской части, однако **все серверные компоненты (LDAP, Kerberos, DNS) успешно установлены и работают**.
*   **`kinit: Cannot contact any KDC`:** Внутри контейнера `resolv.conf` указывал на `8.8.8.8`. Исправлено на `nameserver 127.0.0.1`.

## 📊 Выводы:
Несмотря на то, что автоматический установщик не смог завершить настройку клиентской части (баг Docker-образа), все ключевые компоненты домена (LDAP-каталог, Kerberos, DNS) были успешно развернуты и запущены. Веб-интерфейс FreeIPA доступен для управления.

**Навыки:** Понимание архитектуры доменов (LDAP, Kerberos), работа с Docker, диагностика сетевых проблем и конфликтов служб, ручное управление службами systemd.
