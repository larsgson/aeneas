#! /usr/bin/bash

for i in $(seq -f "%02g" 01 50)
do
  echo "Processing audio and text sync for story #"$i
  arg1="data/pt-br-OBS/pt-br_obs_"$i".wav "
  arg2="data/pt-br-OBS/"$i".md "
  arg3="output/map"$i".csv"
  arg4="output/img_pos"$i".csv"
  arg5="output/img_pos"$i".json"
  python3 -m aeneas.tools.execute_task $arg1 $arg2 "task_language=eng|os_task_file_format=csv|is_text_type=plain" $arg3
  echo "Filter relevant fields for story #"$i
  grep obs-en- $arg3 | cut -d , -f2,4 | sed -E "s/\!\[OBS Image\]\(https\:\/\/cdn\.door43\.org\/obs\/jpg\/360px\/obs-en-//g" | sed -E "s/\.jpg\)//g" > $arg4
  cat $arg4 | python3 -c 'import csv, json, sys; print(json.dumps([dict(r) for r in csv.DictReader(sys.stdin, ["pos","img"])]))' > $arg5
done
