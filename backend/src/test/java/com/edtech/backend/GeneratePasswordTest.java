package com.edtech.backend;

import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class GeneratePasswordTest {
    @Test
    public void generatePassword() {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        System.out.println("@@@BCRYPT_HASH=" + encoder.encode("Admin@123"));
    }
}
