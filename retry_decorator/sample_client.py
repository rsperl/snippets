from rest_base import RestBase


class MyClient(RestBase):

    def get_user(self, name):
        url = "/users/" + name
        return self.do("GET", url)
