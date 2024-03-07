package com.a602.actors.domain.montage.controller;

import com.a602.actors.domain.montage.service.MontageFileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.GeneralSecurityException;

@RestController
@RequestMapping("/montage")
public class MontageController {


    @Autowired
    private MontageFileService montageFileService;

    @GetMapping("/test")
    public String getTest(){
        return "서버 정상적으로 열렸어요!";
    }
//
//    @GetMapping("/list")
//    public String getMontageList() throws GeneralSecurityException, IOException {
//        return googleDriveService.getFiles();
//    }

    @PostMapping("/upload")
    public String uploadMontageList(@RequestParam(value = "file") MultipartFile file) throws GeneralSecurityException, IOException {

        System.out.println(file.getOriginalFilename());

        try {
            montageFileService.uploadFile(file);
        }
        catch (Exception e){
            System.out.println(e.getMessage());
        }
        //googleDriveService.getFiles();

        return "";
    }


}
