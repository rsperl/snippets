#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import inspect
from functools import wraps


class Handler1(object):
    def handle_hello(self, f):
        @wraps(f)
        def decorated(self, *args, **kwargs):
            print("handler1: handle_hello")
            print("handler1: self={}".format(self))
            print("handler1: args={}".format(args))
            print("handler1: kwargs={}".format(kwargs))
            return f(*args, **kwargs)

        return decorated


class Handler2(object):
    def handle_hello(self, f):
        @wraps(f)
        def decorated(self, *args, **kwargs):
            print("handler2: handle_hello")
            print("handler2: self={}".format(self))
            print("handler2: args={}".format(args))
            print("handler2: kwargs={}".format(kwargs))
            return f(*args, **kwargs)

        return decorated


class Handler3(object):
    def handle_hello(self, f):
        @wraps(f)
        def decorated(self, *args, **kwargs):
            print("handler3: handle_hello")
            print("handler3: self={}".format(self))
            print("handler3: args={}".format(args))
            print("handler3: kwargs={}".format(kwargs))
            return f(*args, **kwargs)

        return decorated


class EventGenerator(object):
    def __init__(
        self,
        decorators=[],
        find_method_starts_with="_event",
        decorator_event_starts_with="handle_",
    ):
        """
        For every method that is named <eventname><find_method_starts_with> decorates with decorator method
        named <decorator_event_starts_with><eventname>.

        For example, if the event methods are named "<eventname>_event" (i.e., hello_event), then the decorator
        method handle_<eventname> (i.e., handle_hello) will be applied.
        """
        decorators.reverse()

        for m in inspect.getmembers(self, predicate=inspect.ismethod):
            method_name, method = m
            if method_name.endswith(find_method_starts_with):
                decorated_method = None

                for d in decorators:
                    # get event handler name by prefixing with decorator_event_starts_with
                    # and stripping the trailing find_method_starts_with
                    event_method_name = (
                        decorator_event_starts_with
                        + method_name[
                            0 : len(method_name) - len(find_method_starts_with)
                        ]
                    )

                    if hasattr(d, event_method_name):
                        print(
                            "EG: apply decorator event_method_name for {}".format(
                                d.__name__
                            )
                        )

                        # update the decorated method
                        dmethod = getattr(d, event_method_name)
                        if decorated_method is None:
                            # first call will be using original method
                            decorated_method = dmethod(d, method)
                        else:
                            # other calls will be made to the decorated methods
                            decorated_method = dmethod(d, decorated_method)
                        print("decorated method is {}".format(decorated_method))
                # update class with decorated method
                setattr(self, method_name, decorated_method.__get__(__name__, self))

    def hello_event(self, event_id, event_data=dict()):
        print("{}: hello!".format(self))


def main():
    eg = EventGenerator(decorators=[Handler1, Handler2, Handler3])
    eg.hello_event("myid", dict(a=1))


if __name__ == "__main__":
    main()
