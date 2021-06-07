import subprocess, threading, os
import datetime

class Command(object):
    def __init__(self, cmd):
        self.cmd = cmd
        self.process = None
        self.timedout = False

    def run(self, timeout, files=[]):
        def target():
            self.process = subprocess.Popen(self.cmd, shell=True)
            self.process.communicate()

        thread = threading.Thread(target=target)
        thread.start()
        while True:
           thread.join(timeout)
           if not thread.is_alive():
               break
           kill_it = False
           if len(files) == 0:
               kill_it = True
           for file in files:
               if os.path.exists(file):
                    try:
                        m_time = os.path.getmtime(file)
                        if datetime.datetime.now().timestamp() - m_time > timeout:
                            kill_it = True
                    except:
                        pass
           if kill_it:
               break
        if thread.is_alive():
            # self.process.terminate()
            os.killpg(self.process.pid, signal.SIGTERM)
            self.timedout= True
            thread.join()

    def code(self):
        if self.process:
            return self.process.returncode
