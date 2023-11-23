#!/bin/bash

# clean
rm -rf DVEfiles
rm -rf csrc
rm -rf simv*
rm *.log
rm *.vcd
rm *.vpd
rm ucli.key

# compile
vcs -f 3_post_filelist -full64 -sverilog -debug_access+all -l vcs.log
