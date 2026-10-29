### Lab 03 — systemd: Socket Activation

  * Реализация легковесного HTTP-сервера на Bash/awk
  * Шаблонный юнит `.service` (`Accept=yes`) с изоляцией от `hello-user`
  * Юнит `.socket` для запуска службы только при входящем запросе
  * Настройка `StandardInput/Output=socket` и отладка ошибок передачи дескрипторов

**Разобранные проблемы:** troubleshooting

  * Ошибка `126` из-за ограничений `ProtectHome`
  * Ошибка `Got no socket` при сокет-активации
  * Исправление ответа `HTTP/0.9` через корректные заголовки в `awk`
