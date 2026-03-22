ALTER TABLE users
ADD COLUMN IF NOT EXISTS username VARCHAR(50);

ALTER TABLE users
ADD CONSTRAINT users_username_key UNIQUE (username);
