import sample_client

c = sample_client.MyClient(url="http://host", username="user", password="pass")

# .do will use the retry decorator from parent class to get a user
code, body = c.get_user("me")
