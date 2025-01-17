ALTER TABLE blacklisted_tokens
CHANGE COLUMN admin_id user_id BIGINT UNSIGNED NOT NULL;

ALTER TABLE blacklisted_tokens
ADD CONSTRAINT fk_blacklisted_tokens_user_id FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE refresh_tokens
CHANGE COLUMN admin_id user_id BIGINT UNSIGNED NOT NULL;

ALTER TABLE refresh_tokens
ADD CONSTRAINT fk_refresh_tokens_user_id FOREIGN KEY (user_id) REFERENCES users(id);
