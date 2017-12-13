Abstract Text Analysis Process:

1. Set up the Python environment by installing python 2.7, pip and all python libraries outlined in the dependencies.txt file inside /src/data_analysis/pythonCode. Do make this easier, you should run the pythonLib_setUp.sh shell script found in /src/data_analysis/pythonCode.

2.	DocSim: Navigate to /src/data_analysis/pythonCode/ and run the command:
DocSim.py -i "../../../data/conference.csv" -c 2

3.	Doc2Vec_pretrained 1: Navigate to /src/data_analysis/pythonCode/ and run the command:
Doc2Vec_pretrained.py -i "../../../data/conference.csv" -c 2 –m "../languageModels/apnews_doc2vec.bin"

4.	Doc2Vec_pretrained 2: Navigate to /src/data_analysis/pythonCode/ and run the command:
Doc2Vec_pretrained.py -i "../../../data/conference.csv" -c 2 –m "../languageModels/enwiki_doc2vec.bin"

5.	Doc2Vec_selfTrained: Navigate to /src/data_analysis/pythonCode/ and run the command:
Doc2Vec_selfTrained.py -i "../../../data/conference.csv" -c 2

6.	WMD: Navigate to /src/data_analysis/pythonCode/ and run the command:
WMD.py -i "../../../data/conference.csv" -c 2 –m "../languageModels/WMD_model_withGoogleNews_W2V.bin"

7.	InferSent (Only running on Linux or OSX, because of library limitations (i.e.: pytorch)):
Run main.py inside the InferSent folder from a Linux or OSX operating system, after pytorch was configured. Adjust file path inside main.py, if needed.
Abstract Clustering Process:

8.	Set R working directory to the root directory of this project’s directory, i.e. SSC Consulting, so for example run the R command “setwd("C:/Users/Norbert/Desktop/SSC consulting")”.

9.	Rerun whichever model’s clustering analysis. Careful with the script, some of it is just exploring the data, to decide on the proper number of clusters within the data.

10.	In order to perform cross validation or stability checking, go to tests/data_analysis/clustering_R and run Clustering Analysis Validation using CV.R or Clustering Analysis Validation using clValid package.R
