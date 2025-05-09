# social_media_db
It generates the csv files of social media using faker and bulk insert in ms sql server.

Entity-Relationship (ER) Diagram

🔵 Users
user_id (PK)

username

email

password_hash

created_at

bio

🟢 Posts
post_id (PK)

user_id (FK → Users)

content

created_at

🟡 Comments
comment_id (PK)

post_id (FK → Posts)

user_id (FK → Users)

comment_text

created_at

🔴 Likes
like_id (PK)

user_id (FK → Users)

post_id (FK → Posts, NULLABLE)

comment_id (FK → Comments, NULLABLE)

created_at

A Like is on either a Post or a Comment.

🟣 Followers
follower_id (FK → Users)

followee_id (FK → Users)

followed_at

PK: Composite (follower_id, followee_id)

🟤 Messages
message_id (PK)

sender_id (FK → Users)

receiver_id (FK → Users)

message_text

sent_at

⚫ Media
media_id (PK)

post_id (FK → Posts)

media_type (image/video)

media_url

uploaded_at

⚪ Notifications
notification_id (PK)

user_id (FK → Users)

type (like, comment, follow, message)

reference_id (can point to post/comment/message/etc.)

created_at

is_read

🔗 ER Relationships Summary
Users ↔ Posts: One-to-Many

Posts ↔ Comments: One-to-Many

Posts/Comments ↔ Likes: One-to-Many (polymorphic)

Users ↔ Followers: Many-to-Many (self-referencing)

Users ↔ Messages: One-to-Many (sender & receiver)

Posts ↔ Media: One-to-Many

Users ↔ Notifications: One-to-Many


