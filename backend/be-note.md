```text
package: smart.lending.*
```

```shell
mvnw clean install
./mvnw install && ./mvnw spring-boot:run -pl modules\smart-lending-api\smart-lending-rest-app
mvnw install && mvnw spring-boot:run -pl be\ais-be-app
```