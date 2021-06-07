#import datetime
import os
import glob
import sys
import re
import json
from config import *
from collections import Counter

#this = sys.modules[__name__]

def mut_to_string(mut):
    return '-'.join([mut['operatorDescription'], mut['class'], mut['operatorClass'], mut['method'], str(mut['mutationStart']), str(mut['mutationEnd'])])

#this.current_n = -1

def number_of_changes(list_of_methods):
    return [ re.search(r"_amp(.*)$", txt).group(1).count('_') for txt in list_of_methods]

def count_killed_mutants(lst):
   return Counter([ mut['operatorClass'] for mut in lst])

def mutation_list_compare_covered_list(covered, mutatans):
   return [ mut for mut in mutants if mut['class']+'>>#'+mut['method'] in covered]

def an_print(msg, more_det=None, verbose=False):
   """this.current_n += 1
   if n_anomaly == -1:
      print(str(this.current_n) + ': ' + msg)
   if n_anomaly > -1 and n_anomaly == this.current_n:
      print(str(this.current_n) + ': ' + msg)
      print('--more details--' + str(more_det))"""
   print( msg)
   if verbose:
      print('--more details--' + str(more_det))

def toPrettyTime(secs):
  m, s = divmod(secs, 60)
  h, m = divmod(m, 60)
  return '{:d}:{:02d}:{:02d}'.format(h, m, s)

def get_median(lst):
   idx = (len(lst) - 1) // 2
   if len(lst) % 2:
      return lst[idx], idx
   else:
      return ((lst[idx] + lst[idx+1]) / 2.0), idx

def get_boxplot_infor(alist):
   if len(alist)<4:
     return {"out_min": -1, "out_min":-1, "minimum":-1, "maximum":-1, "iqr":-1, "q1":-1, "q3":-1, "median":-1}
   alist.sort()
   #print(alist)
   median, mid_idx = get_median(alist)
   q1, q1_idx = get_median(alist[:mid_idx])
   q3, q3_idx = get_median(alist[mid_idx:])
   iqr = q3 - q1
   minimum = max(min(alist), q1 - 1.5 * iqr)
   maximum = min(max(alist), q3 + 1.5 * iqr)
   out_min = [x for x in alist if x < minimum]
   out_max = [x for x in alist if x > maximum]

   return {"out_min": out_min, "out_min":out_min, "minimum":minimum, "maximum":maximum, "iqr":iqr, "q1":q1, "q3":q3, "median":median}

def reportAnomalies(directory, projectName, fix, verbose):
   data = reportAmp_backend(directory, fix)
   if not data:
     return (projectName + ',unknown')
   for row in data:
      if row['stat'] == 'success':
          jsonObj = row['jsonObj']
          imp = jsonObj['mutationScoreAfter'] - jsonObj['mutationScoreBefore']
          before = {mut_to_string(x) for x in jsonObj['notCoveredInOriginal']}
          after_killed = {mut_to_string(x) for x in jsonObj['newCovered']}
          after_alive = {mut_to_string(x) for x in jsonObj['notCoveredInAmplified']}

          if  imp <  0:
             an_print(projectName + ',' + row['className'] + ',' + 'negative amplification')
          if len(jsonObj['amplifiedMethods'])== 0 and imp != 0:
             an_print(projectName + ',' + row['className'] + ',' + 'no new method but change in score')
          if len(jsonObj['newCovered']) + len(jsonObj['notCoveredInAmplified']) !=  len(jsonObj['notCoveredInOriginal']):
             an_print(projectName + ',' + row['className'] + ',' + 'mutation stat size mismatch')
          an1 = after_killed.union(after_alive) - before
          if len(an1)>0:
             an_print(projectName + ',' + row['className'] + ',' + 'new mutation after', str(an1), verbose)
          an2 = before - after_killed.union(after_alive) 
          if len(an2)>0:
             an_print(projectName + ',' + row['className'] + ',' + 'new mutation before', str(an2), verbose)
      else:
          if 'className' in row.keys():
             an_print(projectName + ',' + row['className'] + ',' + row['stat'])
          else:
             an_print(projectName + ',' + row['stat'], json.dumps(row), verbose)


def reportTexSumTable(directory, projectName):
   data = reportAmp_backend(directory, True)
   if not data:
     return (projectName + ',unknown') 
   id = 99
   tcn = 0 #total class number
   tmn = 0 # total method number
   is_imp = 0 # the number of classes having an increase
   imp_sum = 0 # sum of increases, used for average
   mut_killed = 0 # sum all killed muts
   gmn = 0 # sum generated methods number
   tt = 0 # total time
   for row in data:
      if row['stat'] == 'success':
         jsonObj = row['jsonObj']
         tcn  += 1
         tmn += jsonObj.get('numberOfOriginalTestMethods',0)
         if len(jsonObj['amplifiedMethods']):
             is_imp +=1
         imp_sum += jsonObj['mutationScoreAfter'] - jsonObj['mutationScoreBefore']
         mut_killed += len(jsonObj['newCovered'])
         gmn += len(jsonObj['amplifiedMethods'])
         tt += jsonObj['timeTotal']

   print(' & '.join(str(x) for x in [id, projectName ,
                tcn, tmn,is_imp, ("%.2f" % (imp_sum / tcn)),mut_killed,gmn,
                toPrettyTime( tt )]) + '\\\\')


def reportTexTables(directory, projectName):
   data = reportAmp_backend(directory, True )
   if not data:
     return (projectName + ',unknown')
   print('\hline')
   print('\multicolumn{13}{|c|}{' + projectName + '}\\\\')
   print('\hline')
   id = 0
   for row in data:
      if row['stat'] == 'success':
         id = id + 1
         jsonObj = row['jsonObj']
         killedOriginal = jsonObj['numberOfAllMutationsInOriginal'] - len( jsonObj['notCoveredInOriginal'])
         score1 = 100 * ( killedOriginal / jsonObj['numberOfAllMutationsInOriginal'])
         score2 = 100 * (( killedOriginal + len(jsonObj['newCovered']) ) / jsonObj['numberOfAllMutationsInOriginal'])
         print(' & '.join(str(x) for x in [id, row['className'],
		jsonObj.get('numberOfOriginalTestMethods','NA'),
		jsonObj['targetLoc'],
		jsonObj['numberOfAllMutationsInOriginal'],
#		jsonObj['mutationScoreBefore'],
		"{:.2f}".format( score1 ),
#		len(jsonObj['notCoveredInOriginal']) - len(jsonObj['newCovered']),
		len(jsonObj['notCoveredInOriginal']),
#		jsonObj['mutationScoreAfter']
		"{:.2f}".format( score2 ),
		"{:.2f}".format( score2 - score1 ),
		len(jsonObj['amplifiedMethods']),
		"-" if killedOriginal==0 else "{:.2f}".format(len(jsonObj['newCovered']) / killedOriginal  ),
		len(jsonObj['newCovered']),
		toPrettyTime( jsonObj['timeTotal'] )]) + '\\\\')

def analyseMethodName(mName):
   import re
   m = re.search('.+\>\>\#test.+_amp(.*)', mName)
   p = [x[0] if len(x) >0 else '' for x in m.group(1).split("_")]
   return p[1:]


def pushit(dic1,dic):
    for k,v in dic.items():
       dic1[k] = dic1.get(k,0) + v

g_lens = {}
g_amps  =  {}

def reportAmpsStat(directory, projectName):
   data = reportAmp_backend(directory, True )
   if not data:
     return (projectName + ',unknown')
   lens = {}
   amps = {}
   for row in data:
     if row['stat'] == 'success':
       jsonObj = row['jsonObj']
       thisAmps = [analyseMethodName(x) for x in jsonObj['amplifiedMethods']]
       for lst in thisAmps:
          lens[str(len(lst))] = lens.get(str(len(lst)),0) + 1
          if len(lst) == 0:
             amps['none'] = amps.get("none",0) + 1
          for x in lst:
             amps[x] = amps.get(x,0) + 1
   pushit(g_lens,lens)
   pushit(g_amps,amps)
   print(projectName + " lens: ", lens)
   print(projectName + " amps: ", amps)
   print("g_lens: ", g_lens)
   print("g_amps: ", g_amps)

def reportStat(projectName):
   d = reportStat_backend(projectName)
   if d:
      print(','.join(str(x) for x in reportStat_backend(projectName) ))

def reportStat_backend(directory, projectName):
   statFile = glob.glob(directory + '/*.stat')[0]
   if not os.path.exists(statFile):
      #print('file not found: '+ statFile)
      return []
   with open(statFile) as f:
      stat = f.read()
   matches = re.findall("#(\w+)->(true|false|\d+|'[0-9a-z]+')\.?", stat)
   matches = {tuple[0]:tuple[1] for tuple in matches}
   if 'commitId' not in matches.keys():
      matches['commitId'] = 'NA'
   return [str(x) for x in [
        projectName,
        matches['allGreen'],
        matches['classes'],
        matches['tests'],
        matches['targetedTests'],
        matches['targetedTestsMethods'],
        matches['commitId']
   ]]


def reportSum(directory, projectName, fix):
   data = reportAmp_backend(directory, fix)
   stat = reportStat_backend(directory, projectName)
   #print(stat)
   if not data:
     return (projectName + ',unknown')
   max_imp = -101
   sum_imp = 0
   sum_imp_no100 = 0
   n_no100 = 0
   all_new_killed = 0
   all_new_methods = 0
   sum_time = 0
   n_fail = 0
   imps_no100 = []
   for row in data:
#      print(row['stat'])
      if row['stat'] != 'success':
         n_fail += 1
      else:
         jsonObj = row['jsonObj']
         sum_time += jsonObj['timeTotal']
         imp = jsonObj['mutationScoreAfter'] - jsonObj['mutationScoreBefore']
         #print(imp)
         if imp < 0:
           continue 
         sum_imp += imp
         all_new_killed += len(jsonObj['newCovered'])
         all_new_methods += len(jsonObj['amplifiedMethods'])
         if jsonObj['mutationScoreBefore'] < 100:
            imps_no100.append(imp)
            n_no100 += 1
            sum_imp_no100 += imp
         if imp > max_imp:
            max_imp = imp
   #print(imps_no100)
   bpi = get_boxplot_infor(imps_no100)
   n_cases = len(data)
   avg_imp = sum_imp / n_cases if n_cases != 0 else 0
   avg_imp_n100 = sum_imp_no100 / n_no100 if n_no100 != 0 else 0
   n_imp_less = 0
   n_imp_more = 0
   for row in data:
      if row['stat'] == 'success':
         jsonObj = row['jsonObj']
         imp = jsonObj['mutationScoreAfter'] - jsonObj['mutationScoreBefore']
         if imp >= avg_imp_n100:
            n_imp_more += 1
         else:
            n_imp_less += 1

   print(','.join(str(x) for x in [projectName, n_cases, max_imp, n_fail, avg_imp, n_imp_less, 
            n_imp_more, sum_time, avg_imp_n100, n_no100, all_new_methods, all_new_killed, 
            bpi['q1'],bpi['q3'],bpi['minimum'],bpi['maximum'],bpi['median'],
            stat[1], stat[2],stat[3],stat[4],stat[5],stat[6]
         ]))

def do_fix(old_result):
   target2test = {}
   result = []
   for row in old_result:
      if row['stat'] == 'success':
         jsonObj = row['jsonObj']
         targets = ' '.join(jsonObj['targetClasses'])
         if targets not in target2test:
            target2test[targets] = []  
         target2test[targets].append(row)
   for target,testslist in target2test.items():
      obj = testslist[0]
      if len(testslist) > 1:
         originalTestCase = obj['jsonObj']['originalTestCase']
         obj['className'] = originalTestCase
         mutationScoreBefore = obj['jsonObj']['mutationScoreBefore']
         allNewKilled = [mutant for x in testslist for mutant in x['jsonObj']['newCovered']]
         newCovered = list({ "{}:{}:{}:{}".format(item['method'], item['operatorClass'], item['mutationStart'], item['mutationEnd']) : item for item in allNewKilled }.values())
         obj['jsonObj']['newCovered'] = newCovered
         #uniqKilledMutants = { }
         mutationScoreImprove = (100.0) * (len(newCovered) / obj['jsonObj']['numberOfAllMutationsInOriginal'])
         obj['jsonObj']['mutationScoreAfter'] = mutationScoreBefore + mutationScoreImprove
         obj['jsonObj']['numberOfOriginalTestMethods'] = sum(x['jsonObj']['numberOfOriginalTestMethods'] for x in testslist)
         obj['jsonObj']['amplifiedMethods'] = list(set([m for x in testslist for m in x['jsonObj']['amplifiedMethods']]))
         obj['jsonObj']['timeTotal'] = sum(x['jsonObj']['timeTotal'] for x in testslist)
      result.append(obj)

   return result


def reportAmp(directory, projectName, fix, verbose):
   data = reportAmp_backend(directory, fix)
   if not data:
      print(projectName + ',,unknown')
      return
   for row in data:
      if row['stat'] == 'success':
          jsonObj = row['jsonObj']
          targets = ' '.join(jsonObj['targetClasses'])
          xjson = row['xjson']
          if not xjson:
             xjson = {'targetChurn': 'NA',
                  'testChurn': 'NA',
                  'assertionDensityOriginal': 'NA',
                  'assertionDensityAmplified': 'NA',
                  'originalCoverageStatementes': 'NA',
                  'amplifiedCoverageStatementes': 'NA',
                  'originalCoverageBranches': 'NA',
                  'amplifiedCoverageBranches': 'NA',
                  'originalCoverageMethods': 'NA',
                  'amplifiedCoverageMethods': 'NA',
                  'directTestingOriginal': 'NA'
               }
             print(projectName + ',' + row['className'] + ',' + 'Finished successfully' + ',' + ','.join(str(x) for x in [
                  jsonObj['amplifiedClass'],
                  targets,
                  "{:.2f}".format(jsonObj['mutationScoreBefore']),
                  "{:.2f}".format(jsonObj['mutationScoreAfter']),
                  "{:.2f}".format(jsonObj['mutationScoreAfter'] - jsonObj['mutationScoreBefore']),
                  jsonObj.get('numberOfOriginalTestMethods','NA'),
                  jsonObj['targetLoc'],
                  jsonObj['testLoc'],
                  jsonObj['testAmpLoc'],
                  xjson['assertionDensityOriginal'],
                  xjson['assertionDensityAmplified'],
                  xjson['originalCoverageStatementes'],
                  xjson['amplifiedCoverageStatementes'],
                  xjson['originalCoverageBranches'],
                  xjson['amplifiedCoverageBranches'],
                  xjson['originalCoverageMethods'],
                  xjson['amplifiedCoverageMethods'],
                  len(jsonObj['amplifiedMethods']),
                  len(jsonObj['notCoveredInOriginal']),
                  len(jsonObj['newCovered']),
                  len(jsonObj['notCoveredInAmplified']),
                  len(jsonObj['methodsNotProfiled']),
                  jsonObj['timeTotal'],
                  xjson['targetChurn'],
                  xjson['testChurn'],
                  xjson['directTestingOriginal'],
                  max(number_of_changes(jsonObj['amplifiedMethods']) or [0])

               ]))
      elif row['stat'] == 'error':
          print(projectName + ',' + row['className'] + ',' + 'Finished with Error ({}) {}'.format(row['errDet'],row['lastMethod']))
      elif row['stat'] == 'fail':
          print(projectName + ',' + row['className'] + ',' + 'Unfinished Run (Image Crash?)')
      elif row['stat'] == 'blacklist':
          print(projectName + ',' + row['className'] + ',' + 'Skipped (blacklist)')
      else:
          print('fatal: ' + json.dumps(row))

def reportAmp_backend(directory, fix):
   result = []
   todoFile = directory + '/' + todoFileName
   if not os.path.exists(todoFile):
      return None

   json_files = [pos_json for pos_json in os.listdir(directory) if pos_json.endswith('.json')] # changed to .json
   blacklistclasses = []
   if os.path.exists(blacklistfile):
      with open(blacklistfile) as f:
         blacklistclasses = f.readlines()
      blacklistclasses = [s.strip() for s in blacklistclasses]
   with open(todoFile,"r") as f:
      todo = f.readlines()
   #print(12)
   for cname in todo:
      jsonObj = None
      xjson = None
      className = cname.strip()
      if className in blacklistclasses:
         result.append({'stat':'blacklist','className':className})
         continue
      if os.path.exists(directory + "/"+ className + '.json'):
            with open(directory + "/"+ className + '.json') as f:
               jsonStr = f.read()
            try:
                jsonObj = json.loads(jsonStr)
            except:
                pass
            if os.path.exists(directory + "/"+ className + '.xjson'):
               with open(directory + "/"+ className + '.xjson') as f:
                   jsonStrx = f.read()
               try:
                   xjson = json.loads(jsonStrx)
               except:
                   pass

            if jsonObj:
               result.append({'stat':'success','className':className,'jsonObj':jsonObj,'xjson': xjson})
               continue
      logFile = directory +  '/' +  className + '.log'
      if not os.path.exists(logFile):
         logFile = directory + '/out/' + className + '.log'
         if not os.path.exists(logFile):
             result.append({'stat':'unknown','className':className})
             continue
      try:
         with open(logFile) as f:
            log = f.read()
      except:
         print('cannot read file: ', logFile)
         result.append({'stat':'fail','className':className})
         continue
      #if not "Run finish" in log:
      if 'SANoUncovered' in log:
         errDet = 'SANoUncovered'
         lastMethod = ''
         result.append({'stat':'error','className':className,'errDet':errDet, 'lastMethod': lastMethod})
         continue
      if 'SANoGreenTest' in log:
         errDet = 'SANoGreenTest'
         lastMethod = ''
         result.append({'stat':'error','className':className,'errDet':errDet, 'lastMethod': lastMethod})
         continue
      if "Error details" in log:
         errDet = re.findall('Error details:(.+)',log)[0]
         ampMethods = re.findall('assert amplification:(.+)',log)
         lastMethod = ampMethods[-1] if len(ampMethods) > 0 else ''
         result.append({'stat':'error','className':className,'errDet':errDet, 'lastMethod': lastMethod})
      else:
         result.append({'stat':'fail','className':className})

   if fix:
      return do_fix(result)
   return result

