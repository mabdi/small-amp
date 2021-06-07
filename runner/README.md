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
$ rm "smallAmp-*.zip"
$ yes | unzip "*.zip"
$ rm "*.zip"
```

Run the tool:

```
$ cd /some/path/small-amp/runner
$ python3 runner.py -r amp -p MyProj-4

```
