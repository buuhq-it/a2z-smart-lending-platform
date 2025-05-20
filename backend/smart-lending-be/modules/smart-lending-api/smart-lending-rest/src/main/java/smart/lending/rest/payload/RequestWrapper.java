package smart.lending.rest.payload;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class RequestWrapper<T> {
    private String requestId;
    private String traceId;
    private Instant requestTime = Instant.now();
    private T body;
    private Map<String, Object> metadata = new HashMap<>();
}
