sudo apt-get install build-essential gfortran libatlas-base-dev python-pip python-dev
sudo pip install --upgrade pip
sudo pip install numpy
sudo pip install scipy
sudo pip install -U gensim
sudo pip install -U nltk
sudo pip install stopwords
sudo pip install EMD-signal

sudo pip install http://download.pytorch.org/whl/cu80/torch-0.3.0.post4-cp27-cp27mu-linux_x86_64.whl 
sudo pip install torchvision
# if the above command does not work, then you have python 2.7 UCS2, use this command 
pip install http://download.pytorch.org/whl/cu80/torch-0.3.0.post4-cp27-cp27m-linux_x86_64.whl