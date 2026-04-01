package com.edtech.backend.location;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "wards")
@Getter
@Setter
@NoArgsConstructor
public class Ward {
    @Id
    private String code;
    
    private String name;
    
    private String provinceCode;
}
