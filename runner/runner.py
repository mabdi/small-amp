import argparse
import config as configModule
from config import *
from steps import *
from reports import *
import datetime
import os

parser = argparse.ArgumentParser(description='Evaluate SmallAmp on selected projects.')
parser.add_argument('-g', '--githubci', help='Run inside github actions', action='store_true')
parser.add_argument('-p', '--project', help='Process on just specified project')
parser.add_argument('-d', '--directory', help='The directory in which todo.txt is placed')
parser.add_argument('-s', '--step', help='Process only specified step' , choices=['vm', 'load', 'stat', 'amp', 'reload', 'ampui', 'prepare', 'extra', 'cleanup', 'mongo', 'zip', 'ampc'] )
parser.add_argument('-f', '--force', help='Use force' , action='store_true')
parser.add_argument('-r', '--report', help='Generate report',  choices=['stat', 'amp', 'sum', 'anm', 'longtable', 'sumtable', 'ampslog'])
parser.add_argument('-v', '--verbose', help='Verbose', action='store_true')
parser.add_argument('-x', '--fix', help='fix scores', action='store_true')
parser.add_argument('-a', '--additional', help='additional required parameters')

args = parser.parse_args()
force = args.force
step = args.step
project =args.project
directory =args.directory
report = args.report
verbose = args.verbose
additional= args.additional
fix = args.fix
githubci = args.githubci

def parseManifest(manifestFile):
   manifest = []
   with open(manifestFile, "r") as f:
      lines = f.readlines()
   for line in lines:
     if not line.strip() or line.startswith('#'):
       continue
     cols = line.split("\t")
     manifest.append({'name': cols[0].strip(), 'prefix': cols[1].strip(), 'file': manifestDirectory + cols[2].strip() })
   return manifest

def processMain():
   projects = parseManifest(manifestFile)
   if step is None and project is None:
     parser.print_help()
     return
   if step == 'cleanup' and project is None and not force:
     print('Specify a project or use -f')
     return
   for p in projects:
     if project is None or project == p['name']:
        if step is None or step == 'vm':
           duplicateVM(force, p['name'])
        if step is None or step == 'load':
           loadProject(force, p['name'], p['prefix'], p['file'])
        if step is None or step == 'stat':
           makeStat(force, p['name'], p['prefix'], p['file'])
        if step == 'extra':
           makeExtra(force, p['name'], p['prefix'], p['file'])
        if step == 'reload':
           reloadSmallAmp(force, p['name'])
        if step is None or step == 'amp':
           runAmplification(force, p['name'])
        if step == 'ampui':
           runAmplificationUI(force, p['name'])
        if step == 'ampc':
           runAmplificationCustom(force, p['name'], additional)
        if step == 'prepare':
           print('dup vm:')
           duplicateVM(force, p['name'])
           print('load proj:')
           loadProject(force, p['name'], p['prefix'], p['file'])
           print('make stat:')
           makeStat(force, p['name'], p['prefix'], p['file'])
        if step == 'cleanup':
           cleanup(force, p['name'], p['prefix'], p['file'])
        if step == 'mongo':
           moveToMongo(force, p['name'], p['prefix'], p['file'])
        if step == 'zip':
           packResult(force, p['name'], p['prefix'], p['file'], additional)
        if step == 'finalize':
           packResult(force, p['name'], p['prefix'], p['file'])
           moveToMongo(force, p['name'], p['prefix'], p['file'])

def doReport(project):
   if directory is None:
      d = projectsDirectory + project
   else:
      d = directory
   if report == 'stat':
      reportStat(d, project)
   elif report == 'amp':
      reportAmp(d, project, fix, verbose)
   elif report == 'sum':
      reportSum(d, project,fix)
   elif report == 'anm':
      reportAnomalies(d, project, fix , verbose)
   elif report == 'longtable':
      reportTexTables(d, project)
   elif report == 'sumtable':
      reportTexSumTable(d, project)
   elif report == 'ampslog':
      reportAmpsStat(d, project)

def reportMain():
   if project is None:
      projects = parseManifest(manifestFile)
      for p in projects:
         doReport(p['name'])
   else:
      doReport(project)

def githubCIMain():
   args = {
      "repo": os.getenv('reponame'),
      "vm": os.getenv('SMALLTALK_CI_VM'),
      "image": os.getenv('SMALLTALK_CI_IMAGE'),
      "zips": os.getenv('SMALLAMP_CI_ZIPS'),
      "job_id": int(os.getenv('SMALLAMP_PORTION')),
      "total_jobs": int(os.getenv('SMALLAMP_ALLJOBS')),
      "tonel": os.getenv('SMALLAMP_TONEL'),
      "iteration": os.getenv('SMALLAMP_iteration'),
      "maxInputs": os.getenv('SMALLAMP_maxInputs'),
      "mode": os.getenv('SMALLAMP_mode'),
      "base": os.path.dirname(os.getenv('SMALLTALK_CI_IMAGE')),
      "imgFile": os.path.basename(os.getenv('SMALLTALK_CI_IMAGE'))
   }
   #print("ENV==> jobIndex: {}, jobTotal: {}, repo: {}, vm: {}, image: {}, base: {}, imgFile: {}, zips: {}, tonel: {}, iteration: {}, maxInputs: {}, mode: {}".
   #      format( job_id, total_jobs, repo, vm, image, base, imgFile, zips, tonel, iteration, maxInputs, mode ), flush=True)
   print(args, flush=True)
   runAmplificationCI(args)

if report is not None:
   reportMain()
else:
   print('Script started at: ', datetime.datetime.now().strftime("%m/%d/%Y, %H:%M:%S"), flush=True)
   if githubci:
      githubCIMain()
   else:
      processMain() #default action
   print('Script finished at: ', datetime.datetime.now().strftime("%m/%d/%Y, %H:%M:%S"), flush=True)

