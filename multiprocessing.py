from multiprocessing import Process

def method_to_call(*args, **kwargs):
  # do what you do
  pass

def main():
  #
  rows = ("job1", "job2")
  procs = []
  for jobname in rows:
    p = Process(
      name=jobname,
      target=method_to_call,
      args=("a", "b"),
      kwargs=dict(arg1="val1", arg2="val2")
    )
    procs.append(p)
    p.start()
    
    # wait until all processes have finished
    for p in procs:
      p.join()