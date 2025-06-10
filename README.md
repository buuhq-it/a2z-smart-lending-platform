# a2z-smart-lending-platform

## Database
- dbms: postgresql
- dùng docker install
- docker command:
```shell
cd docker
docker compose --env-file .env -p a2z-smart-lending up -d

## check
docker ps
```
- tạo db cho backend
```text
access adminer
url: http://localhost:9001/
- System: PostgreSQL
- Server: postgres
- Username: postgres
- Password: Password123

Chọn create database
tạo db với tên: a2z_smart_lending_db
```

## Backend
- stack: java, maven, springboot3, postgresql
- jdk: 21
- repo path: ./backend/smart-lending-be
- app module: ./backend/smart-lending-be/smart-lending-api/smart-lending-rest-app
- config file: smart-lending-rest-app/application.yml
- build/run command
```shell
cd ./backend/smart-lending-be
## check jdk
java --version
## build app
mvnw clean install
## run app
mvnw spring-boot:run -pl modules\smart-lending-api\smart-lending-rest-app
```
```text
url api doc: http://localhost:9091/swagger-ui/index.html
```


## Frontend
- stack: angular 19
- nodejs: 22 lts
- repo path: ./frontend/smart-lending-los
- build/run command
```shell
cd ./frontend/smart-lending-los
## check nodejs
node --version
## install angular cli
npm install -g @angular/cli
npm install -g serve

## install nodejs packages
npm install

## run project
ng serve
## run project with specific port
ng serve --port 4201

## build project: dùng khi deploy local không cần chạy
ng build
## run built project 
serve -s dist/smart-lending-los/browser
```
```text
url: url: http://localhost:4200/
```

## Frontend SAKAI UI template
```text
- Là template mẫu viết bằng angular, primeng, tailwindcss
- start lên để lấy ý tưởng các trang UI dùng cho project chính frontend/smart-lending-los
```
```shell
## Các lệnh chạy project này
cd ./frontend/sakai-ng
npm install -g @angular/cli

npm install
ng serve --port 4202
```
```text
url: http://localhost:4202/
```


## AI services
- stack: python, fastapi
- repo path: ./backend/ai-service
- build/run command:
```shell
cd ./backend/ai-service
## create virtual env
python -m venv .venv
## active virtual env
.venv\Scripts\activate
## install packages
pip install -r requirements.txt

## run project
uvicorn main:app --reload
## run project with port
uvicorn main:app --reload --port 9092
```
```text
url: http://localhost:9092
open api doc: http://localhost:9092/docs
```