[Source](http://stackabuse.com/parallel-processing-in-python/ "Permalink to Parallel Processing in Python")

# Parallel Processing in Python

By [ \_\_ Frank Hofmann ][7] • October 03, 2017

### Introduction

When you start a program on your machine it runs in its own "bubble" which is completely separate from other programs that are active at the same time. This "bubble" is called a [process][9], and comprises everything which is needed to manage this program call.

For example, this so-called process environment includes the [memory pages][10] the process has in use, the file handles this process has opened, both user and group access rights, and its entire command line call, including given parameters.

This information is kept in the process file system of your UNIX/Linux system, which is a virtual file system, and accessible via the [/proc][11] directory. The entries are sorted by the process ID, which is unique to each process. _Example 1_ shows this for an arbitrarily selected process that has the process ID #177.

_Example 1: Information that is available to a process_

    root@system:/proc/177# ls
    attr         cpuset   limits      net            projid_map   statm
    autogroup    cwd      loginuid    ns             root         status
    auxv         environ  map_files   numa_maps      sched        syscall
    cgroup       exe      maps        oom_adj        sessionid    task
    clear_refs   fd       mem         oom_score      setgroups    timers
    cmdline      fdinfo   mountinfo   oom_score_adj  smaps        uid_map
    comm         gid_map  mounts      pagemap        stack        wchan
    coredump_filter       io          mountstats     personality  stat

### Structuring Program Code and Data

The more complex a program gets the more often it is handy to divide it into smaller pieces. This does not refer to source code, only, but also to code that is executed on your machine. One solution for this is the usage of subprocesses in combination with parallel execution. Thoughts behind this are:

- A single process covers a piece of code that can be run separately
- Certain sections of code can be run simultaneusly, and allow parallelization in principle
- Using the features of modern processors, and operating systems, for example every core of a processor we have available to reduce the total execution time of a program
- To reduce the complexity of your program/code, and outsource pieces of work to specialized agents acting as subprocesses

Using subprocesses requires you to rethink the way your program is executed, from linear to parallel. It is similar to changing your work perspective in a company from an ordinary worker to a manager - you will have to keep an eye on who is doing what, how long does a single step take, and what are the dependencies between the intermediate results.

This helps you to split your code into smaller chunks that can be executed by an agent specialized only for this task. If not yet done, think about how your dataset is structured as well so that it can be processed effectively by the individual agents. This leads to these questions:

- Why do you want to parallelize code? In your specific case and in terms of effort, does it make sense to think about it?
- Is your program intended to run just once, or will it run regularly on a similar dataset?
- Can you split your algorithm into several execution steps?
- Does your data allow parallelization at all? If not yet, in which way does the organisation of your data have to be adapted?
- Which intermediate results of your computation depend on each other?
- Which change in hardware is needed for that?
- Is there a bottle neck in either the hardware, or the algorithm, and how can you avoid, or minimize the influence of these factors?
- Which other side effects of parallelization can happen?

A possible use case is a main process, and a daemon running in the background (master/slave) waiting to be activated. Also, this can be a main process that starts worker processes running on demand. In practice, the main process is a feeder process that controls two or more agents that are fed portions of the data, and do calculations on the given portion.

Keep in mind that parallelization is both costly, and time-consuming due to the overhead of the subprocesses that is needed by your operating system. Compared to running two or more tasks in a linear way, doing this in parallel you may save between 25 and 30 percent of time per subprocess, depending on your use-case. For example, two tasks that consume 5 seconds each need 10 seconds in total if executed in series, and may need about 8 seconds on average on a multi-core machine when parallelized. 3 of those 8 seconds may be lost to overhead, limiting your speed improvements.

### Running a Function in Parallel with Python

Python offers four possible ways to handle that. First, you can execute functions in parallel using the [multiprocessing][12] module. Second, an alternative to processes are threads. Technically, these are lightweight processes, and are outside the scope of this article. For further reading you may have a look at the Python [threading module][13]. Third, you can call external programs using the `system()` method of the `os` module, or methods provided by the `subprocess` module, and collect the results afterwards.

The `multiprocessing` module covers a nice selection of methods to handle the parallel execution of routines. This includes processes, pools of agents, queues, and pipes.

_Listing 1_ works with a pool of five agents that process a chunk of three values at the same time. The values for the number of agents, and for the `chunksize` are chosen arbitrarily for demonstration purposes. Adjust these values accordingly to the number of cores in your processor.

The method `Pool.map()` requires three parameters - a function to be called on each element of the dataset, the dataset itself, and the `chunksize`. In _Listing 1_ we use a function that is named `square` and calculates the square of the given integer value. Furthermore, the `chunksize` can be omitted. If not set explicitly the default `chunksize` is 1.

Please note that the execution order of the agents is not guaranteed, but the result set is in the right order. It contains the square values according to the order of the elements of the original dataset.

_Listing 1: Running functions in parallel_

    from multiprocessing import Pool

    def square(x):
        # calculate the square of the value of x
        return x*x

    if __name__ == '__main__':

        # Define the dataset
        dataset = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]

        # Output the dataset
        print ('Dataset: ' + str(dataset))

        # Run this with a pool of 5 agents having a chunksize of 3 until finished
        agents = 5
        chunksize = 3
        with Pool(processes=agents) as pool:
            result = pool.map(square, dataset, chunksize)

        # Output the result
        print ('Result:  ' + str(result))

Running this code should yield the following output:

    $ python3 pool_multiprocessing.py
    Dataset: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
    Result:  [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196]

**Note**: We'll be using Python 3 for these examples.

### Running Multiple Functions Using a Queue

As a data structure, a queue is very common, and exists in several ways. It is organized as either [First In First Out][14] (FIFO), or Last In First Out (LIFO)/[stack][15], as well as with and without priorities (priority queue). The data structure is implemented as an array with a fixed number of entries, or as a list holding a variable number of single elements.

In _Listings 2.1-2.7_ we use a FIFO queue. It is implemented as a list which is already provided by the corresponding class from the `multiprocessing` module. Furthermore, the `time` module is loaded and used to imitate work load.

_Listing 2.1: Modules to be used_

    import multiprocessing
    from time import sleep

Next, a worker function is defined (_Listing 2.2_). This function represents the agent, actually, and requires three arguments. The process name indicates which process it is, and both the `tasks` and `results` refer to the corresponding queue.

Inside the worker function is an infinite `while` loop. Both `tasks` and `results` are queues that are defined in the main program. `tasks.get()` returns the current task from the task queue to be processed. A task value smaller than 0 quits the `while` loop, and returns a value of -1. Any other task value will perform a computation (square), and will return this value. Returning a value to the main program is implemented as `results.put()`. This adds the computed value at the end of the `results` queue.

_Listing 2.2: The worker function_

    # define worker function
    def calculate(process_name, tasks, results):
        print('[%s] evaluation routine starts' % process_name)

        while True:
            new_value = tasks.get()
            if new_value < 0:
                print('[%s] evaluation routine quits' % process_name)

                # Indicate finished
                results.put(-1)
                break
            else:
                # Compute result and mimic a long-running task
                compute = new_value * new_value
                sleep(0.02*new_value)

                # Output which process received the value
                # and the calculation result
                print('[%s] received value: %i' % (process_name, new_value))
                print('[%s] calculated value: %i' % (process_name, compute))

                # Add result to the queue
                results.put(compute)

        return

The next step is the main loop (see _Listing 2.3_). First, a manager for [inter-process communication][16] (IPC) is defined. Next, two queues are added - one that keeps the tasks, and the other one for the results.

_Listing 2.3: IPC and queues_

    if __name__ == "__main__":
        # Define IPC manager
        manager = multiprocessing.Manager()

        # Define a list (queue) for tasks and computation results
        tasks = manager.Queue()
        results = manager.Queue()

Having done this setup we define a process pool with four worker processes (agents). We make use of the class `multiprocessing.Pool()`, and create an instance of it. Next, we define an empty list of processes (see _Listing 2.4_).

_Listing 2.4: Defining a process pool_

    # Create process pool with four processes
    num_processes = 4
    pool = multiprocessing.Pool(processes=num_processes)
    processes = []

As the following step we initiate the four worker processes (agents). For simplicity, they are named "P0" to "P3". Creating the four worker processes is done using `multiprocessing.Process()`. This connects each of them to the worker function as well as the task and the results queue. Finally, we add the newly initialized process at the end of the list of processes, and start the new process using `new_process.start()` (see _Listing 2.5_).

_Listing 2.5: Prepare the worker processes_

    # Initiate the worker processes
    for i in range(num_processes):

        # Set process name
        process_name = 'P%i' % i

        # Create the process, and connect it to the worker function
        new_process = multiprocessing.Process(target=calculate, args=(process_name,tasks,results))

        # Add new process to the list of processes
        processes.append(new_process)

        # Start the process
        new_process.start()

Our worker processes are waiting for work. We define a list of tasks, which in our case are arbitrarily selected integers. These values are added to the task list using `tasks.put()`. Each worker process waits for tasks, and picks the next available task from the list of tasks. This is handled by the queue itself (see _Listing 2.6_).

_Listing 2.6: Prepare the task queue_

    # Fill task queue
    task_list = [43, 1, 780, 256, 142, 68, 183, 334, 325, 3]
    for single_task in task_list:
        tasks.put(single_task)

    # Wait while the workers process
    sleep(5)

After a while we would like our agents to finish. Each worker process reacts on a task with the value -1. It interprets this value as a termination signal, and dies thereafter. That's why we put as many -1 in the task queue as we have processes running. Before dying, a process that terminates puts a -1 in the results queue. This is meant to be a confirmation signal to the main loop that the agent is terminating.

In the main loop we read from that queue, and count the number of -1. The main loop quits as soon as we have counted as many termination confirmations as we have processes. Otherwise, we output the calculation result from the queue.

_Listing 2.7: Termination and output of results_

    # Quit the worker processes by sending them -1
    for i in range(num_processes):
        tasks.put(-1)

    # Read calculation results
    num_finished_processes = 0
    while True:
        # Read result
        new_result = results.get()

        # Have a look at the results
        if new_result == -1:
            # Process has finished
            num_finished_processes += 1

            if num_finished_processes == num_processes:
                break
        else:
            # Output result
            print('Result:' + str(new_result))

_Example 2_ displays the output of the Python program. Running the program more than once you may notice that the order in which the worker processes start is as unpredictable as the process itself that picks a task from the queue. However, once finished the order of the elements of the results queue matches the order of the elements of the tasks queue.

_Example 2_

    $ python3 queue_multiprocessing.py
    [P0] evaluation routine starts
    [P1] evaluation routine starts
    [P2] evaluation routine starts
    [P3] evaluation routine starts
    [P1] received value: 1
    [P1] calculated value: 1
    [P0] received value: 43
    [P0] calculated value: 1849
    [P0] received value: 68
    [P0] calculated value: 4624
    [P1] received value: 142
    [P1] calculated value: 20164
    result: 1
    result: 1849
    result: 4624
    result: 20164
    [P3] received value: 256
    [P3] calculated value: 65536
    result: 65536
    [P0] received value: 183
    [P0] calculated value: 33489
    result: 33489
    [P0] received value: 3
    [P0] calculated value: 9
    result: 9
    [P0] evaluation routine quits
    [P1] received value: 334
    [P1] calculated value: 111556
    result: 111556
    [P1] evaluation routine quits
    [P3] received value: 325
    [P3] calculated value: 105625
    result: 105625
    [P3] evaluation routine quits
    [P2] received value: 780
    [P2] calculated value: 608400
    result: 608400
    [P2] evaluation routine quits

**Note**: As mentioned earlier, your output may not exactly match the one shown above since the order of execution is unpredicatble.

### Using the os.system() Method

The `system()` method is part of the [os module][17], which allows to execute external command line programs in a separate process from your Python program. The `system()` method is a blocking call, and you have to wait until the call is finished and returns. As a UNIX/Linux fetishist you know that a command can be run in the background, and write the computed result to the output stream that is redirected to a file like this (see _Example 3_):

_Example 3: Command with output redirection_

    $ ./program >> outputfile &

In a Python program you simply encapsulate this call as shown below:

_Listing 3: Simple system call using the os module_

    import os

    os.system("./program >> outputfile &")

This system call creates a process that runs in parallel to your current Python program. Fetching the result may become a bit tricky because this call may terminate after the end of your Python program - you never know.

Using this method is much more expensive than the previous methods I described. First, the overhead is much bigger (process switch), and second, it writes data to physical memory, such as a disk, which takes longer. Though, this is a better option you have limited memory (like with RAM) and instead you can have massive output data written to a solid-state disk.

### Using the subprocess module

This module is intended to replace `os.system()` and `os.spawn()` calls. The idea of [subprocess][18] is to simplify spawning processes, communicating with them via pipes and signals, and collecting the output they produce including error messages.

Beginning with Python 3.5, the subprocess contains the method `subprocess.run()` to start an external command, which is a wrapper for the underlying `subprocess.Popen()` class. As an example we launch the UNIX/Linux command `df -h` to find out how much disk space is still available on the `/home` partition of your machine. In a Python program you do this call as shown below (_Listing 4_).

_Listing 4: Basic example to run an external command_

    import subprocess

    ret = subprocess.run(["df", "-h", "/home"])
    print(ret)

This is the basic call, and very similar to the command `df -h /home` being executed in a terminal. Note that the parameters are separated as a list instead of a single string. The output will be similar to _Example 4_. Compared to the official Python documentation for this module, it outputs the result of the call to `stdout`, in addition to the return value of the call.

_Example 4_ shows the output of our call. The last line of the output shows the successful execution of the command. Calling `subprocess.run()` returns an instance of the class `CompletedProcess` which has the two attributes named `args` (command line arguments), and `returncode` (return value of the command).

_Example 4: Running the Python script from Listing 4_

    $ python3 diskfree.py
    Filesystem   Size   Used  Avail Capacity  iused   ifree %iused  Mounted on
    /dev/sda3  233Gi  203Gi   30Gi    88% 53160407 7818407   87%   /home
    CompletedProcess(args=['df', '-h', '/home'], returncode=0)

To suppress the output to `stdout`, and catch both the output, and the return value for further evaluation, the call of `subprocess.run()` has to be slightly modified. Without further modification, `subprocess.run()` sends the output of the executed command to `stdout` which is the output channel of the underlying Python process. To grab the output, we have to change this, and to set the output channel to the pre-defined value `subprocess.PIPE`. _Listing 5_ shows how to do that.

_Listing 5: Grabbing the output in a pipe_

    import subprocess

    # Call the command
    output = subprocess.run(["df", "-h", "/home"], stdout=subprocess.PIPE)

    # Read the return code and the output data
    print ("Return code: %i" % output.returncode)
    print ("Output data: %s" % output.stdout)

As explained before `subprocess.run()` returns an instance of the class `CompletedProcess`. In _Listing 5_, this instance is a variable simply named `output`. The return code of the command is kept in the attribute `output.returncode`, and the output printed to `stdout` can be found in the attribute `output.stdout`. Keep in mind this does not cover handling error messages because we did not change the output channel for that.

### Conclusion

Parallel processing is a great opportunity to use the power of contemporary hardware. Python gives you access to these methods at a very sophisticated level. As you have seen before both the `multiprocessing` and the `subprocess` module let's you dive into that topic easily.
