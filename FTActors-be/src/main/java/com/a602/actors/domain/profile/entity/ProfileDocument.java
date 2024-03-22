package com.a602.actors.domain.profile.entity;

import com.a602.actors.domain.profile.dto.ProfileRequest;
import jakarta.persistence.Id;
import lombok.*;
import org.springframework.data.elasticsearch.annotations.*;

import java.time.LocalDateTime;

@EqualsAndHashCode(of = "id") // equals() 및 hashCode() 메서드를 생성할 때 고려해야 할 필드를 지정
@Document(indexName = "profile_elasticsearch") //해당 클래스의 인스턴스가 저장될 인덱스의 이름을 지정합니다. 이름 없으면 db 만듦
//@Setting(settingPath = "es-config/es-analyzer.json")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class ProfileDocument { //엘라스틱 서치 디비 내부에 저장할 거
    @Id
    @Field(type = FieldType.Keyword)
    private Long id; //게시글 번호??? 아닌가?? 뭐지??

//    @Field(type = FieldType.Text, analyzer = "korean_analyzer", searchAnalyzer = "korean_analyzer")
    @Field(type = FieldType.Text) // 형태소 분석할 텍스트 (검색에 활용)
    private String stageName; //제목 (노리를 활용한 형태소 분석도 함 -> 변경예정)

//    @Field(type = FieldType.Text, analyzer = "korean_analyzer", searchAnalyzer = "korean_analyzer")
    @Field(type = FieldType.Text) // 형태소 분석할 텍스트 (검색에 활용)
    private String content; //내용 (노리를 활용한 형태소 분석도 함 -> 변경예정)

    @Field(type = FieldType.Keyword) //일반 텍스트 (형태소 분석 적용x, 검색 시 활용x)
    private Character type; //배우 프로필? 관계자 프로필?

    @Field(type = FieldType.Keyword)
    private String portfolio;

    @Field(type = FieldType.Keyword) //일반 텍스트 (형태소 분석 적용x, 검색 시 활용x)
    private Character privatePost;

    @Field(type = FieldType.Date, format = DateFormat.date_hour_minute_second)
    private LocalDateTime createdTime; //생성 일시

    @Field(type = FieldType.Date, format = DateFormat.date_hour_minute_second)
    private LocalDateTime updatedTime; //마지막 업데이트 일시

    public static ProfileDocument from (Profile profile) {
        return ProfileDocument.builder()
                .id(profile.getId())
                .stageName(profile.getMember().getMemberId()) //나중에 stage_name으로 바꾸기
                .content(profile.getContent())
                .privatePost(profile.getPrivatePost())
                .createdTime(profile.getCreatedAt())
                .updatedTime(profile.getCreatedAt())
                .build();
    }

//    public static ProfileDocument from2 (ProfileRequest profileRequest) {
//        return ProfileDocument.builder()
//
//    }

    // 수정된 내용을 반영하여 객체를 업데이트하는 메서드
    public void updateContent(String newContent, Character newPrivatePost) {
        this.content = newContent;
        this.privatePost = newPrivatePost;
        this.updatedTime = LocalDateTime.now(); // 수정 시간을 현재 시간으로 갱신
    }
}