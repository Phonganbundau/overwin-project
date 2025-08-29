-- Script to update email verification system to use 5-digit codes instead of tokens

-- Drop old verification columns
ALTER TABLE `user` 
DROP COLUMN `verification_token`,
DROP COLUMN `verification_token_expires`;

-- Add new verification code column
ALTER TABLE `user` 
ADD COLUMN `verification_code` VARCHAR(5) NULL;

-- Reset email verification status for existing users (optional)
-- UPDATE `user` SET `email_verified` = FALSE WHERE `email_verified` IS NULL;
