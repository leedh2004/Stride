from backend.test.test_user import *
from backend.test.test_home import *
from backend.test.test_dressroom import *
from backend.test.test_coordination import *
from backend.test.test_login import *
import unittest

def create_suite():
    test_suite = unittest.TestSuite()
    test_suite.addTest(LoginTest())
    test_suite.addTest(UserTest())
    test_suite.addTest(HomeTest())
    test_suite.addTest(DressroomTest())
    test_suite.addTest(CoordinationTest())
    return test_suite

if __name__ == '__main__':
   suite = create_suite()
   unittest.main()