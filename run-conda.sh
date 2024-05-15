# ----------------------------------------------------------------------------- install conda
brew install --cask miniconda
conda update conda

conda init zsh
conda init bash
exit # restart shell

conda config --set auto_activate_base false # disable auto-activation
conda config --env --set subdir osx-64 # emulate x86_64

# ----------------------------------------------------------------------------- start
conda activate base

conda create --yes --name noodle-retrieval python=3.X.X anaconda
conda activate noodle-retrieval

pip install -r requirements.txt

# ----------------------------------------------------------------------------- stop
conda deactivate
conda remove --yes --name noodle-retrieval --all
conda env list
