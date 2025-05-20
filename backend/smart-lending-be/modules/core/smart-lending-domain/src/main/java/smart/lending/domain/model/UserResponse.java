package smart.lending.domain.model;

import java.util.List;

public record UserResponse (
        Long id,
        String username,
        List<String> roles
) { }
