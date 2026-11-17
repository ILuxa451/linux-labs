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

### [Lab 05 — Файловый сервер Linux: NFS и Samba](./05-nfs-samba/)

*   Развертывание NFS-сервера для Linux-клиентов (экспорт каталогов, `root_squash`).
*   Установка и настройка Samba с интеграцией в домен Active Directory (`realm join`, `net ads join`).
*   Проверка доменной аутентификации через `wbinfo` и `getent`.
*   Монтирование Windows-шары с Linux-клиента через CIFS (`cifs-utils`).

**Разобранные проблемы:** [troubleshooting](./05-nfs-samba/)

*   Проблемы с DNS (`Temporary failure in name resolution`) и Kerberos (кириллическое имя администратора).
*   Конфликт `sssd` и `winbind` при вводе в домен.
*   Известная проблема совместимости Windows 11 24H2 и Samba 4.15 (ошибка 67 при подключении к SMB-шаре).
*   Баг Samba 4.15: Нестабильная работа `winbind` после пересоздания keytab (службы временно отключены для стабильности сервера).

### [Lab 06 — Git для инфраструктуры (IaC)](./06-git-infra/)

*   Создание структуры инфраструктурного репозитория (best practices).
*   Настройка `.gitignore` для защиты секретов (ключи, сертификаты, пароли).
*   Работа с историей: откат коммитов (`git revert`), ветвление (`hotfix`), слияние (`merge`).
*   Продвинутые практики: `git stash`, поиск по истории (`git blame`, `git log -S`).
*   Настройка `pre-commit` хука для автоматической проверки Bash-скриптов через `shellcheck`.

**Разобранные проблемы:** [troubleshooting](./06-git-infra/)

*   Проблема с путями при создании Git-хуков в подпапке (решение через абсолютные пути).
### [Lab 07 — Автоматизация с Ansible](./07-ansible/)

*   Установка и настройка Ansible (Control Node + Managed Node).
*   Настройка SSH-доступа без пароля (`ssh-copy-id`).
*   Создание Inventory (`inventory.ini`) и проверка связи (`ansible -m ping`).
*   Выполнение ad-hoc команд (управление пакетами, копирование файлов).
*   Написание Playbook: `bootstrap.yml` (базовые настройки) и `deploy_nginx.yml` (установка Nginx + кастомная страница с Jinja2 + Handlers).

**Разобранные проблемы:** [troubleshooting](./07-ansible/)

*   Ошибка `Missing sudo password` (решено настройкой NOPASSWD в sudoers на клиенте).
*   Ошибка `Permission denied (publickey)` при запуске Ansible через `sudo` (решено запуском от имени обычного пользователя).

### [Lab 08 — Продвинутый Ansible (Templates, Vars, Handlers)](./08-ansible-advanced/)

*   Структурирование переменных (`group_vars`, `host_vars`).
*   Использование Jinja2-шаблонов для генерации конфигов Nginx.
*   Циклы (`loop`) и условные операторы (`when`, `if`).
*   Хендлеры для перезагрузки служб при изменении конфигов.
*   Генерация самоподписанных SSL-сертификатов.

**Разобранные проблемы:** [troubleshooting](./08-ansible-advanced/)

*   Решение ошибок `item is undefined` и `undefined variable` при использовании циклов и условий.
*   Настройка прав доступа к SSL-ключам для Nginx.

### [Lab 09 — Ansible Roles: Продвинутая оркестрация (PostgreSQL + Django)](./09-ansible-roles/)

*   Создание переиспользуемых ролей (`postgresql`, `django_app`) через `ansible-galaxy init`.
*   Разделение логики по файлам (`tasks`, `defaults`, `handlers`, `templates`, `vars`).
*   Написание шаблона конфига `postgresql.conf.j2`.
*   **Связывание ролей:** Главный плейбук `site.yml` оркестрирует работу обеих ролей.
*   **Разделение хостов (теги):** Логическое разделение на `dbservers` и `appservers` в `site.yml` с использованием тегов (`--tags database`, `--tags application`).
*   **Передача данных через Facts:** Получение IP-адреса БД через `ansible_default_ipv4` и передача его в роль приложения через `hostvars` и `set_fact`.
*   **Управление секретами (Ansible Vault):** Шифрование паролей БД в `group_vars/prod/vault.yml` и запуск плейбука с `--ask-vault-pass`.
*   **CI/CD и Molecule:** Настройка `yamllint`, `ansible-lint` и GitHub Actions (`.github/workflows/ci.yml`). Инициализация тестового сценария в Molecule.
*   **Идемпотентность:** Настройка тасков (создание маркер-файлов) для обеспечения `changed=0` при повторных запусках.

**Разобранные проблемы:** [troubleshooting](./09-ansible-roles/)

*   Решение конфликтов YAML при инициализации роли.
*   Адаптация под версию PostgreSQL в Ubuntu 20.04 (откат с 14 на 12).
*   Отладка прав доступа (`become`) и NOPASSWD в sudoers.
*   Ошибка `undefined variable 'db_host_ip'` при запуске с тегами (решено через `tags: always`).
*   Разрешение подключения к БД по внешнему IP в `pg_hba.conf`.
*   Исправление неидемпотентного запуска миграций Django (использование `creates`).

### [Lab 10 — Ansible: Мониторинг (Prometheus)](./10-ansible-monitoring/)

*   Создание роли Ansible для установки Prometheus из бинарников (в обход apt).
*   Настройка Node Exporter для сбора системных метрик (CPU, RAM, Диски).
*   Генерация конфигурации Prometheus через шаблоны Jinja2.
*   Работа с Pull-моделью сбора метрик.

**Разобранные проблемы:** [troubleshooting](./10-ansible-monitoring/)

*   Ошибка `when` is not a valid attribute for a Play (исправление логики плейбука).
*   Отсутствие файла `Debian.yml` при вызове `include_vars`.
*   Блокировка порта 9090 файрволом UFW.
*   Проблема с `sudo` при локальном запуске Ansible.

### [Lab 11 — Ansible: Визуализация (Grafana)](./11-ansible-monitoring/)

*   Создание роли Ansible для установки Grafana из бинарников.
*   Настройка автоматического подключения к Prometheus через Provisioning.
*   Автоматическая загрузка готовых дашбордов с grafana.com (ID 1860).
*   Создание собственных панелей визуализации (PromQL).

**Разобранные проблемы:** [troubleshooting](./11-ansible-monitoring/)

*   Отсутствие файла `Debian.yml` при вызове `include_vars`.
*   Блокировка порта 3000 файрволом UFW.
*   Ошибка парсинга YAML (DataSource provisioning error) в Grafana.
*   Проблема с именованием папок при создании симлинков (grafana-v10.4.2).

### [Lab 12 — Ansible: Централизованное логирование (ELK Stack)](./12-ansible-elk/)

*   Создание ролей Ansible для развертывания Elasticsearch, Kibana и Filebeat.
*   Настройка системных параметров (`vm.max_map_count`) для работы Elasticsearch.
*   Обход блокировки официальных репозиториев Elastic (использование зеркала Яндекса).
*   Поиск по логам в Kibana с помощью языка KQL.

**Разобранные проблемы:** [troubleshooting](./12-ansible-elk/)

*   Ошибка `403 Forbidden` при скачивании Elasticsearch/Filebeat (решено использованием зеркала Яндекса).
*   Ошибка `node settings must not contain any index level settings` (удалены устаревшие настройки из конфига).
*   Ошибка `Unknown configuration key(s): "kibana.index"` (параметр удален в Kibana 8.x).
*   Падение службы Kibana из-за ошибки `xpack.security.enabled` (параметр удален из конфига).
