from net.grinder.script.Grinder import grinder
from net.grinder.script import Test

log = grinder.logger.info

test1 = Test(1,"Log Something")

test1.record(log)

class TestRunner:
   def __call__(self):
      log("Hello Grinder")


