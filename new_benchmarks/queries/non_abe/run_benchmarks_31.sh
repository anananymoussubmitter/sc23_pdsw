#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

./outer_loop_nyc_31.sh 13:20:00 QUERY1 RUN1
./outer_loop_mri_31.sh 13:25:00 QUERY1 RUN1
./outer_loop_nyc_31.sh 13:30:00 QUERY2 RUN1
./outer_loop_mri_31.sh 13:35:00 QUERY2 RUN1

./outer_loop_nyc_31.sh 13:40:00 QUERY1 RUN2
./outer_loop_mri_31.sh 13:45:00 QUERY1 RUN2
./outer_loop_nyc_31.sh 13:50:00 QUERY2 RUN2
./outer_loop_mri_31.sh 13:55:00 QUERY2 RUN2

./outer_loop_nyc_31.sh 14:00:00 QUERY1 RUN3
./outer_loop_mri_31.sh 14:05:00 QUERY1 RUN3
./outer_loop_nyc_31.sh 14:10:00 QUERY2 RUN3
./outer_loop_mri_31.sh 14:15:00 QUERY2 RUN3

./outer_loop_nyc_31.sh 14:20:00 QUERY1 RUN4
./outer_loop_mri_31.sh 14:25:00 QUERY1 RUN4
./outer_loop_nyc_31.sh 14:30:00 QUERY2 RUN4
./outer_loop_mri_31.sh 14:35:00 QUERY2 RUN4

./outer_loop_nyc_31.sh 14:40:00 QUERY1 RUN5
./outer_loop_mri_31.sh 14:45:00 QUERY1 RUN5
./outer_loop_nyc_31.sh 14:50:00 QUERY2 RUN5
./outer_loop_mri_31.sh 14:55:00 QUERY2 RUN5

./outer_loop_nyc_31.sh 15:00:00 QUERY1 RUN6
./outer_loop_mri_31.sh 15:05:00 QUERY1 RUN6
./outer_loop_nyc_31.sh 15:10:00 QUERY2 RUN6
./outer_loop_mri_31.sh 15:15:00 QUERY2 RUN6

