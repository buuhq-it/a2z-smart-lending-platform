package smart.lending.rest.payload;

import java.time.Instant;
import java.util.HashMap;

public class ResponseBuilder<T> {
    private final ResponseWrapper<T> response;

    public ResponseBuilder() {
        this.response = new ResponseWrapper<>();
        this.response.setTimestamp(Instant.now());
        this.response.setSuccess(true);
        this.response.setMetadata(new HashMap<>());
    }

    public static <T> ResponseBuilder<T> builder() {
        return new ResponseBuilder<>();
    }
    public ResponseBuilder<T> requestId(String requestId) {
        this.response.setRequestId(requestId);
        return this;
    }

    public ResponseBuilder<T> traceId(String traceId) {
        this.response.setTraceId(traceId);
        return this;
    }

    public ResponseBuilder<T> body(T body) {
        this.response.setBody(body);
        return this;
    }

    public ResponseBuilder<T> error(String code, String desc) {
        this.response.setErrorCode(code);
        this.response.setErrorDesc(desc);
        this.response.setSuccess(false);
        return this;
    }

    public ResponseBuilder<T> pagination(long pageIndex, long pageSize, long totalSize) {
        this.response.setPageIndex(pageIndex);
        this.response.setPageSize(pageSize);
        this.response.setTotalSize(totalSize);
        return this;
    }

    public ResponseBuilder<T> metadata(String key, Object value) {
        this.response.getMetadata().put(key, value);
        return this;
    }

    public ResponseWrapper<T> build() {
        return this.response;
    }
}
