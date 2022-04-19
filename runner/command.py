import subprocess, threading, os
import datetime
import signal
import sys
from pathlib import Path


class Command(object):
    def __init__(self, cmd, redirectTo = None, verbose=False, expire_time=0):
        self.cmd = cmd
        self.process = None
        self.timedout = False
        self.verbose = verbose
        self.redirectTo = redirectTo
        self.logs = []
        self.retry = 10
        self.expire_time = expire_time

    def log(self, txt):
        if self.verbose:
            print(datetime.datetime.now().timestamp(), txt, flush=True)
            self.logs.append(txt)

    def run(self, timeout, files=[]):
        self.log('run enter')
        def target():
            self.log('run#target enter, redirectTo: {}'.format(self.redirectTo))
            if self.redirectTo is None:
                self.process = subprocess.Popen(self.cmd.split(' '), shell=False, preexec_fn=os.setsid)
                self.process.communicate()
            else:
                self.process = subprocess.Popen(self.cmd.split(' '), shell=False, stdout=subprocess.PIPE, 
                                        stderr=subprocess.STDOUT, preexec_fn=os.setsid)
                with open(self.redirectTo, 'ab') as f:
                    for line in self.process.stdout:
                        f.write(line)
                        sys.stdout.buffer.write(line)
                        
            self.log('run#target exit')

        thread = threading.Thread(target=target)
        thread.start()
        while self.retry>0:
            if self.expire_time > 0 and self.expire_time < int(datetime.datetime.now().timestamp()):
                self.log('expire time passed')
                break
            self.log('run-while enter')
            self.retry = self.retry - 1
            join_time = min(timeout, 60)
            thread.join(join_time)
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
                        # m_time = os.path.getmtime(file)
                        m_time = float(Path(file).read_text())
                        self.log('run-while-for-if-1, m_time={}, now_time={}, timeout={}'.format(m_time, now_time, timeout))
                        if now_time - m_time > timeout:
                            kill_it = True
                        else:
                            self.retry = 10
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
            poll = self.process.poll()
            wait = self.process.poll()
            returnCode = self.process.returncode
            pid = self.process.pid
            self.log('code called.pid: {}, poll: {}, wait: {}, return code: {}'.format(pid, poll, wait, returnCode))
            return returnCode
