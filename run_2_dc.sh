# create dir
if [ ! -d "./db" ]; then
  mkdir ./db
fi

if [ ! -d "./report" ]; then
  mkdir ./report
fi

dc_shell-t -f ./run.tcl 