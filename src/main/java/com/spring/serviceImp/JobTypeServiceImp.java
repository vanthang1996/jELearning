/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.JobTypeRepository;
import com.spring.service.JobTypeService;

/**
 *
 * @author vanth
 */
@Service
public class JobTypeServiceImp implements JobTypeService {

    @Autowired
    private JobTypeRepository jobTypeRepository;

    @Override
    public List<?> getAll() {
        return this.jobTypeRepository.getAllRecord();
    }

}
