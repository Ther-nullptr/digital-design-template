# Digital Design Template

## Preprocess

Download the tsmc 65nm standard cell library from [here](https://cloud.tsinghua.edu.cn/f/f3e4d88661224af098db/?dl=1) and unzip it to `lib/`.

## Behavioral Simulation

The source files are in `src/` and the testbenches are in `test/`. Change the `run_1_behavior/1_behavior_filelist` according to your needs. Then run:

```bash
cd run_1_behavior
bash run_1_behavior.sh
./simv
```

The `.vcd` file will be generated in `vcd/`.

![behavior](https://s2.loli.net/2023/11/23/AWPSQ7ErBaNxsob.png)

## DC Synthesis

Change the `src_files` in `run.tcl` and the clock/reset definition in `scripts/cons.tcl`. Then run:

```bash
bash run_2_dc.sh
```

The netlist will be generated in `netlist/`, and the reports will be generated in `report/`.

## Post-Synthesis Simulation

Change the `run_3_post/3_post_filelist` according to your needs. Then run:

```bash
cd run_3_post
bash run_3_post.sh
./simv
```

The `.vcd` file will be generated in `vcd/`. Note the `.vcd` file is different from the one generated in behavioral simulation.

![post](https://s2.loli.net/2023/11/23/nGh2muBvArWVPbs.png)