package smart.lending.rest.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import smart.lending.domain.model.LoginRequest;
import smart.lending.domain.model.LoginResponse;
import smart.lending.domain.service.AuthService;
import smart.lending.rest.payload.RequestWrapper;
import smart.lending.rest.payload.ResponseBuilder;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody RequestWrapper<LoginRequest> request) {
//        if (request.getTraceId() == null || request.getTraceId().isEmpty()) {
//            request.setTraceId("trace-" + UUID.randomUUID());
//        }
        LoginRequest loginRequest = request.getBody();
        LoginResponse loginResponse = authService
                .login(loginRequest.getUsername(), loginRequest.getPassword());

        return ResponseEntity.ok(ResponseBuilder
                .<LoginResponse>builder()
                .requestId(request.getRequestId())
                .traceId(request.getTraceId())
                .body(loginResponse)
                .build());
    }
}
