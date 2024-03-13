
-- Member 테이블 생성
SET foreign_key_checks = 0;

DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
                          `id` bigint NOT NULL AUTO_INCREMENT,
                          `login_id` varchar(100) NOT NULL,
                          `password` varchar(100) NOT NULL,
                          `email` varchar(100) NULL,
                          `phone` varchar(100) NULL,
                          `birth` varchar(100) NOT NULL,
                          `gender` char(1) NOT NULL,
                          `profile_image` varchar(100) NULL,
                          `created_at` timestamp NOT NULL DEFAULT current_timestamp,
                          `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
                          `kakao_refresh_token` varchar(100) NULL,
                          PRIMARY KEY (`id`)
);

-- Recruitment 테이블 생성content
DROP TABLE IF EXISTS `recruitment`;
CREATE TABLE `recruitment` (
                               `id` bigint NOT NULL AUTO_INCREMENT,
                               `title` varchar(50) NOT NULL,
                               `content` text NOT NULL,
                               `member_id` bigint NOT NULL,
                               `category` varchar(10) NOT NULL,
                               `image` varchar(100) NULL,
                               `start_date` timestamp NOT NULL,
                               `end_date` timestamp NOT NULL,
                               `created_at` timestamp NULL DEFAULT current_timestamp,
                               `updated_at` timestamp NULL DEFAULT current_timestamp,
                               `private_recruitment` varchar(1) NULL DEFAULT 'F',
                               PRIMARY KEY (`id`),
                               CONSTRAINT `FK_Member_TO_Recruitment_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`)
);


-- Blacklist 테이블 생성
DROP TABLE IF EXISTS `blacklist`;
CREATE TABLE `blacklist` (
                             `id` bigint NOT NULL AUTO_INCREMENT,
                             `member_id` bigint NOT NULL,
                             `warning` char NOT NULL DEFAULT 'F',
                             `created_at` timestamp NOT NULL DEFAULT current_timestamp,
                             `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
                             PRIMARY KEY (`id`),
                             CONSTRAINT `FK_Member_TO_Blacklist_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`)
);

-- Alarm 테이블 생성
DROP TABLE IF EXISTS `alarm`;
CREATE TABLE `alarm` (
                         `id` bigint NOT NULL AUTO_INCREMENT,
                         `member_id` bigint NOT NULL,
                         `type` char(3) NOT NULL DEFAULT '없음',
                         `is_read` char(1) NOT NULL DEFAULT 'F',
                         `created_at` timestamp NULL DEFAULT current_timestamp,
                         `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
                         PRIMARY KEY (`id`),
                         CONSTRAINT `FK_Member_TO_Alarm_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`)
);


-- Follow 테이블 생성
DROP TABLE IF EXISTS `follow`;
CREATE TABLE `follow` (
                          `id` bigint NOT NULL AUTO_INCREMENT,
                          `following_id` bigint NOT NULL,
                          `follower_id` bigint NOT NULL,
                          `created_at` timestamp NOT NULL DEFAULT current_timestamp,
                          `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
                          PRIMARY KEY (`id`),
                          CONSTRAINT `FK_Member_TO_Follow_1` FOREIGN KEY (`following_id`) REFERENCES `Member` (`id`),
                          CONSTRAINT `FK_Member_TO_Follow_2` FOREIGN KEY (`follower_id`) REFERENCES `Member` (`id`)
);

-- Application 테이블 생성
DROP TABLE IF EXISTS `application`;
CREATE TABLE `application` (
                               `id` bigint NOT NULL AUTO_INCREMENT,
                               `recruitment_id` bigint NOT NULL,
                               `member_id` bigint NOT NULL,
                               `video_link` varchar(100) NOT NULL,
                               `content` varchar(200) NULL,
                               `created_at` timestamp NOT NULL DEFAULT current_timestamp,
                               `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
                               PRIMARY KEY (`id`),
                               CONSTRAINT `FK_Recruitment_TO_Application_1` FOREIGN KEY (`recruitment_id`) REFERENCES `Recruitment` (`id`),
                               CONSTRAINT `FK_Member_TO_Application_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`)
);


-- Wishlist 테이블 생성
DROP TABLE IF EXISTS `wishlist`;
CREATE TABLE `wishlist` (
                            `id` bigint NOT NULL AUTO_INCREMENT,
                            `recruitment_id` bigint NOT NULL,
                            `member_id` bigint NOT NULL,
                            `created_at` timestamp NULL DEFAULT current_timestamp,
                            `updated_at` timestamp NULL DEFAULT current_timestamp,
                            PRIMARY KEY (`id`),
                            CONSTRAINT `FK_Recruitment_TO_Wishlist_1` FOREIGN KEY (`recruitment_id`) REFERENCES `Recruitment` (`id`),
                            CONSTRAINT `FK_Member_TO_Wishlist_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`)
);

-- montage 테이블 생성
DROP TABLE IF EXISTS `montage`;
CREATE TABLE `montage` (
                           `id` bigint NOT NULL AUTO_INCREMENT,
                           `member_id` bigint NOT NULL,
                           `title` varchar(50) NOT NULL,
                           `link` varchar(100) NOT NULL,
                           `created_at` timestamp NOT NULL DEFAULT current_timestamp,
                           `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
                           PRIMARY KEY (`id`),
                           CONSTRAINT `FK_Member_TO_montage_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`)
);

-- Comment 테이블 생성
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
                           `id` bigint NOT NULL AUTO_INCREMENT,
                           `member_id` bigint NOT NULL,
                           `montage_id` bigint NOT NULL,
                           `content` varchar(100) NOT NULL,
                           `reference_id` bigint NULL,
                           `updated_at` timestamp NULL DEFAULT current_timestamp,
                           `created_at` timestamp NOT NULL DEFAULT current_timestamp,
                           PRIMARY KEY (`id`),
                           CONSTRAINT `FK_Member_TO_Comment_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`),
                           CONSTRAINT `FK_montage_TO_Comment_1` FOREIGN KEY (`montage_id`) REFERENCES `montage` (`id`)
);

-- chat_room 테이블 생성
DROP TABLE IF EXISTS `chat_room`;
CREATE TABLE `chat_room` (
                             `id` bigint NOT NULL AUTO_INCREMENT,
                             `title` varchar(100) NOT NULL,
                             `created` timestamp NOT NULL DEFAULT current_timestamp,
                             `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
                             PRIMARY KEY (`id`)
);

-- chat_message 테이블 생성
DROP TABLE IF EXISTS `chat_message`;
CREATE TABLE `chat_message` (
                                `id` bigint NOT NULL AUTO_INCREMENT,
                                `sender` bigint NOT NULL,
                                `chat_room_id` bigint NOT NULL,
                                `content` varchar(100) NOT NULL,
                                `is_read` char(1) NOT NULL DEFAULT 'F',
                                `created_at` timestamp NOT NULL DEFAULT current_timestamp,
                                `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
                                `type` char(5) NOT NULL,
                                PRIMARY KEY (`id`),
                                CONSTRAINT `FK_Member_TO_chat_message_1` FOREIGN KEY (`sender`) REFERENCES `Member` (`id`),
                                CONSTRAINT `FK_chat_room_TO_chat_message_1` FOREIGN KEY (`chat_room_id`) REFERENCES `chat_room` (`id`)
);

-- profile 테이블 생성
DROP TABLE IF EXISTS `profile`;
CREATE TABLE `profile` (
                           `id` bigint NOT NULL AUTO_INCREMENT,
                           `member_id` bigint NOT NULL,
                           `content` text NOT NULL,
                           `type` char(1) NOT NULL DEFAULT 'A',
                           `created_at` timestamp NULL DEFAULT current_timestamp,
                           `updated_at` timestamp NULL DEFAULT current_timestamp,
                           `portfolio` varchar(100) NULL DEFAULT '',
                           `stage_name` varchar(100) NULL,
                           `private_post` varchar(1) NOT NULL DEFAULT 'F',
                           PRIMARY KEY (`id`),
                           CONSTRAINT `FK_Member_TO_profile_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`)
);

-- report 테이블 생성
DROP TABLE IF EXISTS `report`;
CREATE TABLE `report` (
                          `id` bigint NOT NULL AUTO_INCREMENT,
                          `reason` varchar(255) NULL,
                          `reporter_id` bigint NOT NULL,
                          `reportee_id` bigint NOT NULL,
                          `image_link` varchar(100) NULL,
                          PRIMARY KEY (`id`),
                          CONSTRAINT `FK_Member_TO_report_1` FOREIGN KEY (`reporter_id`) REFERENCES `Member` (`id`),
                          CONSTRAINT `FK_Member_TO_report_2` FOREIGN KEY (`reportee_id`) REFERENCES `Member` (`id`)
);

-- Note 테이블 생성
DROP TABLE IF EXISTS `note`;
CREATE TABLE `note` (
                        `id` bigint NOT NULL AUTO_INCREMENT,
                        `sender_id` bigint NOT NULL,
                        `receiver_id` bigint NOT NULL,
                        `content` varchar(100) NOT NULL,
                        `is_read` char(1) NOT NULL DEFAULT 'F',
                        `created_at` timestamp NOT NULL DEFAULT current_timestamp,
                        `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
                        PRIMARY KEY (`id`),
                        CONSTRAINT `FK_Member_TO_Note_1` FOREIGN KEY (`sender_id`) REFERENCES `Member` (`id`),
                        CONSTRAINT `FK_Member_TO_Note_2` FOREIGN KEY (`receiver_id`) REFERENCES `Member` (`id`)
);

-- Like_count 테이블 생성
DROP TABLE IF EXISTS `like_count`;
CREATE TABLE `like_count` (
                              `id` bigint NOT NULL AUTO_INCREMENT,
                              `montage_id` bigint NOT NULL,
                              `member_id` bigint NOT NULL,
                              PRIMARY KEY (`id`),
                              `created_at` timestamp NOT NULL DEFAULT current_timestamp,
                              `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
                              CONSTRAINT `FK_montage_TO_Like_count_1` FOREIGN KEY (`montage_id`) REFERENCES `montage` (`id`),
                              CONSTRAINT `FK_Member_TO_Like_count_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`)
);

-- participants 테이블 생성
DROP TABLE IF EXISTS `participants`;
CREATE TABLE `participants` (
                                `id` bigint NOT NULL AUTO_INCREMENT,
                                `chat_room_id` bigint NOT NULL,
                                `member_id` bigint NOT NULL,
                                `created_at` timestamp NOT NULL DEFAULT current_timestamp,
                                `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
                                PRIMARY KEY (`id`),
                                CONSTRAINT `FK_chat_room_TO_participants_1` FOREIGN KEY (`chat_room_id`) REFERENCES `chat_room` (`id`),
                                CONSTRAINT `FK_Member_TO_participants_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`)
);


SET foreign_key_checks = 1;

