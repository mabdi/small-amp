import unittest
from command import Command
import time
import os

class CommandTest(unittest.TestCase):
    def test_crash(self):
        t1 = time.time()
        c = Command('python3 -c "1+1; exit(1)"', verbose=True)
        c.run(timeout=2)
        t2 = time.time()
        self.assertTrue(True)
        self.assertEqual(c.code(), 1)
        self.assertLess(t2-t1, 1)
        self.assertFalse(c.timedout)

    def test_freeze(self):
        t1 = time.time()
        c = Command('python3 -c "import time; time.sleep(10); exit(0)"', verbose=True)
        c.run(timeout=2)
        t2 = time.time()
        self.assertTrue(True)
        self.assertEqual(c.code(), -15)
        self.assertGreaterEqual(t2-t1, 2)
        self.assertLess(t2-t1, 4)
        self.assertTrue(c.timedout)
        
    def test_normal(self):
        t1 = time.time()
        c = Command('python3 -c "1+1"', verbose=True)
        c.run(timeout=2)
        t2 = time.time()
        self.assertTrue(True)
        self.assertEqual(c.code(), 0)
        self.assertLess(t2-t1, 1)
        self.assertFalse(c.timedout)

    def test_long_process_freeze(self):
        fileName = '__file_test_long_process_freeze.txt'
        fileNamePy = '__py_file_test_long_process_freeze.py'
        cmd = """import time; 
for x in range(4): 
    with open("{}", "w") as f: 
        f.write(str(x))
    time.sleep(0.4)
time.sleep(10)
exit(0)
        """.format(fileName)
        if os.path.exists(fileName):
            os.remove(fileName)
        if os.path.exists(fileNamePy):
            os.remove(fileNamePy)
        with open(fileNamePy, "w") as f:
            f.write(cmd)
        
        t1 = time.time()
        c = Command('python3 {}'.format(fileNamePy), verbose=True)
        c.run(timeout=1, files=[fileName])
        t2 = time.time()
        self.assertTrue(True)
        self.assertEqual(c.code(), -15)
        self.assertGreaterEqual(t2-t1, 3)
        self.assertLess(t2-t1, 4)
        self.assertTrue(c.timedout)
        if os.path.exists(fileName):
            os.remove(fileName)
        if os.path.exists(fileNamePy):
            os.remove(fileNamePy)
    
    def test_long_process_normal(self):
        fileName = '__file_test_long_process_freeze.txt'
        fileNamePy = '__py_file_test_long_process_freeze.py'
        cmd = """import time; 
for x in range(4): 
    with open("{}", "w") as f: 
        f.write(str(x))
    time.sleep(0.4)
exit(0)
        """.format(fileName)
        if os.path.exists(fileName):
            os.remove(fileName)
        if os.path.exists(fileNamePy):
            os.remove(fileNamePy)
        with open(fileNamePy, "w") as f:
            f.write(cmd)
        
        t1 = time.time()
        c = Command('python3 {}'.format(fileNamePy), verbose=True)
        c.run(timeout=1, files=[fileName])
        t2 = time.time()
        self.assertTrue(True)
        self.assertEqual(c.code(), 0)
        self.assertLess(t2-t1, 2)
        self.assertFalse(c.timedout)
        if os.path.exists(fileName):
            os.remove(fileName)
        if os.path.exists(fileNamePy):
            os.remove(fileNamePy)
        

if __name__ == '__main__':
    unittest.main()