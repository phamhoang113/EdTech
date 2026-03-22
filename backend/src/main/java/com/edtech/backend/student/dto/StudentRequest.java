package com.edtech.backend.student.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record StudentRequest(

        @Pattern(regexp = "^0[0-9]{9,10}$", message = "Số điện thoại không hợp lệ")
        String phone,

        @NotBlank(message = "Tên học sinh không được để trống")
        @Size(max = 150)
        String fullName,

        @Size(max = 50)
        String grade,

        @Size(max = 255)
        String school
) {}
