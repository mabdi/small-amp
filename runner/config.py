import os


home = os.path.expanduser("~")
pwd = os.getcwd()

manifestDirectory = "projects/"
manifestFile = manifestDirectory + "manifest.tsv"
baseAddress = home + '/Pharo-Base/'
projectsDirectory = pwd + '/../pharo-projects-files/'
statStFileName = 'stats.st'
loaderStFileName = 'loader.st'
pharoVM = home + '/Pharo/pharo'
pharoVMUI = home + '/Pharo/pharo-ui'
todoFileName = 'todo.txt'
doneFileName = 'done.txt'
blacklistfile = projectsDirectory + 'blacklist.txt'
zipDirectory = 'zips/'
pharoImage= 'Pharo.image'
CIRepoName=None
