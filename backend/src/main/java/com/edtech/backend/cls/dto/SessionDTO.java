package com.edtech.backend.cls.dto;

import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.SessionStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SessionDTO {
    private UUID id;
    private UUID classId;
    private String classTitle;
    private String subject;
    private String tutorName;
    private String tutorPhone;

    private LocalDate sessionDate;
    private LocalTime startTime;
    private LocalTime endTime;
    
    private String meetLink;
    private OffsetDateTime meetLinkSetAt;
    
    private SessionStatus status;
    private String tutorNote;

    public static SessionDTO fromEntity(SessionEntity entity) {
        if (entity == null) {
            return null;
        }
        
        String tutorName = null;
        String tutorPhone = null;
        if (entity.getCls() != null && entity.getCls().getTutor() != null) {
            tutorName = entity.getCls().getTutor().getFullName();
            tutorPhone = entity.getCls().getTutor().getPhone();
        }

        return SessionDTO.builder()
                .id(entity.getId())
                .classId(entity.getCls() != null ? entity.getCls().getId() : null)
                .classTitle(entity.getCls() != null ? entity.getCls().getTitle() : null)
                .subject(entity.getCls() != null ? entity.getCls().getSubject() : null)
                .tutorName(tutorName)
                .tutorPhone(tutorPhone)
                .sessionDate(entity.getSessionDate())
                .startTime(entity.getStartTime())
                .endTime(entity.getEndTime())
                .meetLink(entity.getMeetLink())
                .meetLinkSetAt(entity.getMeetLinkSetAt())
                .status(entity.getStatus())
                .tutorNote(entity.getTutorNote())
                .build();
    }
}
