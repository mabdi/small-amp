# SmallAmp-runner

How to use it:

Setup the project:

```
$ pwd
/some/path/
$ git clone https://github.com/mabdi/small-amp.git
$ cd small-amp
$ mkdir pharo-projects-files
```
Suppose that we are going to download artifacts from `MyProj` run number `4`.
Create the following folder, then download all artifacts into it, then uzip:

```
$ mkdir pharo-projects-files/MyProj-4
$ cd pharo-projects-files/MyProj-4
$ # cp Downloaded artifacts here
$ yes | unzip "smallAmp-*.zip"
$ rm smallAmp-*.zip
$ yes | unzip "*.zip"
$ rm *.zip
```

Run the tool:

```
$ cd /some/path/small-amp/runner
$ python3 runner.py -r amp -p MyProj-4

```

## Useful commands for debugging

Use this command for extracting in separated folders:

```
$ find . -name '*.zip' -exec sh -c 'unzip -d `basename {} .zip` {}' \;
```

Check the validity of run (All todo.txt must be equal):
```
$ md5 */todo.txt
```

### Runing locally:

```
$ cd /some/path/small-amp/pharo-projects-files
$ mkdir debugRun # any name you like
$ cd debugRun

$ echo "export GIT_REPO=CHANGEME # https://github.com/mabdi/DataFrame
export reponame=CHANGEME # DataFrame 
export project_baseline=CHANGEME # DataFrame 
export iteration=3 
export maxInputs=10 
export mode=diff 
cp ../../scripts/installPharo.sh . 
./installPharo.sh
export PHARO_HOME=\$PWD
export PHARO_IMAGE=Pharo.image
export PHARO_VM=\$PHARO_HOME/pharo
mkdir _zips
export SMALLAMP_ZIPS=\$PHARO_HOME/_zips
git clone \$GIT_REPO 
cp ../../scripts/load_project.st .
export project_repository=\$PWD/\$reponame/src
export GITHUB_WORKSPACE=\$PWD/\$reponame
./pharo Pharo.image st load_project.st
cp ../../scripts/load_SmallAmp.st .
SMALLAMP_TONEL=../.. ./pharo Pharo.image st load_SmallAmp.st
./pharo Pharo.image smallamp  --save --stat=\$reponame " > setup.sh

$ nano setup.sh # change me
$ chmod +x setup.sh
$ ./setup.sh
$ cd ../../runner 
$ SMALLAMP_PORTION=6 SMALLAMP_ALLJOBS=20 python3 runner.py -g
```
