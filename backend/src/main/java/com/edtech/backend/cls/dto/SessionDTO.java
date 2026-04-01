package com.edtech.backend.cls.dto;

import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.enums.SessionType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SessionDTO {
    private UUID id;
    private UUID classId;
    private String classCode;
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
    private SessionType sessionType;
    private String tutorNote;
    private String address;
    private Boolean hasPendingAbsence;
    private Boolean requiresMakeup;

    private Integer parentFee;
    private Integer tutorFee;

    private UUID makeupForSessionId;

    public static SessionDTO fromEntity(SessionEntity entity) {
        if (entity == null) {
            return null;
        }
        
        String tutorName = null;
        String tutorPhone = null;
        // Tutor details have to be enriched by the service layer or fetched later since ClassEntity only contains tutorId.

        Integer pFee = null;
        Integer tFee = null;
        if (entity.getCls() != null) {
            int sessionsPerMonth = entity.getCls().getSessionsPerWeek() != null && entity.getCls().getSessionsPerWeek() > 0 
                ? entity.getCls().getSessionsPerWeek() * 4 
                : 4;

            if (entity.getCls().getParentFee() != null) {
                pFee = entity.getCls().getParentFee().intValue() / sessionsPerMonth;
            }
            if (entity.getCls().getTutorFee() != null) {
                tFee = entity.getCls().getTutorFee().intValue() / sessionsPerMonth;
            }
        }

        return SessionDTO.builder()
                .id(entity.getId())
                .classId(entity.getCls() != null ? entity.getCls().getId() : null)
                .classCode(entity.getCls() != null ? entity.getCls().getClassCode() : null)
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
                .sessionType(entity.getSessionType())
                .tutorNote(entity.getTutorNote())
                .address(entity.getCls() != null ? entity.getCls().getAddress() : null)
                .requiresMakeup(entity.getRequiresMakeup())
                .makeupForSessionId(entity.getMakeupForSessionId())
                .parentFee(pFee)
                .tutorFee(tFee)
                .build();
    }
}
