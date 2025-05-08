CREATE DATABASE SocialMediaDB;
GO

USE SocialMediaDB;
GO


CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(255),
    password_hash VARCHAR(255),
    created_at DATETIME,
    bio TEXT
);

CREATE TABLE posts (
    post_id INT PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    content TEXT,
    created_at DATETIME
);

CREATE TABLE comments (
    comment_id INT PRIMARY KEY,
    post_id INT FOREIGN KEY REFERENCES posts(post_id),
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    comment_text TEXT,
    created_at DATETIME
);

CREATE TABLE likes (
    like_id INT PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    post_id INT  NULLFOREIGN KEY REFERENCES posts(post_id),
    comment_id INT NULL FOREIGN KEY REFERENCES comments(comment_id),
    created_at DATETIME
);

CREATE TABLE followers (
    follower_id INT FOREIGN KEY REFERENCES users(user_id),
    followee_id INT FOREIGN KEY REFERENCES users(user_id),
    followed_at DATETIME,
    PRIMARY KEY (follower_id, followee_id)
);

CREATE TABLE messages (
    message_id INT PRIMARY KEY,
    sender_id INT FOREIGN KEY REFERENCES users(user_id),
    receiver_id INT FOREIGN KEY REFERENCES users(user_id),
    message_text TEXT,
    sent_at DATETIME
);

CREATE TABLE media (
    media_id INT PRIMARY KEY,
    post_id INT FOREIGN KEY REFERENCES posts(post_id),
    media_type VARCHAR(20),
    media_url VARCHAR(500),
    uploaded_at DATETIME
);

CREATE TABLE notifications (
    notification_id INT PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    type VARCHAR(50),
    reference_id INT,
    created_at DATETIME,
    is_read BIT
);


------users
BULK INSERT users
FROM '/home/himanshupal\social_media\users.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);


SELECT user_id from users;

-- POSTS
BULK INSERT posts
FROM '/home/himanshupal\social_media\posts.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

SELECT post_id from posts;



-- COMMENTS
BULK INSERT comments
FROM '/home/himanshupal\social_media\comments.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

SELECT * from comments;




------------Implemented below
-- -- LIKES
-- BULK INSERT likes
-- FROM '/home/himanshupal\social_media\likes.csv'
-- WITH (
--     FORMAT = 'CSV',
--     FIRSTROW = 2,
--     FIELDTERMINATOR = ',',
--     ROWTERMINATOR = '\n',
--     TABLOCK
-- );


-- FOLLOWERS
BULK INSERT followers
FROM '/home/himanshupal\social_media\followers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);


-- MESSAGES
BULK INSERT messages
FROM '/home/himanshupal\social_media\messages.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

select * from messages



-- MEDIA
BULK INSERT media
FROM '/home/himanshupal\social_media\media.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

select * from media



-- NOTIFICATIONS
BULK INSERT notifications
FROM '/home/himanshupal\social_media\notifications.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

select * from notifications


------insert likes as this because the likes.csv contains ""(empty string) for post_id which is not acceptable in likes tables.
CREATE TABLE likes_staging (
    like_id INT,
    user_id INT,
    post_id VARCHAR(20),       -- Temporarily allow any text
    comment_id VARCHAR(20),    -- Temporarily allow any text
    created_at DATETIME
);


BULK INSERT likes_staging
FROM '/home/himanshupal\social_media\likes.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

select * from likes_staging

INSERT INTO likes (like_id, user_id, post_id, comment_id, created_at)
SELECT
    like_id,
    user_id,
    CASE
        WHEN post_id = ' ' THEN 0  -- or any default integer value
        ELSE TRY_CAST(post_id AS INT)
    END,
    CASE
        WHEN comment_id = ' ' THEN 0  -- or any default integer value
        ELSE TRY_CAST(comment_id AS INT)
    END,
    created_at
FROM likes_staging;



select * from likes

TRUNCATE TABLE likes