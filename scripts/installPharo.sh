#!/bin/bash

curl -s -L https://get.pharo.org/90 >install.sh
bash ./install.sh
rm ./install.sh

curl -s -L https://get.pharo.org/vm90 >install.sh
bash ./install.sh
rm ./install.sh
