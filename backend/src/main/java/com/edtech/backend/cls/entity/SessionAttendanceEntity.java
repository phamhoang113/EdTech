package com.edtech.backend.cls.entity;

import com.edtech.backend.core.entity.BaseEntity;
import com.edtech.backend.auth.entity.UserEntity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "session_attendances", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"session_id", "student_id"})
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SessionAttendanceEntity extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id", nullable = false)
    private SessionEntity session;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private UserEntity student;

    @Column(name = "is_present", nullable = false)
    private boolean present = false;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

}
