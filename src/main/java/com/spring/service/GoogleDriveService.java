package com.spring.service;

import com.google.api.services.drive.model.File;

public interface GoogleDriveService {

	public File uploadFile(String fileName, String filePath, String mimeType);
}
