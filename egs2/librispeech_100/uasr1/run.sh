#!/usr/bin/env bash

# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

# Set this to one of ["phn", "char"] depending on your requirement
trans_type=phn
if [ "${trans_type}" = phn ]; then
    # If the transcription is "phn" type, the token splitting should be done in word level
    # token_type=word
    token_type=phn
else
    token_type="${trans_type}"
fi

train_set="train_clean_100"
valid_set="dev"
test_sets="test_clean test_other dev_clean dev_other"


model=$1
version=$2

exp_dir=exp2
uasr_exp=${exp_dir}/uasr_${model}_v${version}
uasr_stats_dir=${exp_dir}/uasr_stats_${model}
dump_dir=dump/${model}

uasr_config=conf/train_${model}.yaml
lm_config=conf/tuning/train_lm_transformer2.yaml
inference_config=conf/decode_uasr.yaml

echo "===== Model: $model , Version: $version ====="

# 2nd run starts from 13
# 3nd run starts from 15

# 13: collect stats
# 14: Feature Preprocess
# 15: UASR Training
# 16: Extracting feature (test set)
# 17: Decoding
# 18: Scoring

mkdir -p ${uasr_stats_dir}/train
mkdir -p ${uasr_stats_dir}/valid

echo "768" > ${uasr_stats_dir}/train/feats_dim
echo "768" > ${uasr_stats_dir}/valid/feats_dim

./uasr.sh \
    --stage 13 \
    --lang en \
    --token_type "${token_type}" \
    --ngpu 1 \
    --nj 4 \
    --silence_trim true \
    --use_lm false \
    --use_feature_clustering false \
    --write_collected_feats true \
    --audio_format "flac.ark" \
    --max_wav_duration 30 \
    --use_ngram true \
    --dumpdir "${dump_dir}" \
    --expdir "${exp_dir}" \
    --uasr_exp "${uasr_exp}" \
    --uasr_stats_dir "${uasr_stats_dir}" \
    --uasr_config "${uasr_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${valid_set}" \
    --test_sets "${test_sets}" \
    --uasr_args "--use_wandb true --wandb_project upr --wandb_name ${model}_v${version}"
    # --inference_uasr_model "valid.weighted_lm_ppl.ave_10best.pth"
    # --nlsyms_txt "<SIL>"
    # "$@"
    # --lm_config "${lm_config}" \
    # --feature_pca_dim 384 \

echo "===== Model: $model ====="
