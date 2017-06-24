# Instructions
To run the test suite, copy _tests/test-awscluster.json_ to _config/awscluster.json_
and edit the header components, especially the _SSHKeyPairName_ and _SSHKeyPath_.

Run _test/test.py_ (this will take a while)

# Instructions for Writing Tests

Each test is a class with "setup", "teardown" and "verify" methods and
a "description" attribute.

Any exception in setup causes execution to jump to tear down.  Otherwise,
after setup, "verify" is run.  With verify, successful tests are reported
with the "success" method on a report object, which will be passed in.

Within any of the test methods, a test failure can be reported by raising
an Exception.
