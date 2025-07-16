package smart.lending.rest.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test/token")
@RequiredArgsConstructor
public class TestTokenController {
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
}
