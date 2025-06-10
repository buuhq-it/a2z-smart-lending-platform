```text
package: smart.lending.*
```

```shell
mvnw clean install
./mvnw install && ./mvnw spring-boot:run -pl modules\smart-lending-api\smart-lending-rest-app

```
```shell
## python
cd backend\ai-services
.venv\Scripts\activate
pip install fastapi uvicorn
pip freeze > requirements.txt

uvicorn main:app --reload

```