# Rock the boat 

Rails приложение скачивающее трэки из vk.com используюя опреределенный поисковый запрос, с периодичностью раз в сутки.
Каждый трэк переконвертируется в битрэйт 128k и разбивается на части по одной минуте.

#### Требования

 * ffmpeg & ffprobe
 * PosgreSQL
 * Redis
 * Sidekiq


#### Конфигурация

 * Переименовать конфигурационные файлы, убрать '.example' в конце каждого файла (config/database.yml, config/secrets.yml, config/settings.yml), в настройках указать параметры вашей системы
 * Получить access_token от сервера vk.com и указать его в config/settings.yml, там-же поправить id приложения вконтакте, поисковый запрос и количество песен
 
Как получить токен? 
Создать standalone приложение вконтакте [https://vk.com/dev](https://vk.com/dev), используя полученный app_id:


```
gem install 'vk_api'
irb -r vkontakte_api
VkontakteApi.app_id = <your_app_id>
VkontakteApi.redirect_uri = 'http://oauth.vk.com/blank.html'
VkontakteApi.authorization_url(type: :client, scope: [:audio, :offline])

"https://oauth.vk.com/authorize?client_id=3133337&redirect_uri=http%3A%2F%2Foauth.vk.com%2Fblank.html&response_type=token&scope=audio%2Coffline"
```

Необходимо перейти по ссылке и разрешить приложению доступ к аудиозаписям пользователя. 
После чего скопировать из адресной строки браузера параметр acceess_token. 
Выглядеть он будет примерно так:

````
access_token=76bb122aa8449e52c3a165305213584ceaf0dd7422c76d4fe9b8d24ebc505a8e789cc465761076ad67777
````
Его и указываем в config/settings.yml

#### Запуск

````
bundle
rake db:setup
bundle exec sidekiq -d  -L /tmp/sidekiq.log -q carrierwave,10
rake app:download_tracks
rails s
````