#!/bin/bash

# make dir
if [ ! -d "../vcd" ]; then
  mkdir ../vcd
fi

# clean
rm -rf DVEfiles
rm -rf csrc
rm -rf simv*
rm *.log
rm *.vcd
rm *.vpd
rm ucli.key

# compile
vcs -f 1_behavior_filelist -full64 -sverilog -debug_access+all +vcd+vcdpluson -l vcs.log
