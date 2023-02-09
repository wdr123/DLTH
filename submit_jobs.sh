#!/bin/bash
base_job_name="DLTH"
job_file="the_job.sh"
identifier_name="pretrain"
dir="op_"$identifier_name
mkdir -p $dir


data_repo="cifar10 cifar100"
arch_repo="resnet50 resnet101"
prune_rate=(0)
#prune_rate=(0.06 0.09 0.12 0.15)
#method="L1 LTH RST"

for prune in "${prune_rate[@]}";
do
    for dataset in $data_repo;
      do
      for arch in $arch_repo;
        do
          export prune arch dataset
          job_name=$base_job_name-$arch-$dataset-"${prune}"
          out_file=$dir/$job_name.out
          error_file=$dir/$job_name.err

          echo "prune_rate=${prune}" $arch $dataset
          sbatch -J $job_name -o $out_file -e $error_file $job_file
#           bash $job_file
        done
    done
done


