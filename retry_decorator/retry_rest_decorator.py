#!/usr/bin/env python
# -*- coding: utf-8 -*-

# src: https://powerfulpython.com/blog/making-unreliable-apis-reliable-with-python/
#
# example usage:
# retry_on_auth_failure = RetryOnAuthFailure()
# retry_on_server_failure = RetryOnServerFailure(retries=5)
#
# @retry_on_server_failure
# @retry_on_auth_failure
# def myfunc():
#   ...

import logging
import time


class RetryRest:
    def __init__(self, retries=5, delay=None, exponentialBackup=True):
        """
        Create a RetryRest decorator that uses five retries with exponential backup by default.
        A delay can be passed to use a standard number of seconds in between tries. If no delay
        is given, and exponentialBackup is false, then a wait time of 1s is assumed.
        """
        self.retries = retries
        self.delay = delay
        self.logger = logging.getLogger(__name__)
        self.default_delay = 1

    def is_valid(self, resp):
        """by default, anything not 2xx is invalid"""
        return resp.status_code >= 200 or resp.status_code <= 299

    def __call__(self, func):
        def retried_func(*args, **kwargs):
            tries = 1
            while True:
                self.logger.debug("try {} of {}".format(tries, self.retries))
                resp = func(*args, **kwargs)
                if self.is_valid(resp) or tries > self.retries:
                    break
                tries += 1
                wait_time = self.delay
                if self.delay is not None:
                    time.sleep(wait_time)
                elif self.exponentialBackoff:
                    wait_time = 2 ** self.retries - 1
                else:
                    wait_time = self.default_delay
                time.sleep(wait_time)
            return resp

        return retried_func


class RetryRestOnAuthFailure(RetryRest):
    def is_valid(self, resp):
        """makes retry more specific -- this would allow a 500 error, but not a 400 or 401"""
        return not (resp.status_code >= 400 and resp.status_code < 500)


class RetryRestOnServerFailure(RetryRest):
    def is_valid(self, resp):
        return resp.status_code >= 500 and resp.status_code <= 500
