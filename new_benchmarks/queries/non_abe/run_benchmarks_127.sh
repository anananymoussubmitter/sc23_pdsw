#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

./outer_loop_nyc_127.sh 09:00:00 QUERY1 RUN1
./outer_loop_mri_127.sh 09:05:00 QUERY1 RUN1
./outer_loop_nyc_127.sh 09:10:00 QUERY2 RUN1
./outer_loop_mri_127.sh 09:15:00 QUERY2 RUN1

./outer_loop_nyc_127.sh 09:20:00 QUERY1 RUN2
./outer_loop_mri_127.sh 09:25:00 QUERY1 RUN2
./outer_loop_nyc_127.sh 09:30:00 QUERY2 RUN2
./outer_loop_mri_127.sh 09:35:00 QUERY2 RUN2

./outer_loop_nyc_127.sh 09:40:00 QUERY1 RUN3
./outer_loop_mri_127.sh 09:45:00 QUERY1 RUN3
./outer_loop_nyc_127.sh 09:50:00 QUERY2 RUN3
./outer_loop_mri_127.sh 09:55:00 QUERY2 RUN3

./outer_loop_nyc_127.sh 10:00:00 QUERY1 RUN4
./outer_loop_mri_127.sh 10:05:00 QUERY1 RUN4
./outer_loop_nyc_127.sh 10:10:00 QUERY2 RUN4
./outer_loop_mri_127.sh 10:15:00 QUERY2 RUN4

./outer_loop_nyc_127.sh 10:20:00 QUERY1 RUN5
./outer_loop_mri_127.sh 10:25:00 QUERY1 RUN5
./outer_loop_nyc_127.sh 10:30:00 QUERY2 RUN5
./outer_loop_mri_127.sh 10:35:00 QUERY2 RUN5

./outer_loop_nyc_127.sh 10:40:00 QUERY1 RUN6
./outer_loop_mri_127.sh 10:45:00 QUERY1 RUN6
./outer_loop_nyc_127.sh 10:50:00 QUERY2 RUN6
./outer_loop_mri_127.sh 10:55:00 QUERY2 RUN6

