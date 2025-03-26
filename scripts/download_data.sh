#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

data=$base/data

mkdir -p $data

tools=$base/tools

# link default training data for easier access

mkdir -p $data/wikitext-2

for corpus in train valid test; do
    absolute_path=$(realpath $tools/pytorch-examples/word_language_model/data/wikitext-2/$corpus.txt)
    ln -snf $absolute_path $data/wikitext-2/$corpus.txt
done

# download a different interesting data set!

mkdir -p $data/classics

mkdir -p $data/classics/raw

wget https://www.gutenberg.org/cache/epub/135/pg135.txt
wget https://www.gutenberg.org/cache/epub/345/pg345.txt
wget https://www.gutenberg.org/cache/epub/84/pg84.txt
wget https://www.gutenberg.org/cache/epub/42671/pg42671.txt
wget https://www.gutenberg.org/cache/epub/4078/pg4078.txt
wget https://www.gutenberg.org/cache/epub/42/pg42.txt
wget https://www.gutenberg.org/cache/epub/158/pg158.txt
wget https://www.gutenberg.org/cache/epub/1184/pg1184.txt

cat pg135.txt pg345.txt pg84.txt pg42671.txt pg4078.txt pg42.txt pg158.txt pg1184.txt > classics.txt

# delete the files that are no longer needed
rm pg135.txt
rm pg345.txt
rm pg84.txt
rm pg42671.txt
rm pg4078.txt
rm pg42.txt
rm pg158.txt
rm pg1184.txt

# split file
mv classics.txt $data/classics/raw/classics.txt

# preprocess slightly
cat $data/classics/raw/classics.txt | python $base/scripts/preprocess_raw.py > $data/classics/raw/classics.cleaned.txt

# Remove the word Chapter and the following numbering
cat $data/classics/raw/classics.cleaned.txt | python $base/scripts/remove_word.py > $data/classics/raw/classics.cleaned.nochapters.txt
mv $data/classics/raw/classics.cleaned.nochapters.txt $data/classics/raw/classics.cleaned.txt

# tokenize, fix vocabulary upper bound
cat $data/classics/raw/classics.cleaned.txt | python $base/scripts/preprocess.py --vocab-size 5000 --tokenize --lang "en" --sent-tokenize > \
    $data/classics/raw/classics.preprocessed.txt



# split into train, valid and test

# Count total lines
total_lines=$(wc -l < $data/classics/raw/classics.preprocessed.txt)

# Split logic (80/10/10 split)
train_count=$((total_lines * 80 / 100))
valid_count=$((total_lines * 10 / 100))
test_count=$((total_lines - train_count - valid_count))

# Generate splits
head -n $train_count $data/classics/raw/classics.preprocessed.txt > $data/classics/train.txt
tail -n +$((train_count + 1)) $data/classics/raw/classics.preprocessed.txt | head -n $valid_count > $data/classics/valid.txt
tail -n $test_count $data/classics/raw/classics.preprocessed.txt > $data/classics/test.txt

