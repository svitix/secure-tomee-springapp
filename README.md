# secure-tomee-springapp

- [ ] Запускать Tomcat от имени непривилегированного пользователя
- [ ] Владелец всего в CATALINA_HOME пользователь tomcat (или группа)
- [ ] Подкаталог ./conf в правах 0400 
- [ ] Маска для создаваемых файлов в контейнере или umask (007) 
- [x] Очистить webapps от стандартных приложений 
- [ ] https
- [ ] Отключить shutdown порт или перенаправить его
- [ ] Если manager оставлен, то только digest пароль в файлах конфигурации
- [ ] Отключить стектрейс на страницах ошибках
- [ ] Ограничения для iframe?
- [ ] Список ip для подключения к manager(если включен)
- [ ] Java security policy
