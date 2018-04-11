package com.spring.mapper.entities;

/**
 *
 * @author Phat
 */
public class JobType {
    private int jobTypeId;
    private String jobTypeName;

    public JobType() {
    }

    public JobType(int jobTypeId, String jobTypeName) {
        this.jobTypeId = jobTypeId;
        this.jobTypeName = jobTypeName;
    }

    public int getJobTypeId() {
        return jobTypeId;
    }

    public String getJobTypeName() {
        return jobTypeName;
    }

    public void setJobTypeId(int jobTypeId) {
        this.jobTypeId = jobTypeId;
    }

    public void setJobTypeName(String jobTypeName) {
        this.jobTypeName = jobTypeName;
    }

    @Override
    public String toString() {
        return "JobType{" + "jobTypeId=" + jobTypeId + ", jobTypeName=" + jobTypeName + '}';
    }
    
    
}
