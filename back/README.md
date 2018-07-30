# BANKEX KYC Demo (backend)

# Getting Started

### Require
* NodeJS version >= 8.9

### Install
1. `git clone` this repo
2. `npm install`
3. configure yamls in `config` dir. There is `development.example.yaml` for edit.

### Run
Environments run:
* development: `npm run development`
* staging:
    - make dir build
    - `npm run build`
    - `npm run staging`
* production:
    - make dir build
    - `npm run build`
    - `npm run production`

### Usage
Development. Server running on 127.0.0.1:7000. Test page - /api/testapi

### API

Действующие лица:
1. Main - приложение, которое хочет получить KYC-данные 
2. Desktop - фронт KYC сервера
3. Server - собственно сам KYC-сервер
4. Mobile - приложение на мобильном устройстве, являющееся "паспортом" юзера

> Предполагается, что на Main есть виджет с кнопкой "Start KYC". При нажатии этой кнопки происходит открытие нового окна браузера Desktop с экраном 1 и query-запросом передается адрес mainURL.
Desktop делает первичное обращение на сервер для получения sessionId через `GET /api/desktop/getSession`

`GET /api/desktop/getSession`
1. Ответ сервера - sessionId. Сервер устанавливает http cookie sessionId
2. При получении ответа сервера Desktop формирует QR-код `POST /api/mobile/setConnection` c параметрами { mainURL, sessionId }
4. Desktop подписывается по сокетам на комнату sessionId и ожидает команду для перехода на экран 2
5. Если Desktop уже содержит куку sessionId, сервер проверяет есть ли данный ключ sessionId в объекте sessions. Если ключ есть - осуществить перевод на экран 2 или 3

> Мобильное приложение считывает QR-код, получая адрес KYC сервера, sessionId, mainURL. Мобилка формирует eth-аккаунт и publicKey и посылает `POST /api/mobile/setConnection` 

`POST /api/mobile/setConnection`
1. Поля POST запроса: { sessionId, mainURL, publicKey, signature }
2. Сервер заполняет поля объекта (в последствии временной БД) sessions: { sessionId: { mainURL, publicKey, signature }}
3. Отправляет сокет на desktop для перехода на экран 2.

> Desktop, приняв сокет, переходит на экран 2 и делает запрос `GET /api/desktop/getFields`

`GET /api/desktop/getFields`
1. Сервер проверяет sessionId.
2. Отдает список полей и их типы предназначенные для заполнения формы предназначенные для данного mainURL. На основании этого списка браузер формирует форму заполнения.

> Пользователь вводит данные, нажимает кнопку "Отправить". Desktop отправляет данные через `POST /api/destop/saveFields`

`POST /api/destop/saveFields`
1. Передает JSON всех полей.
2. Снова проверка авторизации и истечения сессии.
3. Сервер дописывает поля в объект session для данного sessionId.
4. Сервер формирует merkleTree, rootHash, создает сертификат на БЧ.
5. Дописывает rootHash в `session[sessionId]`.
5. При успешном выполнении отвечает 'Ok'

> Desktop при получении Ok открывает экран 3. Предварительно сделав запрос `GET /api/desktop/checkData`

`GET /api/desktop/checkData`
1. Проверка сервером авторизации и полного заполнения полей KYC-формы.
2. Отвечает 'Ok'

> При ответе 'Ok' Desktop формирует QR-код `POST /api/mobile/getData` с параметром sessionId. Desktop подписывается на сокет успешного скачивания данных.

`POST /api/mobile/getData`
1. Поля POST запроса: { sessionId, signature }
2. При положительной аутентификации сервер отдает все данные из объекта `session[sessionId]`.
3. (можно сделать проверку хэш-сумм загруженных данных, но пока без этого)
4. Сервер удаляет данные пользователя `session[sessionId]`
5. Посылает сокет успешного скачивания десктопному браузеру. (при получении десктопный браузер возвращается в исходное состояние, куки удаляются)

