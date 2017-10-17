from java.util import Random
import time
from net.grinder.script.Grinder import grinder
from net.grinder.script import Test
from org.apache.geode.cache.client import ClientCacheFactory
from org.apache.geode.cache.client import ClientRegionShortcut

LOCATOR_HOST = '192.168.1.101'
LOCATOR_PORT = 10000
ORDER_COUNT = 1000000
ACCOUNT_COUNT = 100000

GET_ORDER_COUNT = 20

SLEEP = 0.001

cache = ClientCacheFactory().addPoolLocator(LOCATOR_HOST, LOCATOR_PORT).create()
region = cache.createClientRegionFactory(ClientRegionShortcut.PROXY).create("Orders")


test1 = Test(1,"Get Order")


#test2 = Test(2,"Put Order")
#test3 = Test(3, "Query By Account")


#def randomOrderId():
#    id = random.randrange(ORDER_COUNT)
#    return '%08d'.format(id)  

def getOrder(oid):
   return region.get(oid)

test1.record(getOrder)

class TestRunner:
   def __call__(self):
       getOrder('00000000')
       getOrder('00000001')

        

