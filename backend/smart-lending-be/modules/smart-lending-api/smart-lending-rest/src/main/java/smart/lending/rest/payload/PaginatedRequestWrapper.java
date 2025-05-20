package smart.lending.rest.payload;

import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class PaginatedRequestWrapper <T> extends RequestWrapper<T>{
    private long pageIndex = 0;
    private long pageSize = 10;
}
