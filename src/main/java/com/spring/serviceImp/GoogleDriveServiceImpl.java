package com.spring.serviceImp;

import java.net.URL;
import java.nio.file.Paths;
import java.util.Collections;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.http.FileContent;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.Value;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.DriveScopes;
import com.google.api.services.drive.model.File;
import com.spring.service.GoogleDriveService;

@Service
public class GoogleDriveServiceImpl implements GoogleDriveService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(GoogleDriveServiceImpl.class);
	@Autowired
	Environment environment;
	
	@Value("${google.service_account_email}")
	private String ServiceAccountId;
	
	@Value("${google.application_name}")
	private String applicationName;
	
	@Value("${google.service_account_key}")
	private String serviceAccountKey;
	
	@Value("${google.folder_id}")
	private String folderId;
	
	public Drive getDriveService() {
		Drive drive = null;
		try {
			URL resource = GoogleDriveServiceImpl.class.getResource("/" + environment.getProperty("google.service_account_key"));
			java.io.File key = Paths.get(resource.toURI()).toFile();
			HttpTransport httpTransport = new NetHttpTransport();
			JacksonFactory jacksonFactory = new JacksonFactory();
			
			GoogleCredential credential = new GoogleCredential.Builder().setTransport(httpTransport)
					.setJsonFactory(jacksonFactory).setServiceAccountId(environment.getProperty("google.service_account_email"))
					.setServiceAccountScopes(Collections.singleton(DriveScopes.DRIVE))
					.setServiceAccountPrivateKeyFromP12File(key).build();
			drive = new Drive.Builder(httpTransport, jacksonFactory, credential).setApplicationName(environment.getProperty("google.application_name"))
					.setHttpRequestInitializer(credential).build();
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
		}
		return drive;
	}
	
	@Override
	public File uploadFile(String fileName, String filePath, String mimeType) {
		File file = new File();
		try {
			java.io.File fileUpload = new java.io.File(filePath);
			File fileMetadata = new File();
			fileMetadata.setMimeType(mimeType);
			fileMetadata.setName(fileName);
			fileMetadata.setParents(Collections.singletonList(environment.getProperty("google.folder_id")));
			FileContent fileContent = new FileContent(mimeType, fileUpload);
			file = getDriveService().files().create(fileMetadata, fileContent)
					.setFields("id,webContentLink,webViewLink").execute();
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
		}
		return file;
	}

}
