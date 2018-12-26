#!/usr/bin/env bash

# Download files into preds
# TEST_PATH=preds/tfidf_weighting/baseline/3e+1
# TEST_PATH=preds/tfidf_weighting/bert/3e+1
# TEST_PATH=preds/tfidf_weighting/bert_large/3e+4
# TEST_PATH=preds/top_n_docs/baseline/30
# TEST_PATH=preds/top_n_docs/bert/30
TEST_PATH=preds/top_n_docs/bert_large/30

mkdir -p $TEST_PATH
rm -rf $TEST_PATH/*
cd $TEST_PATH

# SESS=(1206 1207 1272 1209 1210) 
# for i in ${SESS[@]}
for i in $(seq 1266 1270)
do
  nsml download -s /app/preds/agg_pred.json piqateam/squad_piqa_nfs/$i ./
done
cd ../../../../

# Official aggregate and evaluate
python aggregate_pred.py $TEST_PATH
python evaluate.py ~/data/squad/dev-v1.1.json $TEST_PATH/agg_pred.json

: "
# Partial aggregate and evaluate
python aggregate_pred.py $TEST_PATH --with_score
python partial_evaluate.py ~/data/squad/dev-v1.1.json $TEST_PATH/agg_pred.json
"
