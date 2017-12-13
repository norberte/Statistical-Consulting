# Abstract Text Analysis Process:
1.	DocSim: Navigate to data_analysis/pythonCode/ and run the command:
`python DocSim.py -i "../../data/conference.csv" -c 2`
2.	Doc2Vec_pretrained 1: Navigate to data_analysis/pythonCode/ and run the command:
`python Doc2Vec_pretrained.py -i "../../data/conference.csv" -c 2 –m "../languageModels/apnews_doc2vec.bin"`
3.	Doc2Vec_pretrained 2: Navigate to data_analysis/pythonCode/ and run the command:
`python Doc2Vec_pretrained.py -i "../../data/conference.csv" -c 2 –m "../languageModels/enwiki_doc2vec.bin"`
4.	Doc2Vec_selfTrained: Navigate to data_analysis/pythonCode/ and run the command:
`python Doc2Vec_selfTrained.py -i "../../data/conference.csv" -c 2`
5.	WMD: Navigate to data_analysis/pythonCode/ and run the command:
`python WMD.py -i "../../data/conference.csv" -c 2 –m "../languageModels/WMD_model_withGoogleNews_W2V.bin"`
6.	InferSent (Only running on Linux or OSX, because of library limitations (i.e.: pytorch)):
  a.	Go inside data_analysis/pythonCode/InferSent/encoder and unzip the glove.840B.300d.zip file.
  b.	Run main.py inside the InferSent folder from a Linux or OSX operating system, after pytorch was configured. Adjust file path inside main.py, if needed.

Unit tests for this component can be ran by navigating to data_analysis/pythonCode/ and run the command : `python UnitTests.py`

Abstract Clustering Process:

8.	Set R working directory to the root directory of this project’s directory, i.e. SSC Consulting, so for example run the R command “setwd("C:/Users/Norbert/Desktop/SSC consulting")”.

9.	Rerun whichever model’s clustering analysis. Careful with the script, some of it is just exploring the data, to decide on the proper number of clusters within the data.

10.	In order to perform cross validation or stability checking, go to tests/data_analysis/clustering_R and run Clustering Analysis Validation using CV.R or Clustering Analysis Validation using clValid package.R

Note that the InferSent directory inside /src/data_analysis/pythonCode/ was cloned from https://github.com/facebookresearch/InferSent, then added main.py to run my own analysis using the InferSent model. I did not write the InferSent code, and I do not own any intelectual property from it. It was only used for educational purposes (i.e. Statistical Consulting course at UBCO)
