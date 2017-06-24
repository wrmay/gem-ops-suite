import logging
import os.path
import sys

import tests.base
import tests.provision


### MAIN ###
if __name__ == '__main__':
    #TODO would be handy to change the logging level without modifying code
    logging.basicConfig(level=logging.INFO, format='%(asctime)s %(name)s %(message)s', filename='test.other.log', filemode='wt')
    test_list = []

    # Set up test context
    here = os.path.dirname(os.path.abspath(sys.argv[0]))
    tests.base.TestContext.init(os.path.dirname(here))

    # Setup All Tests Here #
    test_list.append(tests.provision.ProvisionTest())

    # Run through all tests in order calling setup, then verify on each.
    # The assumption is that later tests depend on the setup of earlier ones.
    # For example, a software test depends on provisioning the hardware first.
    # If an exception is thrown, teardown is run on the completed tests in
    # reverse order.  If all tests complete successfully, teardown is run on
    # all tests in reverse order.
    rc = 0
    t = 0
    try:
        while t < len(test_list):
            method = 'SETUP'
            test_list[t].setup()
            tests.base.TestContext.log(logging.INFO,method,test_list[t],'SUCCEEDED')

            method = 'VERIFY'
            test_list[t].verify()
            tests.base.TestContext.log(logging.INFO,method,test_list[t],'SUCCEEDED')

            t += 1

        # if we actually get all the way through then we want t pointing at the last entry
        t -= 1
    except Exception as x:
        rc = 1
        tests.base.TestContext.log(logging.ERROR ,method,test_list[t],'FAILED with exception({0})'.format(str(x)))


    method = 'TEARDOWN'
    while t >= 0:
        try:
            test_list[t].teardown()
            tests.base.TestContext.log(logging.INFO,method,test_list[t],'SUCCEEDED')
        except Exception as x:
            rc = 1
            tests.base.TestContext.log(logging.ERROR ,method,test_list[t],'FAILED with exception({0})'.format(str(x)))
        finally:
            # need to continue to tear down everything no matter what fails
            t -= 1

    sys.exit(rc)
