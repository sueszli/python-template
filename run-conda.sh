# ------------------------------------------- install conda
brew install --cask miniconda
conda update conda

conda init zsh
conda init bash
exit # restart shell

conda config --env --set subdir osx-64 # emulate x86_64

# ------------------------------------------- start
conda create --yes --name myenv
conda activate myenv

conda install --yes --channel conda-forge python=3.9
# ...

# convenience
conda install --yes --channel conda-forge numpy pandas matplotlib seaborn

# ------------------------------------------- stop
conda deactivate
conda remove --yes --name myenv --all

# ------------------------------------------- verify cleanup
conda env list
