# Troubleshooting — Lab 01

Разбор реальных проблем, возникших при настройке сервера.
Формат: **симптом → диагностика → причина → решение → урок**.

## 1. Network is unreachable

**Симптом:** `ping 8.8.8.8` → `Network is unreachable`

**Диагностика:**
- `ip a` — адрес `192.168.3.50/24` на месте
- `ip r` — default route отсутствует

**Причина:** в netplan указан шлюз `192.168.1.1` вместо `192.168.3.1` —
шлюз вне подсети интерфейса.

**Решение:** исправил `via` на `192.168.3.1`, применил `netplan try` → `netplan apply`.

**Урок:** шлюз по умолчанию обязан быть в той же подсети, что и интерфейс.

---

## 2. Connection refused на SSH

**Симптом:** `nc -zv 192.168.3.50 22` → `Connection refused`

**Диагностика:**
- сеть работает (иначе был бы `timeout`)
- `systemctl status ssh` → `Unit ssh.service could not be found`

**Причина:** `openssh-server` не установлен.

**Решение:** `apt install openssh-server -y`, `systemctl enable --now ssh`.

**Урок:** `Connection refused` = сеть работает, но сервис не слушает.

---

## 3. DHCP-адрес после reboot (главный кейс)

**Симптом:** после reboot VM получила `192.168.3.101` по DHCP,
хотя в netplan прописан статический `192.168.3.50`.

**Диагностика:**
- `ip a` → `dynamic` вместо `static`
- `ls /etc/cloud/cloud.cfg.d/` → найден `90-installer-network.cfg`
- `cat` этого файла → `dhcp4: true`

**Причина:** конфиг установщика subiquity (`90-installer-network.cfg`)
через cloud-init перебивал наш netplan-конфиг при каждой загрузке.

**Решение:**
1. Отключил файл: `mv 90-installer-network.cfg 90-installer-network.cfg.disabled`
2. Создал `/etc/cloud/cloud.cfg.d/99-disable-network-config.cfg`
   с содержимым `network: {config: disabled}` — отключил модуль `cc_netplan`.
3. Проверил после reboot — конфиг персистентный.

**Урок:** в Linux может быть несколько источников истины для одной настройки
(netplan, cloud-init, subiquity, NetworkManager). Всегда ищи, **кто реально
применяет** конфиг.

---

## 4. Зависание `ssh -T git@github.com`

**Симптом:** аутентификация проходит (`Hi ILuxa451!`), но терминал
не возвращает приглашение.

**Диагностика:** `ssh -vT` показал перебор двух ключей из `ssh-agent`
(`id_ed25519` и `id_ed25519_github`) — первый отклонён, второй принят.

**Причина:** отсутствие `Host github.com` в `~/.ssh/config` с явным
`IdentityFile`. SSH не знал, какой ключ использовать, и перебирал все.

**Решение:** добавлен блок:

    Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519_github

**Урок:** при нескольких SSH-ключах в системе всегда разделяй их через
`~/.ssh/config` с явным `IdentityFile` для каждого хоста.

---

## 5. Конфликт дублирования в sshd_config

**Симптом:** `X11Forwarding` был указан дважды (в основном блоке `yes`,
в конце файла — `no` с отступом). Непонятно, какое значение применяется.

**Диагностика:** `sudo grep -n -i x11forwarding /etc/ssh/sshd_config` —
два вхождения. `sudo sshd -T | grep x11forwarding` — итоговое значение `yes`.

**Причина:** при ручной правке добавлена новая строка, старая не удалена.

**Решение:** удалил дубликат, оставил одну активную строку без отступа.

**Урок:** после правки конфигов демонов всегда проверяй **итоговое**
значение через `<daemon> -T`, а не полагайся на глаза. Один параметр —
одно значение.
