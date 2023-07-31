#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

./outer_loop_nyc_31.sh 16:00:00 QUERY1 RUN1
./outer_loop_mri_31.sh 16:05:00 QUERY1 RUN1
./outer_loop_nyc_31.sh 16:10:00 QUERY2 RUN1
./outer_loop_mri_31.sh 16:15:00 QUERY2 RUN1

./outer_loop_nyc_31.sh 16:20:00 QUERY1 RUN2
./outer_loop_mri_31.sh 16:25:00 QUERY1 RUN2
./outer_loop_nyc_31.sh 16:30:00 QUERY2 RUN2
./outer_loop_mri_31.sh 16:35:00 QUERY2 RUN2

./outer_loop_nyc_31.sh 16:40:00 QUERY1 RUN3
./outer_loop_mri_31.sh 16:45:00 QUERY1 RUN3
./outer_loop_nyc_31.sh 16:50:00 QUERY2 RUN3
./outer_loop_mri_31.sh 16:55:00 QUERY2 RUN3

./outer_loop_nyc_31.sh 17:00:00 QUERY1 RUN4
./outer_loop_mri_31.sh 17:05:00 QUERY1 RUN4
./outer_loop_nyc_31.sh 17:10:00 QUERY2 RUN4
./outer_loop_mri_31.sh 17:15:00 QUERY2 RUN4

./outer_loop_nyc_31.sh 17:20:00 QUERY1 RUN5
./outer_loop_mri_31.sh 17:25:00 QUERY1 RUN5
./outer_loop_nyc_31.sh 17:30:00 QUERY2 RUN5
./outer_loop_mri_31.sh 17:35:00 QUERY2 RUN5

./outer_loop_nyc_31.sh 17:40:00 QUERY1 RUN6
./outer_loop_mri_31.sh 17:45:00 QUERY1 RUN6
./outer_loop_nyc_31.sh 17:50:00 QUERY2 RUN6
./outer_loop_mri_31.sh 17:55:00 QUERY2 RUN6

