#! /bin/bash

scripts=$(dirname "$0")
base=$(realpath $scripts/..)

models=$base/models
data=$base/data
tools=$base/tools
models_dropout=$base/models_dropout

mkdir -p $models

num_threads=4
device=""

SECONDS=0

(cd $tools/pytorch-examples/word_language_model &&
    CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python main_logging.py --data $data/classics \
        --epochs 40 \
        --log-interval 100 \
        --emsize 200 --nhid 200 --dropout 0.3 --tied \
        --mps \
        --save $models/model_0.3.pt \
        --log-ppl $models_dropout/dropout_0.3.tsv
)

echo "time taken:"
echo "$SECONDS seconds"
