DO $$
DECLARE
    v_admin_id UUID;
    v_parent_id UUID;
BEGIN
    SELECT id INTO v_admin_id FROM users WHERE role = 'ADMIN' LIMIT 1;
    SELECT id INTO v_parent_id FROM users WHERE role = 'PARENT' LIMIT 1;

    IF v_admin_id IS NULL OR v_parent_id IS NULL THEN
        RAISE NOTICE 'Admin or Parent not found. Cannot insert test class.';
        RETURN;
    END IF;

    -- Insert an extra 'Khác' class for testing the UI
    INSERT INTO classes (
        id,
        admin_id,
        parent_id,
        tutor_id,
        title,
        subject,
        grade,
        description,
        mode,
        address,
        schedule,
        sessions_per_week,
        session_duration_min,
        parent_fee,
        tutor_fee,
        platform_fee,
        status,
        start_date,
        end_date,
        is_deleted,
        time_frame,
        class_code,
        fee_percentage,
        student_fee,
        teacher_fee,
        tutor_level_requirement,
        gender_requirement
    ) VALUES (
        '9e12015a-93be-43a0-880c-78396c000021',
        v_admin_id,
        v_parent_id,
        NULL,
        'Lập trình Web cho người mới bắt đầu',
        'Khác',
        'Đại học',
        'Cần gia sư hỗ trợ học Javascript, React, và CSS cơ bản.',
        'OFFLINE',
        '123 Đường B, Quận 2, TP.HCM',
        '[{"dayOfWeek": "SUNDAY", "startTime": "09:00:00", "endTime": "11:00:00"}, {"dayOfWeek": "TUESDAY", "startTime": "18:00:00", "endTime": "20:00:00"}]',
        2,
        120,
        250000,
        250000,
        0,
        'OPEN',
        CURRENT_DATE,
        CURRENT_DATE + INTERVAL '3 months',
        FALSE,
        'Sáng CN, Tối Thứ 3',
        '7X9A2B',
        35,
        200000,
        350000,
        '["Giáo viên", "Sinh viên", "Chuyên gia"]',
        'Không yêu cầu'
    ) ON CONFLICT (id) DO NOTHING;
END $$;
