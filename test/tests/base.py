import logging
import subprocess
import sys




### MODULE LEVEL EXCEPTION ###
class TestError(Exception):
    def __init__(self, msg):
        Exception.__init__(self)
        self.message = msg

    def __str__(self):
        return self.message

### TEST CONTEXT CLASS ###

class TestContext:

    # currently supporting only one global test context per process
    # so there is a class level init method
    def init(home_directory):
        TestContext.homedir = home_directory

        format = '%(asctime)s %(levelname)s %(message)s'
        console_handler = logging.StreamHandler(sys.stdout)
        console_handler.setFormatter(logging.Formatter(format))

        file_handler = logging.FileHandler('test.log', mode='wt')
        file_handler.setFormatter(logging.Formatter(format))

        TestContext.logger = logging.getLogger('test')
        TestContext.logger.addHandler(console_handler)
        TestContext.logger.addHandler(file_handler)

    def log(level, method, description, message):
        """
        level should be a logging.INFO or logging.ERROR
        method should be SETUP, VERIFY or TEARDOWN
        description should be the description of the test
        message is the error or info message
        """
        msg = '{0} [{1}] - {2}'.format(method, description, message)
        TestContext.logger.log(level,msg)

    def __str__(self):
        return self.description

    def run(self, cmd_list):
        """
        raises an Exception if the subprocess returns a non-zero exit
        """
        logging.debug('running [' + ' '.join(cmd_list) + '] in ' + self.homedir)
        subprocess.check_output(cmd_list, cwd = self.homedir)
