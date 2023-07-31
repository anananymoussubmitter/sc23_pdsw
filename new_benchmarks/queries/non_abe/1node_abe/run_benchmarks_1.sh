#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

./outer_loop_nyc_1.sh 17:00:00 QUERY1 RUN1
./outer_loop_mri_1.sh 17:05:00 QUERY1 RUN1
./outer_loop_nyc_1.sh 17:10:00 QUERY2 RUN1
./outer_loop_mri_1.sh 17:15:00 QUERY2 RUN1

./outer_loop_nyc_1.sh 17:20:00 QUERY1 RUN2
./outer_loop_mri_1.sh 17:25:00 QUERY1 RUN2
./outer_loop_nyc_1.sh 17:30:00 QUERY2 RUN2
./outer_loop_mri_1.sh 17:35:00 QUERY2 RUN2

./outer_loop_nyc_1.sh 17:40:00 QUERY1 RUN3
./outer_loop_mri_1.sh 17:45:00 QUERY1 RUN3
./outer_loop_nyc_1.sh 17:50:00 QUERY2 RUN3
./outer_loop_mri_1.sh 17:55:00 QUERY2 RUN3

./outer_loop_nyc_1.sh 18:00:00 QUERY1 RUN4
./outer_loop_mri_1.sh 18:05:00 QUERY1 RUN4
./outer_loop_nyc_1.sh 18:10:00 QUERY2 RUN4
./outer_loop_mri_1.sh 18:15:00 QUERY2 RUN4

./outer_loop_nyc_1.sh 18:20:00 QUERY1 RUN5
./outer_loop_mri_1.sh 18:25:00 QUERY1 RUN5
./outer_loop_nyc_1.sh 18:30:00 QUERY2 RUN5
./outer_loop_mri_1.sh 18:35:00 QUERY2 RUN5

./outer_loop_nyc_1.sh 18:40:00 QUERY1 RUN6
./outer_loop_mri_1.sh 18:45:00 QUERY1 RUN6
./outer_loop_nyc_1.sh 18:50:00 QUERY2 RUN6
./outer_loop_mri_1.sh 18:55:00 QUERY2 RUN6

