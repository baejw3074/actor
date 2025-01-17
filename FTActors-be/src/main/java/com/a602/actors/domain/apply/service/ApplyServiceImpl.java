package com.a602.actors.domain.apply.service;

import com.a602.actors.domain.apply.dto.ApplyDto;
import com.a602.actors.domain.apply.entity.Apply;
import com.a602.actors.domain.apply.repository.ApplyRepository;
import com.a602.actors.domain.member.repository.MemberRepository;
import com.a602.actors.domain.recruitment.repository.RecruitmentRepository;
import com.a602.actors.global.common.config.FileUtil;
import com.a602.actors.global.common.enums.FolderType;
import com.a602.actors.global.exception.ApplyException;
import com.a602.actors.global.exception.ExceptionCodeSet;
import com.a602.actors.global.exception.MemberException;
import com.a602.actors.global.exception.RecruitmentException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Transactional(readOnly = true)
@Service
public class ApplyServiceImpl implements ApplyService {

    private final ApplyRepository applyRepository;
    private final MemberRepository memberRepository;
    private final RecruitmentRepository recruitmentRepository;


    @Override
    @Transactional
    public void apply(ApplyDto applyDto) throws IOException {
        String url = FileUtil.uploadFile(applyDto.getVideoFile(), FolderType.APPLY_Path);

        Apply apply = Apply.builder()
                .recruitment(recruitmentRepository.findById(applyDto.getRecruitmentId()).orElseThrow(() -> new RecruitmentException(ExceptionCodeSet.RECRUITMENT_NOT_FOUND)))
                .member(memberRepository.findById(applyDto.getMemberId()).orElseThrow(() -> new MemberException(ExceptionCodeSet.MEMBER_NOT_FOUND)))
                .content(applyDto.getContent())
                .videoLink(url)
                .build();
        applyRepository.save(apply);
    }

    @Override
    @Transactional
    public void applyCancel(Long recruitmentId, Long memberId) throws IOException {
        Apply apply = applyRepository.findByRecruitmentIdAndMemberId(recruitmentId, memberId);

        // 지원을 취소하기 전에 S3에서 파일을 삭제합니다.
        String videoLink = apply.getVideoLink();
        if (videoLink != null) {
            FileUtil.deleteFile(videoLink, FolderType.APPLY_Path);
        }

        // 지원 취소를 처리합니다.
        applyRepository.deleteByRecruitmentIdAndMemberId(recruitmentId, memberId);
    }

    @Override
    public List<ApplyDto> myApplyList(Long memberId) {
        List<Apply> applyList = applyRepository.findByMemberId(memberId);
        // builder 교체
        List<ApplyDto> applyDtoList = applyList.stream()
                .map(apply -> ApplyDto.builder()
                        .id(apply.getId())
                        .recruitmentId(apply.getRecruitment().getId())
                        .memberId(apply.getMember().getId())
                        .content(apply.getContent())
                        .videoLink(apply.getVideoLink())
                        .build())
                .collect(Collectors.toList());
        return applyDtoList;
    }

    @Override
    public ApplyDto detail(Long applyId) {
        Apply apply = applyRepository.findById(applyId).orElseThrow(() -> new ApplyException(ExceptionCodeSet.APPLY_NOT_FOUND));
        ApplyDto applyDto = ApplyDto.builder()
                .id(apply.getId())
                .recruitmentId(apply.getRecruitment().getId())
                .memberId(apply.getMember().getId())
                .content(apply.getContent())
                .videoLink(apply.getVideoLink())
                .build();
        return applyDto;
    }

    @Override
    public List<ApplyDto> applyList(Long recruitmentId) {
        List<Apply> applyList = applyRepository.findByRecruitmentId(recruitmentId);
        List<ApplyDto> applyDtoList = applyList.stream()
                .map(apply -> ApplyDto.builder()
                        .id(apply.getId())
                        .recruitmentId(apply.getRecruitment().getId())
                        .memberId(apply.getMember().getId())
                        .content(apply.getContent())
                        .videoLink(apply.getVideoLink())
                        .build())
                .collect(Collectors.toList());
        return applyDtoList;
    }
    
    // 해당 공고에 유저가 지원했는지 확인
    @Override
    public int existApply(Long recruitmentId, Long memberId) {
        Apply apply = applyRepository.findByRecruitmentIdAndMemberId(recruitmentId, memberId);
        if (apply == null) {
            return 0;
        }
        return 1;
    }


}
