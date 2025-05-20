package smart.lending.rest.payload;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ResponseWrapper<T> {
    private String requestId;
    private String traceId;

    private T body;

    private String errorCode;
    private String errorDesc;
    private boolean success = true;

    private long totalSize;
    private long pageSize;
    private long pageIndex;

    private Instant timestamp = Instant.now();
    private Map<String, Object> metadata = new HashMap<>();
}
