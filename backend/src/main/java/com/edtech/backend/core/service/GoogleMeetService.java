package com.edtech.backend.core.service;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.util.DateTime;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.model.ConferenceData;
import com.google.api.services.calendar.model.CreateConferenceRequest;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.EventAttendee;
import com.google.api.services.calendar.model.EventDateTime;
import com.edtech.backend.core.exception.EdTechException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
public class GoogleMeetService {

    @Value("${app.environment:development}")
    private String appEnvironment;

    @Value("${google.calendar.client-id:}")
    private String clientId;

    @Value("${google.calendar.client-secret:}")
    private String clientSecret;

    @Value("${google.calendar.refresh-token:}")
    private String refreshToken;

    private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    private static final String APP_NAME = "EdTech Google Meet Integration";

    /**
     * Tạo sự kiện Calendar và đi kèm 1 link Google Meet
     * @param description    Mô tả sự kiện
     * @param startT         Giờ bắt đầu dự kiến buổi học đầu tiên
     * @param endT           Giờ kết thúc dự kiến buổi học đầu tiên
     * @param attendeeEmails Danh sách email của Gia sư, Phụ huynh, Học sinh (nếu có)
     * @return String URL Google Meet (VD: https://meet.google.com/abc-xzy-qwe)
     */
    public String createMeetLink(String summary, String description, OffsetDateTime startT, OffsetDateTime endT, List<String> attendeeEmails) {
        if (!"production".equalsIgnoreCase(appEnvironment)) {
            log.info("Generating Mockup Google Meet Link for session: {}", summary);
            return "https://meet.google.com/simulated-" + UUID.randomUUID().toString().substring(0, 8);
        }

        log.info("Calling Google Calendar API to create Live Meet Link -> Summary: '{}', Start: {}, End: {}", summary, startT, endT);
        try {
            NetHttpTransport httpTransport = GoogleNetHttpTransport.newTrustedTransport();

            // Khởi tạo OAuth Credential tự động renew Access Token dựa trên Refresh Token
            Credential credential = new GoogleCredential.Builder()
                    .setTransport(httpTransport)
                    .setJsonFactory(JSON_FACTORY)
                    .setClientSecrets(clientId, clientSecret)
                    .build()
                    .setRefreshToken(refreshToken);

            Calendar service = new Calendar.Builder(httpTransport, JSON_FACTORY, credential)
                    .setApplicationName(APP_NAME)
                    .build();

            Event event = new Event()
                    .setSummary(summary)
                    .setDescription(description);

            DateTime startDateTime = new DateTime(startT.toInstant().toEpochMilli());
            EventDateTime start = new EventDateTime()
                    .setDateTime(startDateTime)
                    .setTimeZone("Asia/Ho_Chi_Minh");
            event.setStart(start);

            DateTime endDateTime = new DateTime(endT.toInstant().toEpochMilli());
            EventDateTime end = new EventDateTime()
                    .setDateTime(endDateTime)
                    .setTimeZone("Asia/Ho_Chi_Minh");
            event.setEnd(end);

            // Thêm danh sách khách mời (Tutor, Parent, Student) vào sự kiện để đồng bộ Lịch
            if (attendeeEmails != null && !attendeeEmails.isEmpty()) {
                List<EventAttendee> attendees = new ArrayList<>();
                for (String email : attendeeEmails) {
                    if (email != null && !email.trim().isEmpty()) {
                        attendees.add(new EventAttendee().setEmail(email.trim()));
                    }
                }
                event.setAttendees(attendees);
            }

            // Bật cờ tạo phòng Google Meet (Hangout Meet)
            ConferenceData conferenceData = new ConferenceData();
            CreateConferenceRequest createRequest = new CreateConferenceRequest();
            createRequest.setRequestId(UUID.randomUUID().toString().replace("-", ""));
            conferenceData.setCreateRequest(createRequest);
            event.setConferenceData(conferenceData);

            Event createdEvent = service.events().insert("primary", event)
                    .setConferenceDataVersion(1)
                    .execute();

            String link = createdEvent.getHangoutLink();
            if (link != null) {
                log.info("✅ Live Google Meet Link Created: {}", link);
                return link;
            } else {
                log.warn("⚠️ Google Calendar API created event but hangoverLink is NULL, falling back to mock");
                return "https://meet.google.com/error-" + UUID.randomUUID().toString().substring(0, 8);
            }

        } catch (Exception e) {
            log.error("❌ Failed to create Google Meet link via API for session '{}' | Start: {} | End: {}. Make sure valid clientId/Secret/RefreshToken are provided. Error: {}", summary, startT, endT, e.getMessage(), e);
            throw new EdTechException("Lỗi hệ thống khi tự động tạo phòng học (Meet) trên Google Calendar cho lớp: " + summary, "GOOGLE_MEET_API_ERROR");
        }
    }
}
