# MT Exercise 2: Pytorch RNN Language Models

This repo shows how to train neural language models using [Pytorch example code](https://github.com/pytorch/examples/tree/master/word_language_model). Thanks to Emma van den Bold, the original author of these scripts.

# Requirements

- This only works on a Unix-like system, with bash.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure virtualenv is installed on your system. To install, e.g.

  `pip install virtualenv`

# Steps

Clone this repository in the desired place:

    git clone https://github.com/marpng/mt-exercise-02
    cd mt-exercise-02

Create a new virtualenv that uses Python 3. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software:

    ./scripts/install_packages.sh

Download and preprocess data:

    ./scripts/download_data.sh

Train a model:

    ./scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Generate (sample) some text from a trained model with:

    ./scripts/generate.sh

---

# Changes done by us and instructions on how to proceed

## Preprocessing of the data

- To get more logical outputs and since the training of one book only took 30s to 1 minute, we decided to concatenate multiple classical books and use those as the dataset.
- After preprocessing, training and generating a sample, we realized that the special token '<unk>' was being used too much and thus we created the script `mt-exercise-02/scripts/remove_word.py` that removes the word 'CHAPTER' and the roman numerals after it to ensure that a less frequent but more informative word considered in the vocabulary for training. This file is included in the `download_data.sh` and thereby doesn't need to be run separately.
- To also consider more data from the dataset, we scaled the the train, validation and test set according to the size of the input data set (see `download_data.sh`).
- Otherwise, we left the paths as is and one should be able to just run: `./scripts/download_data.sh`

## Training the data

- For training we added the --mps flag to enable GPU use in a mac.
- We created a models_dropout folder to ensure that the logs of the models with different dropouts get stored in their own repository
- We changed the paths to use the modified main function that logs the perplexities of training, validation and testing: `main_logging.py` and we also changed it to generally use our preprocessed datasets.
- The dropout needs to be changed and then the file needs to be run. Change the dropout value in train.sh each time and don't forget to change the model and dropout file path to include the correct numbering:
  Dropout values: `0, 0.3, 0.6, 0.7, 0.8`

  Model paths: `--save $models/model_0.0.pt, --save $models/model_0.3.pt, --save $models/model_0.6.pt, --save $models/model_0.7.pt, --save $models/model_0.8.pt`

  Dropout paths: `--log-ppl $models_dropout/dropout_0.0.tsv, --log-ppl $models_dropout/dropout_0.3.tsv, --log-ppl $models_dropout/dropout_0.6.tsv, --log-ppl $models_dropout/dropout_0.7.tsv, --log-ppl $models_dropout/dropout_0.8.tsv`

## Create combined table

- We created the script `connect_logs.py` that creates a combined tsv with all the different models with their perplexities.
- To enable that it works equally from every device, please use as your second argument the full path to the models_dropout folder
- After training the different models, please run: `python tools/pytorch-examples/word_language_model/connect_logs.py 'FULL PATH TO MODELS_DROPOUT FOLDER'`

## Generating text

- Here we only changed the the paths and models used according to the task.
- All the generated samples are under the folder `samples/`
- `samples/sample` is the first generated text that still has the word 'CHAPTER' in the training data
- `samples/sample_replaced` stems from the model that was trained on the data, where we replaced 'CHAPTER'.
- The other two files are from task 2 and stem from the models trained with 0 dropout and 0.8 dropout.
- To run this part, change the parameters/paths accordingly and run: `./scripts/generate.sh`

## Plotting the models and their perplexity

- We created the file `create_plots.py` that creates a plot of the different training perplexities and one for the different validation perplexities
- Also here we wanted to enable usability by adding arguments. Please use the full path to the combined dropout/perplexity tsv as your second argument.
- To plot the perplexities per dropout run `python mt-exercise-02/tools/pytorch-examples/word_language_model/create_plots.py 'PATH'`
- The already created plots are under the folder `plots`
