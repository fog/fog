---
layout: default
title:  Storage
---

## AWS Specific Options

Here's a couple Fog features specific only to AWS S3.

**Encryption**. Amazon provides the option to AES256 encrypt files at rest on 
upload by setting the "x-amz-server-side-encryption" HTTP request header to 
AES256. You can short hand set this HTTP header via the ````encryption```` key 
value pair. For example,

    # encrypt file at rest
    file = directory.files.create(
      :key      => 'resume.html',
      :body     => File.open("/path/to/my/resume.html"),
      :public   => true, 
      :encryption   => 'AES256'
    )
