import pandas as pd
import random
from faker import Faker
from datetime import datetime

fake = Faker()
Faker.seed(0)
random.seed(0)

# === Configuration ===
NUM_USERS = 10_000
NUM_POSTS = 50_000
NUM_COMMENTS = 200_000
NUM_LIKES = 300_000
NUM_FOLLOWS = 100_000
NUM_MESSAGES = 100_000
NUM_MEDIA = 50_000
NUM_NOTIFICATIONS = 200_000

# === Users ===
users = [
    [
        i,
        fake.user_name(),
        fake.email(),
        fake.sha256(),
        fake.date_time_between(start_date='-2y', end_date='now'),
        fake.sentence(nb_words=10)
    ]
    for i in range(1, NUM_USERS + 1)
]
pd.DataFrame(users, columns=["user_id", "username", "email", "password_hash", "created_at", "bio"]).to_csv("users.csv", index=False)

# === Posts ===
posts = [
    [
        i,
        random.randint(1, NUM_USERS),
        fake.paragraph(nb_sentences=3),
        fake.date_time_between(start_date='-2y', end_date='now')
    ]
    for i in range(1, NUM_POSTS + 1)
]
pd.DataFrame(posts, columns=["post_id", "user_id", "content", "created_at"]).to_csv("posts.csv", index=False)

# === Comments ===
comments = [
    [
        i,
        random.randint(1, NUM_POSTS),
        random.randint(1, NUM_USERS),
        fake.sentence(nb_words=15),
        fake.date_time_between(start_date='-2y', end_date='now')
    ]
    for i in range(1, NUM_COMMENTS + 1)
]
pd.DataFrame(comments, columns=["comment_id", "post_id", "user_id", "comment_text", "created_at"]).to_csv("comments.csv", index=False)

# === Likes ===
likes = [
    [
        i,
        random.randint(1, NUM_USERS),
        random.choice([random.randint(1, NUM_POSTS), None]),
        random.choice([random.randint(1, NUM_COMMENTS), None]),
        fake.date_time_between(start_date='-2y', end_date='now')
    ]
    for i in range(1, NUM_LIKES + 1)
]
pd.DataFrame(likes, columns=["like_id", "user_id", "post_id", "comment_id", "created_at"]).to_csv("likes.csv", index=False)

# === Followers ===
follows = []
for _ in range(NUM_FOLLOWS):
    follower, followee = random.sample(range(1, NUM_USERS + 1), 2)
    follows.append([
        follower,
        followee,
        fake.date_time_between(start_date='-2y', end_date='now')
    ])
pd.DataFrame(follows, columns=["follower_id", "followee_id", "followed_at"]).to_csv("followers.csv", index=False)

# === Messages ===
messages = []
for i in range(1, NUM_MESSAGES + 1):
    sender, receiver = random.sample(range(1, NUM_USERS + 1), 2)
    messages.append([
        i,
        sender,
        receiver,
        fake.text(max_nb_chars=100),
        fake.date_time_between(start_date='-2y', end_date='now')
    ])
pd.DataFrame(messages, columns=["message_id", "sender_id", "receiver_id", "message_text", "sent_at"]).to_csv("messages.csv", index=False)

# === Media ===
media = [
    [
        i,
        random.randint(1, NUM_POSTS),
        random.choice(["image", "video"]),
        fake.image_url(),
        fake.date_time_between(start_date='-2y', end_date='now')
    ]
    for i in range(1, NUM_MEDIA + 1)
]
pd.DataFrame(media, columns=["media_id", "post_id", "media_type", "media_url", "uploaded_at"]).to_csv("media.csv", index=False)

# === Notifications ===
notification_types = ["like", "comment", "follow", "message"]
notifications = [
    [
        i,
        random.randint(1, NUM_USERS),
        random.choice(notification_types),
        random.randint(1, max(NUM_POSTS, NUM_COMMENTS, NUM_MESSAGES)),
        fake.date_time_between(start_date='-2y', end_date='now'),
        random.choice([0, 1])
    ]
    for i in range(1, NUM_NOTIFICATIONS + 1)
]
pd.DataFrame(notifications, columns=["notification_id", "user_id", "type", "reference_id", "created_at", "is_read"]).to_csv("notifications.csv", index=False)

print("✅ All CSVs generated!")

