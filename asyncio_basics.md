# Asyncio basics in python

_src: https://medium.com/@alairock/asyncio-basics-in-python-29bf30cf254f_

Python 3.5 brought with it asyncio. An event loop based paradigm
previously available as a library but now it is built in as a standard
library. There are other async libraries out there, but I am going to
focus on the one built in to
Python.

### Creating an event loop

    import asyncio

    loop = asyncio.get_event_loop()
    loop.run_until_complete(some_func())

This is the basic example to get you up and running. This is the core of
asyncio. Starting an event loop and running some function on top of it.
Some frameworks abstract this from you and handle it on the bootstrap of
the application layer (aiohttp, for
example).

### The async function

    async def some_func():
      pass

Just like defining a regular function, except we add the `async`
keyword. This not only let's you know the function is asynchronous, but
it also let's the interpreter know that it’s a _special_ function. The
interpreter wraps up the function inside a `coroutine` and then hands it
to you so you can handle it.

In our first example we started an event loop and ran our function
inside `run_until_complete()` That will run your function until all
synchronous and non-synchronous calls are complete. I like to think of
this step as an instantiation of our asynchronous paradigm.

### The real magic — `await`

Cool. We have our code starting to come together. Let’s add a new async
function and rename `some_func` to `run` since that is all we are going
to have it do -- run our async
logic.

    import asyncio

    async def speak():
        print('Hey!')

    async def run():
        await speak()

    loop = asyncio.get_event_loop()
    loop.run_until_complete(run())

`await` tells our event loop to pause here and wait for the called
coroutine to finish work before continuing on.

What happens if you leave out `await`? There are times that do not
require you to immediately `await` your coroutine, but at some point
before the execution of your code is complete, you will need to handle
it in some way, or you will receive an RuntimeWarning once our coroutine
is out of scope.

### Starting a function and getting back to it later.

The first thing you might need an async pattern for is starting a job in
the background, do other tasks in the front and then coming back to your
original
task.

    import asyncio

    async def speak():
        print('C')
        await asyncio.sleep(3)
        return 'D'

    async def run():
        will_speak = speak()
        print('A')
        print('B')
        print(await will_speak)

    loop = asyncio.get_event_loop()
    loop.run_until_complete(run())

If you run this you will see the
results:

    A
    B
    C
    D

That’s what we wanted right? Close. We wanted to start our async job
`speak()` and when it was done, return the results. However, the first
thing we printed to our terminal was `A` not `C`. We did not actually
start our job, we just defined it. We started it’s execution later when
we called `await will_speak`. To start the job running while we move on
to other tasks, we need to use
`asyncio.ensure_future()`.

    import asyncio

    async def speak():
        print('C')
        await asyncio.sleep(3)
        return 'D'

    async def run():
        will_speak = asyncio.ensure_future(speak())
        await asyncio.sleep(1)
        print('A')
        print('B')
        print(await will_speak)

    loop = asyncio.get_event_loop()
    loop.run_until_complete(run())

Note: I added a 1 second sleep after we did `ensure_future()` That's
because `will_speak` is now running concurrently with the rest of the
function, and you cannot guarantee that `C` will print before `A` and
`B`, so putting a `sleep()` in there ensures the `speak()`function can
finish it's task first. This is done just for the illustration purposes
and not necessarily necessary in practice. (that was fun to say)

Cool. We now have a function that branches and runs while we continue
on.

### Order mucking

    import asyncio

    async def meow(number):
        print(f'starting {number}')
        await asyncio.sleep(1)
        print(f'stopping {number}')

    async def run():
        # notice how we assign each coroutine to a variable
        a = meow(1)
        b = meow(2)
        c = meow(3)
        d = meow(4)
        e = meow(5)

        # then we can decide which order we wish our coroutines to execute
        await c
        await a
        await e
        await b
        await d

    loop = asyncio.get_event_loop()
    loop.run_until_complete(run())

Let’s look at how our coroutines are handled. In the above example, I am
showing that you can define your work in any order. Then `await` them
out of order. Or in order. Or out of order and then back in order. Or
any combination. Great. They all run sequentially though in the order
they are awaited. What about if we wanted all those to run at the same
time. Well, we could `ensure_future` all the things (which is just
fine). OR we can show you another
way.

### Concurrent runnings

    import asyncio

    async def meow(number):
        print(f'starting {number}')
        await asyncio.sleep(1)
        print(f'stopping {number}')

    async def run():
        f = []
        for x in range(1, 6):
            f.append(meow(x))
        await asyncio.wait(f)

    loop = asyncio.get_event_loop()
    loop.run_until_complete(run())

Here we are creating a list and then adding all of our items to said
list. In this case, we are just iterating over a `range()` and appending
those coroutines to that list. Then with `asyncio.wait()` we can wait
for all those coroutines to complete. (Don't forget to `await` the
`asyncio.wait()`, a common mistake.)

One thing you should keep in mind, if you do not wrap your coroutines in
`ensure_future()` then you cannot ensure
order.

    async def run():
        # We create an empty list to store our coroutines in
        f = []
        for x in range(1, 6):
            f.append(asyncio.ensure_future(meow(x)))
        await asyncio.wait(f)

This is because `wait` (and `gather`, which we’ll talk about in a
minute) puts coroutines in a set, which are not ordered, and `Task`
objects are able to maintain order. (Tested in Python 3.6)

Update 03/20/18:
Python 3.5–3.6 [iterates over a
set](https://github.com/python/cpython/blob/a954919788f2130076e4f9dd91e9eccf69540f7a/Lib/asyncio/tasks.py#L594)which
causes jobs to be processed out of order. 3.7
[corrects](https://github.com/python/cpython/blob/6e65e4462692cbf4461c307a411af7cf40a1ca4a/Lib/asyncio/tasks.py#L672)
this. Shout out to [dzunukwa](https://www.reddit.com/user/dzunukwa) for
his [additional
research](https://www.reddit.com/r/Python/comments/838kd0/asyncio_basics_in_python/dvtfiyi/)
on this. So in 3.7 order is maintained and `ensure_future()` is no
longer “required”. And as dzunukwa points out, it can also be written
like this.

    async def run():
        coros = [meow(x) for x in range(6)]
        x = await asyncio.gather(*coros)
        print(x)

Which utilizes a [list
comprehension](https://docs.python.org/3.6/tutorial/datastructures.html#list-comprehensions)
and looks a bit cleaner. Rather nice, if all you are doing is iterating
through jobs.

### Handling async function results

Our previous example handles the concurrency beautifully (albeit out of
order), but what if you want to do something with the results of those
functions, a la “scatter-gather”? Use
`gather()`\!

    import asyncio

    async def meow(number):
        await asyncio.sleep(1)
        return number

    async def run():
        f = []
        for x in range(1, 6):
            f.append(asyncio.ensure_future(meow(x)))
        x = await asyncio.gather(*f)
        print(x)

    loop = asyncio.get_event_loop()
    loop.run_until_complete(run())

    # $>: [1, 2, 3, 4, 5]

Typically `asyncio.gather()` is actually what you want, over
`asyncio.wait()`, since it gives you the added benefit of collecting the
results.

### That it? What else you got?

A couple things come to mind. Look at this
example.

    import asyncio

    async def new_future(n):
        print('future', n)
        await asyncio.sleep(3)
        print('future done', n)
        return n

    async def run():
        results = asyncio.ensure_future(new_future(1))
        print(results) # <Task> object returned
        print(await results) # `1` is returned
        print(results) # <Task> is returned again
        print(await results) # `1` is returned again

        results = new_future(2)
        print(results) # coroutine returned
        print(await results) # `2` is returned
        print(results) # coroutine returned again
        print(await results) # RuntimeError: cannopy reuse aalready awaited coroutine

    loop = asyncio.get_event_loop()
    loop.run_until_complete(run())

`ensure_future` wraps up our coroutine in a `Task`. A task is more
robust than a coroutine. First a task begins execution immediately when
it is created, and then stores the results inside of it's object. Then,
any time in the future if you call `await` on your future, you can
retrieve the result, without having to re-execute the item again. A
coroutine dies as soon as it is `await`’ed, and will raise an exception
if you try and use it again.

And lastly, just have fun with it. You can do all sorts of crazy stuff
with asyncio. Execute things in weird orders, or whatever makes sense
for your
application.

    import asyncio

    async def meow(number):
        print(f'starting {number}')
        await asyncio.sleep(1)
        print(f'stopping {number}')


    async def run():
        f = []
        for x in range(1, 6):
            f.append(meow(x))

        for x, y in enumerate(f):
            if x % 2 == 0:
                await y
        for x, y in enumerate(f):
            if x % 2 != 0:
                await y

    loop = asyncio.get_event_loop()
    loop.run_until_complete(run())

---

</div>

<div class="section-content">

<div class="section-inner sectionLayout--insetColumn">

_Originally published at_
[_gist.github.com_](https://gist.github.com/4b76e285adeea9c2c5354bd8e9136e88).
