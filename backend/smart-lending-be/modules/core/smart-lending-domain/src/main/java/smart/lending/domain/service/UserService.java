package smart.lending.domain.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import smart.lending.domain.mapper.UserMapper;
import smart.lending.domain.model.UserResponse;
import smart.lending.infrastructure.entity.User;
import smart.lending.infrastructure.repository.UserRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public List<UserResponse> getUsers(Long cursor, int size) {
        Pageable pageable = PageRequest.of(0, size);
        List<User> users = userRepository.findNextUsers(cursor, pageable);
        return users.stream().map(userMapper::toUserResponse).toList();
    }
}
