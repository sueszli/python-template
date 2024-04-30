if ! command -v python3 &> /dev/null; then echo "python3 missing"; exit 1; fi
if ! command -v pip &> /dev/null; then echo "pip missing"; exit 1; fi

python3 -m pip install --upgrade pip > /dev/null

pip install black > /dev/null
pip install pipreqs > /dev/null

rm -rf requirements.txt > /dev/null
pipreqs . > /dev/null
pip install -r requirements.txt > /dev/null
