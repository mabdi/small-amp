import argparse
import os
import glob
import sys
from datetime import datetime
import re
import json
from config import *
from smallAmpLoop import *
from zipfile import ZipFile
import time
from command import Command

def duplicateVM(force, projectName):
   destinationURL = projectsDirectory + projectName
   if not force and os.path.exists(destinationURL):
       print('Image folder is already exists. Skip vm step. ')
   else:
       if os.path.exists(destinationURL):
          os.system('rm -rf ' + destinationURL)
       os.system('cp -r '+ baseAddress + ' ' + destinationURL)
       print('Image duplicated: '+ destinationURL)

def packResult(force, projectName, projectPrefix, projectFile, extra):
   projectDirectory = projectsDirectory + projectName
   name_detail = "" if extra is None else ('_'+extra)
   #zipFile = zipDirectory + projectName + str(int(time.time())) + '.zip'
   zipFile = zipDirectory + projectName + name_detail +  '.zip'
   file_paths = []
   file_paths.append(projectDirectory+'/'+ projectName +'.stat')
   file_paths.extend(glob.glob(projectDirectory+'/*.json'))
   file_paths.extend(glob.glob(projectDirectory+'/*.st'))
   file_paths.extend(glob.glob(projectDirectory+'/*.txt'))
   file_paths.extend(glob.glob(projectDirectory+'/*.log'))
   file_paths.extend(glob.glob(projectDirectory+'/out/*.log'))

   with ZipFile(zipFile, 'w') as zip:
        for file in file_paths:
            arcname = file[len(projectsDirectory):]
            zip.write(file, arcname)

def moveToMongo(force, projectName, projectPrefix, projectFile):
   projectDirectory = projectsDirectory + projectName
   command = "ls -1 "+projectDirectory+"/*.json | while read jsonfile; do mongoimport --db test --collection "+projectName+" --file $jsonfile ; done"
   os.system(command)

def makeStat(force, projectName, projectPrefix, projectFile):
   installerURL = projectsDirectory + projectName + '/' + statStFileName
   if not force and os.path.exists(installerURL):
      print('State file found. skip stat step.')
      return
   #with open(templateFile, "r") as f:
   #   template = f.read()
   #with open(installerURL, "w") as f:
   #   f.write(template.format(projectPrefix))
   #print('StatScript is made '+ installerURL)
   destinationURL = projectsDirectory + projectName
   cwd = os.getcwd()
   os.chdir(destinationURL)
   os.system(pharoVM + ' ' + pharoImage + ' smallamp --stat={} > projectStat.log 2>&1'.format( projectName ) )
   #os.system(pharoVM + ' Pharo.image st '+ statStFileName +' --save --quit > projectStat.log')
   os.chdir(cwd)

def cleanup(force, projectName, projectPrefix, projectFile):
   destinationURL = projectsDirectory + projectName
   if not os.path.exists(destinationURL):
       print('Project folder not found')
       return
   cwd = os.getcwd()
   os.chdir(destinationURL)
   os.system( 'rm ./Pharo.changes' )
   os.system( 'rm ./Pharo.image' )
   os.system( 'rm ./Pharo8*.sources' )
   os.system( 'rm -rf ./pharo-local' )
   os.chdir(cwd)

def makeExtra(force, projectName, projectPrefix, projectFile):
   todoFile = projectsDirectory + projectName + '/' + todoFileName
   destinationURL = projectsDirectory + projectName
   if not os.path.exists(todoFile):
     print('todo file not found, skipping')
     return
   with open(todoFile,"r") as f:
      todo = f.readlines()

   for cname in todo:
       className = cname.strip()
       if not className:
          continue
#       if className in blackList():
#          print('Skipping ' + className + ' -- blacklist')
#          continue
       if os.path.exists(destinationURL + "/"+ className + '.json'):
         cwd = os.getcwd()
         os.chdir(destinationURL)
         #os.system(pharoVM + ' Pharo.image smallamp --xinfo={} > out/{}.xlog 2>&1'.format( className, className ) )
         os.system(pharoVM + ' Pharo.image smallamp --xinfo={} --nosave'.format( className) )
         os.chdir(cwd)
       else:
          print('Skipping: ' + className + ' -- not done yet')


   installerURL = projectsDirectory + projectName + '/' + statStFileName
   if not force and os.path.exists(installerURL):
      print('State file found. skip stat step.')
      return
   #with open(templateFile, "r") as f:
   #   template = f.read()
   #with open(installerURL, "w") as f:
   #   f.write(template.format(projectPrefix))
   #print('StatScript is made '+ installerURL)



def loadProject(force, projectName, projectPrefix, projectFile):
   loaderFile = projectsDirectory + projectName + '/' + loaderStFileName
   if not force and os.path.exists(loaderFile):
      print('loader file found. skip load step.')
      return
   os.system('cp  '+ projectFile + ' ' + loaderFile)
   destinationURL = projectsDirectory + projectName
   cwd = os.getcwd()
   os.chdir(destinationURL)
   os.system(pharoVM + ' Pharo.image st '+ loaderStFileName +' --save --quit > projectLoad.log 2>&1')
   os.chdir(cwd)


def checkDone(projectName, className):
    doneFile = projectsDirectory + projectName + '/' + doneFileName
    if not os.path.exists(doneFile):
       with open(doneFile, 'w'): pass
    with open(doneFile,"r") as f:
       dones = f.readlines()
    for cname in dones:
       if cname.strip() == className.strip():
           return True
    return False

def blackList():
    if not os.path.exists(blacklistfile):
       with open(blacklistfile, 'w'): pass
    with open(blacklistfile,"r") as f:
       blacklist = f.readlines()
    return [s.strip() for s in blacklist]

def markAsDone(projectName, className):
    doneFile = projectsDirectory + projectName + '/' + doneFileName
    with open(doneFile,"a+") as f:
        f.write(className)
        f.write(os.linesep)

def reloadSmallAmp(force, projectName):
   destinationURL = projectsDirectory + projectName
   cwd = os.getcwd()
   os.chdir(destinationURL)
   #os.system(pharoVM + " Pharo.image eval --save \"((IceRepository registry detect: [ :r | r name = 'small-amp' ]) pull) branch commits first id\"")
   os.system(pharoVM + " Pharo.image eval --save \"IceRepository registry detect: [ :r | r name = 'small-amp' ] ifFound: [ :r | r pullFrom: r remotes first. ^ r branch commits first shortId ]\"")
   os.chdir(cwd)

def runAmplificationUI(force, projectName):
    return runAmplificationBackend(pharoVMUI ,force, projectName, 'SAConfig default')

def runAmplification(force, projectName):
    return runAmplificationBackend(pharoVM ,force, projectName, 'SAConfig default')

def runAmplificationCustom(force, projectName, cnf):
    return runAmplificationBackend(pharoVM ,force, projectName, cnf)

def runAmplificationClass(force, projectName, className):
    return runClassAmplificationBackend(pharoVM ,force, projectName, className, 'SAConfig default')

def runClassAmplificationBackend(proc ,force, projectName,className, cnf):
   print('Amplifying: ' + className)
   cwd = os.getcwd()
   os.chdir(projectsDirectory + projectName)
   if not os.path.exists('out'):
      os.makedirs('out')
   with open('/tmp/AmpCurrent.smallamp', 'w') as f:
      f.write(projectName)
      f.write(':')
      f.write(className)
   cmd = '(SmallAmp initializeWith: ({})) testCase: {} ; amplifyEval'.format( cnf, className )
   os.system(proc + ' ' + pharoImage + ' eval  \''+ cmd  +'\' >> out/'+ className +'.log 2>&1')
   os.chdir(cwd)

def runAmplificationBackend(proc ,force, projectName, cnf):
   todoFile = projectsDirectory + projectName + '/' + todoFileName
   if not os.path.exists(todoFile):
     print('todo file not found, skipping')
     return
   with open(todoFile,"r") as f:
      todo = f.readlines()

   for cname in todo:
       className = cname.strip()
       if not className:
          continue
       if className in blackList():
          print('Skipping ' + className + ' -- blacklist')
          continue
       if force or not checkDone(projectName, className):
          runClassAmplificationBackend(proc ,force, projectName,className, cnf)
          markAsDone(projectName, className)
       else:
          print('Skipping: ' + className)


def syso(str):
   print(str, flush=True)

def runAmplificationCI_not_snapshoted(imgFile, vm, mode, className, maxInputs, iteration):
   #cmd = '(SmallAmp initializeWith: (SAConfig default iterations: {}; maxPop: {}; yourself)) testCase: {} ; amplifyEval  2>&1 | tee -a out/{}.log '.format( int(iteration), int(maxInputs), className, className )
   #os.system(vm + ' ' + imgFile + ' eval  \''+ cmd  +'\'')
   cmd = '{} {} smallamp --mode={} --testClass={}  2>&1 | tee -a out/{}.log'.format(vm, imgFile, mode, className, className)
   c = Command(cmd)
   syso('Running command: {}'.format(cmd))
   c.run(timeout=4 * 60 * 60)

def runAmplificationCI_snapshoted(imgFile, vm, mode, className):
   tout = 15*60 # every 15 minute check for freeze
   tout_files = ['_smallamp_last_state.fl', '_smallamp_crash_evidence.json', '_smallamp_last_event.json']
   
   os.system('cp '+ imgFile + ' Sandbox.image')
   os.system('cp '+ imgFile[:-6] + '.changes Sandbox.changes')
   #  cmd1 = '{} Sandbox.image smallamp --useSnapshots={} >> out/{}.log 2>&1'.format(vm, className, className)
   #  cmd2 = '{} Sandbox.image  >> out/{}.log 2>&1'.format(vm, className)
   cmd1 = '{} Sandbox.image smallamp --mode={} --testClass={} 2>&1 | tee -a out/{}.log'.format(vm, mode, className, className)
   cmd2 = '{} Sandbox.image  2>&1 | tee -a out/{}.log'.format(vm, className)
   
   cmd = cmd1
   while True:
      c = Command(cmd)
      syso('Running command: {}'.format(cmd))
      c.run(timeout=tout, files=tout_files)
      if c.code() == 0:
            syso('Amplification finished for className: {}'.format(className))
            break
      if c.timedout:
         syso('Amplification Terminated because timeout, className: {}'.format(className))
      else:
         syso('A possible crash for className: {}'.format(className))
      timestamp = int(time.time())
      os.system('cp _smallamp_last_event.json crash_event_{}.json'.format( timestamp ))
      os.system('mv _smallamp_crash_evidence.json crash_evidence_{}.json'.format( timestamp ))
      os.system('cp PharoDebug.log PharoDebug_{}.log'.format( timestamp ))
      cmd = cmd2

def runAmplificationCI_installSmallAmp(vm, imgFile, tonel):
   c = Command("""{} {} eval "[ Metacello new
        baseline: 'SmallAmp';
        repository: 'tonel://{}/src';
        onUpgrade: [ :ex | ex useIncoming ];
        onConflictUseIncoming;
        load: 'core' ] on: Warning do: [ :w | w resume ].
        Smalltalk snapshot: true andQuit: true" """.format(vm, imgFile, tonel))
   c.run(timeout=120)
   
def runAmplificationCI_stats(vm, imgFile, repo):
   syso('Making Stat files')
   c = Command(vm + ' ' + imgFile + ' smallamp --save --stat=' + repo)
   c.run(timeout=300)

def runAmplificationCI_storeAsZips(zipDirectory, repo, job_id, base):
   zipFileLogs = zipDirectory + '/' + repo + '_job_' + str(job_id) + '_' + str(int(time.time())) +  'logs.zip'
   file_paths = []
   file_paths.extend(glob.glob(base+'/*.log'))
   file_paths.extend(glob.glob(base+'/out/*.log'))

   with ZipFile(zipFileLogs, 'w') as zip:
        for  file  in  file_paths :
            arcname  =  file [ len ( base ):]
            zip.write(file, arcname)
   syso('zip file created. '+ zipFileLogs)


   zipFileResults = zipDirectory + '/' + repo + '_job_' + str(job_id) + '_' + str(int(time.time())) +  'results.zip'
   file_paths = []
   file_paths.append(base+'/'+ repo +'.stat')
   file_paths.extend(glob.glob(base+'/*.json'))
   file_paths.extend(glob.glob(base+'/*.st'))
   file_paths.extend(glob.glob(base+'/*.txt'))

   with ZipFile(zipFileResults, 'w') as zip:
        for  file  in  file_paths :
            arcname  =  file [ len ( base ):]
            zip.write(file, arcname)
   syso('zip file created. '+ zipFileResults)


def runAmplificationCI(args):
   tonel = args['tonel']
   repo = args['repo']
   vm = args['vm']
   image = args['image']
   base = args['base']
   imgFile = args['imgFile']
   zipDirectory = args['zips']
   job_id = args['job_id']
   total_jobs = args['total_jobs']

   iteration = args['iteration']
   maxInputs = args['maxInputs']
   mode = args['mode']

   syso('CI for:'+ repo)
   cwd = os.getcwd()
   os.chdir(base)

   runAmplificationCI_installSmallAmp(vm, imgFile, tonel)
   runAmplificationCI_stats(vm, imgFile, repo)

   todoFile = base + '/' + todoFileName
   if not os.path.exists(todoFile):
     syso('todo file not found, skipping')
     os.chdir(cwd)
     return

   with open(todoFile,"r") as f:
      todo = f.readlines()

   if not os.path.exists('out'):
       os.makedirs('out')

   for i in range(len(todo)):
       if i % total_jobs != job_id:
           continue
       cname = todo[i]    
       className = cname.strip()
       if not className:
          continue
       syso('Amplifying: ' + className + ' (i: ' + str(i) + ', all: '+ str(total_jobs) + ')' )
       if 'Snapshots' in mode:
          runAmplificationCI_snapshoted(imgFile, vm, mode, className)
       else:
          runAmplificationCI_not_snapshoted(imgFile, vm, mode, className, maxInputs, iteration)
          
   os.chdir(cwd)

   runAmplificationCI_storeAsZips(zipDirectory, repo, job_id, base)

