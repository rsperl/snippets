from requests import Request, Session
import logging
import retry_decorator

retry_5x = retry_decorator.RetryRest(retries=5)


class RestBase(object):

    def __init__(self, url, username, password):
        self.url = url
        self.username = username
        self.password = password
        self.session = Session()
        self.log = logging.getLogger(__name__)

    def do(self, method, url, data=dict(), params=dict()):
        try:
            resp = self._do(method, url, data, params)
            return resp.status_code, resp.content
        except Exception as e:
            self.log.debug("exception calling do({}, {}): {}".format(method, url, e))

    @retry_5x
    def _do(self, method, url, data=dict(), params=dict()):
        method = method.lower()
        headers = {
            "accept": "application/json",
            "content-type": "application/json",
        }
        r = None
        url = self.url + url
        self.log.info("{} {} {}".format(method, url, params))
        r = Request(
            method=method,
            url=url,
            json=data,
            params=params,
            headers=headers,
            auth=(self.username, self.password)
        )
        prepped = r.prepare()
        return self.session.send(prepped, verify=False)
