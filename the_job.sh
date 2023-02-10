#!/bin/bash -lT


#SBATCH --mail-user=986739772@qq.com
#SBATCH --mail-type=ALL
#SBATCH -A vision -p tier3 -n 4
#SBATCH -c 1
#SBATCH --mem=4g
#SBATCH --gres=gpu:v100:1
#SBATCH -t 0-12:00:00

conda activate LTH


if [ "$method" = "L1_Iter" ]; then
CUDA_VISIBLE_DEVICES=0 python main.py --method L1_Iter --dataset $dataset --arch $arch --wd 0.0005 --batch_size 512 --base_model_path "Experiments/pretrain_$arch-$dataset/weights/checkpoint_best.pth" --stage_pr [0,$prune,$prune,$prune,0] --lr_ft 0:0.1,100:0.01,150:0.001 --epochs 200 --num_cycles 5 --project "L1_Iter5_$arch-$dataset-pr${prune}" --wg weight --lr_ft_mini 0:0.1,10:0.01,15:0.001 --epochs_mini 20
elif [ "$method" = "RST_Iter" ]; then
CUDA_VISIBLE_DEVICES=0 python main.py --method RST_Iter --dataset $dataset --arch $arch --wd 0.0005 --batch_size 512 --base_model_path "Experiments/pretrain_$arch-$dataset/weights/checkpoint_best.pth" --stage_pr [0,$prune,$prune,$prune,0] --lr_ft 0:0.1,100:0.01,150:0.001 --epochs 200 --num_cycles 5 --project "RST_Iter5_$arch-$dataset-pr${prune}" --wg weight --stabilize_reg_interval 10000 --update_reg_interval 1 --pick_pruned iter_rand --RST_Iter_ft 0
elif [ "$method" = "LTH" ]; then
  CUDA_VISIBLE_DEVICES=0 python main.py --method L1_Iter --LTH_Iter --dataset $dataset --arch $arch --wd 0.0005 --batch_size 512 --base_model_path "Experiments/pretrain_$arch-$dataset/weights/checkpoint_best.pth" --stage_pr [0,$prune,$prune,$prune,0] --lr_ft 0:0.1,100:0.01,150:0.001 --epochs 200 --num_cycles 5 --project "LTH_Iter5_$arch-$dataset-pr${prune}" --wg weight --lr_ft_mini 0:0.1,10:0.01,15:0.001 --epochs_mini 20
fi

#CUDA_VISIBLE_DEVICES=0 python main.py --arch $arch --dataset $dataset --method L1 --stage_pr [0,0,0,0,0] --batch_size 512 --wd 0.0005 --lr_ft 0:0.1,100:0.01,150:0.001 --epochs 200 --project "pretrain_$arch-$dataset" --save_init_model