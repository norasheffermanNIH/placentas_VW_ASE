#!/bin/bash

find /data/Wilson_Lab/placenta/valleywise_raw_data/exome -type f -name "*.fastq.gz" | sort >> fastq_list.txt
