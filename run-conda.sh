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

conda create --yes --name main python=3.X.X anaconda
conda activate main

pip install -r requirements.txt

# maybe also capture the environment
conda env export > environment.yml

# ----------------------------------------------------------------------------- stop
conda deactivate
conda remove --yes --name main --all
conda env list
