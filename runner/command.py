import subprocess, threading, os
import datetime
import signal

class Command(object):
    def __init__(self, cmd, verbose=False):
        self.cmd = cmd
        self.process = None
        self.timedout = False
        self.verbose = verbose
        self.logs = []

    def log(self, txt):
        if self.verbose:
            print(datetime.datetime.now().timestamp(), txt)
            self.logs.append(txt)

    def run(self, timeout, files=[]):
        self.log('run enter')
        def target():
            self.log('run#target enter')
            self.process = subprocess.Popen(self.cmd, shell=True, preexec_fn=os.setsid)
            self.process.communicate()
            self.log('run#target exit')

        thread = threading.Thread(target=target)
        thread.start()
        while True:
            self.log('run-while enter')
            thread.join(timeout)
            self.log('run-while-1, thread.is_alive={}'.format(thread.is_alive()))
            if not thread.is_alive():
                break
            kill_it = False
            if len(files) == 0:
               kill_it = True
            self.log('run-while-2, len(files)={}, kill_it={}'.format(len(files), kill_it))
            for file in files:
                self.log('run-while-for enter, file={}'.format(file))
                if os.path.exists(file):
                    self.log('run-while-for-if enter')
                    try:
                        now_time = datetime.datetime.now().timestamp()
                        m_time = os.path.getmtime(file)
                        self.log('run-while-for-if-1, m_time={}, now_time={}, timeout={}'.format(m_time, now_time, timeout))
                        if now_time - m_time > timeout:
                            kill_it = True
                        self.log('run-while-for-if-2, kill_it ={}'.format(kill_it))
                    except:
                        pass
                    self.log('run-while-for-if exit')
                self.log('run-while-for exit')
            self.log('run-while3, kill_it ={}'.format(kill_it))
            if kill_it:
               break
        self.log('run-while exit, thread.is_alive() ={}'.format(thread.is_alive()))
        if thread.is_alive():
            #import code; code.interact(local=locals)
            self.log('run-if enter, process={}'.format(self.process.pid))
            # self.process.terminate()
            # self.process.kill
            #os.killpg(self.process.pid, signal.SIGTERM)
            os.killpg(os.getpgid(self.process.pid), signal.SIGTERM)  
            
            self.timedout= True
            self.log('run-if-1')
            thread.join()
            self.log('run-if exit')

    def code(self):
        self.log('code called. check None: {}'.format(self.process is None))
        if self.process:
            returnCode = self.process.poll()
            self.log('code called. poll: {}, return code: {}'.format(returnCode, self.process.returncode))
            return self.process.returncode
