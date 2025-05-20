package smart.lending.common.configs;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import smart.lending.common.properties.JwtProperty;

@Configuration
public class JwtPropertyBean {
    @Value("${jwt.secret}")
    private String jwtSecret;
    @Value("${jwt.issuer}")
    private String jwtIssuer;
    @Value("${jwt.expiration-in-ms}")
    private long jwtExpirationInMs;

    @Bean
    public JwtProperty jwtProperty() {
        return JwtProperty
                .builder()
                .secret(jwtSecret)
                .jwtIssuer(jwtIssuer)
                .expiration(jwtExpirationInMs)
                .build();
    }
}
