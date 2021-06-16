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
$ export iteration=3 
$ export maxInputs=10 
$ export mode=diff 
$ cd /some/path/small-amp/pharo-projects-files
$ mkdir debugRun # any name you like
$ cd debugRun
$ cp ../../scripts/installPharo.sh . 
$ ./installPharo.sh
$ export PHARO_HOME=$PWD
$ export PHARO_IMAGE=Pharo.image
$ export PHARO_VM=$PHARO_HOME/pharo
$ export SMALLAMP_ZIPS=$PHARO_HOME
$ git clone https://github.com/mabdi/DataFrame # replace with project under test
$ cp ../../scripts/load_project.st .
$ export project_baseline=DataFrame 
$ export project_repository=$PWD/DataFrame/src
$ export GITHUB_WORKSPACE=$PWD/DataFrame
$ export reponame=DataFrame 
$ ./pharo Pharo.image st load_project.st
$ cp ../../scripts/load_SmallAmp.st .
$ SMALLAMP_TONEL=../.. ./pharo Pharo.image st load_SmallAmp.st
$ ./pharo Pharo.image smallamp  --save --stat=DataFrame 
$ cd ../../runner 
$ SMALLAMP_PORTION=6 SMALLAMP_ALLJOBS=20 python3 runner.py -g
```
