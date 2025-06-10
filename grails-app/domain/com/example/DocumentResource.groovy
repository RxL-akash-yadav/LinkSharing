package com.example

class DocumentResource extends AppResource {
    byte[] fileContent
    String fileName
    String contentType
    String fileHash // Added property for file hash to support shareDownload

    static constraints = {
        fileName(nullable: false)
        fileHash(nullable: true)
        contentType(nullable: true)
        fileContent(nullable: true, maxSize: 10485760) // 10MB max size
    }

    static mapping = {
        table : 'app_document'
        fileContent(type: 'binary')
    }
    
    // Generate a unique hash for the file when saving
    def beforeInsert() {
        if (!fileHash) {
            fileHash = UUID.randomUUID().toString()
        }
    }
}
