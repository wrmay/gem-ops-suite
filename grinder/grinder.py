from net.grinder.script.Grinder import grinder
from net.grinder.script import Test
from org.apache.geode.cache.client import ClientCacheFactory
from org.apache.geode.cache.client import ClientRegionShortcut

cache = ClientCacheFactory().addPoolLocator('192.168.1.101', 10000).create()
region = cache.createClientRegionFactory(ClientRegionShortcut.PROXY).create("Orders")


test1 = Test(1,"Get an Order")

test1.record(region)

class TestRunner:
   def __call__(self):
       region.get('00000000')

