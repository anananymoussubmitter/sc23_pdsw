#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

./outer_loop_nyc_127.sh 12:00:00 QUERY1 RUN1
./outer_loop_mri_127.sh 12:05:00 QUERY1 RUN1
./outer_loop_nyc_127.sh 12:10:00 QUERY2 RUN1
./outer_loop_mri_127.sh 12:15:00 QUERY2 RUN1

./outer_loop_nyc_127.sh 12:20:00 QUERY1 RUN2
./outer_loop_mri_127.sh 12:25:00 QUERY1 RUN2
./outer_loop_nyc_127.sh 12:30:00 QUERY2 RUN2
./outer_loop_mri_127.sh 12:35:00 QUERY2 RUN2

./outer_loop_nyc_127.sh 12:40:00 QUERY1 RUN3
./outer_loop_mri_127.sh 12:45:00 QUERY1 RUN3
./outer_loop_nyc_127.sh 12:50:00 QUERY2 RUN3
./outer_loop_mri_127.sh 12:55:00 QUERY2 RUN3

./outer_loop_nyc_127.sh 13:00:00 QUERY1 RUN4
./outer_loop_mri_127.sh 13:05:00 QUERY1 RUN4
./outer_loop_nyc_127.sh 13:10:00 QUERY2 RUN4
./outer_loop_mri_127.sh 13:15:00 QUERY2 RUN4

./outer_loop_nyc_127.sh 13:20:00 QUERY1 RUN5
./outer_loop_mri_127.sh 13:25:00 QUERY1 RUN5
./outer_loop_nyc_127.sh 13:30:00 QUERY2 RUN5
./outer_loop_mri_127.sh 13:35:00 QUERY2 RUN5

./outer_loop_nyc_127.sh 13:40:00 QUERY1 RUN6
./outer_loop_mri_127.sh 13:45:00 QUERY1 RUN6
./outer_loop_nyc_127.sh 13:50:00 QUERY2 RUN6
./outer_loop_mri_127.sh 13:55:00 QUERY2 RUN6

