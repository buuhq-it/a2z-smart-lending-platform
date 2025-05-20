package smart.lending.rest.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import smart.lending.domain.model.UserResponse;
import smart.lending.domain.service.UserService;
import smart.lending.rest.payload.PaginatedRequestWrapper;
import smart.lending.rest.payload.ResponseBuilder;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @GetMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public String onlyAdmin() {
        return "Hello Admin!";
    }

    @GetMapping("/me")
    @PreAuthorize("isAuthenticated()")
    public String currentUser(Authentication auth) {
        return "Current user: " + auth.getName();
    }

    @PostMapping("")
    public ResponseEntity<?> listUsers(@RequestBody PaginatedRequestWrapper<Void> request) {
        long cursor = request.getPageIndex();
        int pageSize = (int) request.getPageSize();

        List<UserResponse> result = userService.getUsers(cursor, pageSize);

        Long nextCursor = result.isEmpty() ? null : result.getLast().id();

        return ResponseEntity.ok(ResponseBuilder.<List<UserResponse>>builder()
                .body(result)
                .metadata("nextCursor", nextCursor)
                .build());
    }
}
