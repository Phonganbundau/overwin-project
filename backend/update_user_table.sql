
ALTER TABLE `user` 
ADD COLUMN `email_verified` BOOLEAN NOT NULL DEFAULT FALSE,
ADD COLUMN `verification_token` VARCHAR(255) NULL,
ADD COLUMN `verification_token_expires` TIMESTAMP NULL;


UPDATE `user` SET `email_verified` = TRUE WHERE `email_verified` IS NULL;
