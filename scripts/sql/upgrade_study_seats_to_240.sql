START TRANSACTION;

DELIMITER $$

DROP PROCEDURE IF EXISTS ensure_study_seats_240$$
CREATE PROCEDURE ensure_study_seats_240()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE code_value VARCHAR(16);

    -- room 1 add 208 seats: A401-A608
    SET i = 1;
    WHILE i <= 208 DO
        SET code_value = CONCAT('A', LPAD(400 + i, 3, '0'));
        IF NOT EXISTS (
            SELECT 1 FROM campus_seat WHERE study_room_id = 1 AND seat_code = code_value
        ) THEN
            INSERT INTO campus_seat (study_room_id, seat_code, floor_no, zone_name, status)
            VALUES (
                1,
                code_value,
                3,
                CASE
                    WHEN i <= 70 THEN '临窗区'
                    WHEN i <= 140 THEN '安静区'
                    ELSE '开放学习区'
                END,
                'FREE'
            );
        END IF;
        SET i = i + 1;
    END WHILE;

    -- room 2 add 208 seats: B501-B708
    SET i = 1;
    WHILE i <= 208 DO
        SET code_value = CONCAT('B', LPAD(500 + i, 3, '0'));
        IF NOT EXISTS (
            SELECT 1 FROM campus_seat WHERE study_room_id = 2 AND seat_code = code_value
        ) THEN
            INSERT INTO campus_seat (study_room_id, seat_code, floor_no, zone_name, status)
            VALUES (
                2,
                code_value,
                4,
                CASE
                    WHEN i <= 70 THEN '静音区'
                    WHEN i <= 140 THEN '研讨区'
                    ELSE '开放学习区'
                END,
                'FREE'
            );
        END IF;
        SET i = i + 1;
    END WHILE;

    -- room 3 add 208 seats: C301-C508
    SET i = 1;
    WHILE i <= 208 DO
        SET code_value = CONCAT('C', LPAD(300 + i, 3, '0'));
        IF NOT EXISTS (
            SELECT 1 FROM campus_seat WHERE study_room_id = 3 AND seat_code = code_value
        ) THEN
            INSERT INTO campus_seat (study_room_id, seat_code, floor_no, zone_name, status)
            VALUES (
                3,
                code_value,
                2,
                CASE
                    WHEN i <= 70 THEN '共享区'
                    WHEN i <= 140 THEN '专注区'
                    ELSE '开放学习区'
                END,
                'FREE'
            );
        END IF;
        SET i = i + 1;
    END WHILE;
END$$

CALL ensure_study_seats_240()$$

-- normalize floors: every study room has 1F/2F/3F
SET @rn := 0$$
UPDATE campus_seat s
JOIN (
    SELECT id, (@rn := @rn + 1) AS rn
    FROM campus_seat
    WHERE study_room_id = 1
    ORDER BY id
) t ON s.id = t.id
SET s.floor_no = CASE
    WHEN t.rn <= 74 THEN 1
    WHEN t.rn <= 147 THEN 2
    ELSE 3
END
WHERE s.study_room_id = 1$$

SET @rn := 0$$
UPDATE campus_seat s
JOIN (
    SELECT id, (@rn := @rn + 1) AS rn
    FROM campus_seat
    WHERE study_room_id = 2
    ORDER BY id
) t ON s.id = t.id
SET s.floor_no = CASE
    WHEN t.rn <= 74 THEN 1
    WHEN t.rn <= 147 THEN 2
    ELSE 3
END
WHERE s.study_room_id = 2$$

SET @rn := 0$$
UPDATE campus_seat s
JOIN (
    SELECT id, (@rn := @rn + 1) AS rn
    FROM campus_seat
    WHERE study_room_id = 3
    ORDER BY id
) t ON s.id = t.id
SET s.floor_no = CASE
    WHEN t.rn <= 74 THEN 1
    WHEN t.rn <= 147 THEN 2
    ELSE 3
END
WHERE s.study_room_id = 3$$

DROP PROCEDURE ensure_study_seats_240$$

DELIMITER ;

COMMIT;
