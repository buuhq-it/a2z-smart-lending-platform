package smart.lending.common.properties;

import lombok.*;

//@ConfigurationProperties(prefix = "jwt")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class JwtProperty {
    private String secret;
    private String jwtIssuer;
    private long expiration;
}
