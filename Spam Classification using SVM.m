%% Spam Classification using SVM
%% Initialization
clear ; close all; clc

%% ==================== Email Preprocessing ====================
%  To use an SVM to classify emails into Spam v.s. Non-Spam, we first need
%  to convert each email into a vector of features. Here I'll
%  implement the preprocessing steps for each email. I'll use processEmail.m 
%  to produce a word indices vector for a given email.

fprintf('\nPreprocessing sample email (emailSample1.txt)\n');

% Extract Features
file_contents = readFile('emailSample1.txt');
word_indices  = processEmail(file_contents);

% Print Stats
fprintf('Word Indices: \n');
fprintf(' %d', word_indices);
fprintf('\n\n');

fprintf('Program paused. Press enter to continue.\n');
pause;

%% ==================== Feature Extraction ====================
%  Now, I'll convert each email into a vector of features in R^n. 
%  See emailFeatures.m 

fprintf('\nExtracting features from sample email (emailSample1.txt)\n');

% Extract Features
file_contents = readFile('emailSample1.txt');
word_indices  = processEmail(file_contents);
features      = emailFeatures(word_indices);

% Print Stats
fprintf('Length of feature vector: %d\n', length(features));
fprintf('Number of non-zero entries: %d\n', sum(features > 0));

fprintf('Program paused. Press enter to continue.\n');
pause;

%% =========== Train Linear SVM for Spam Classification ========
%  Now lets train a linear classifier to determine if an
%  email is Spam or Not-Spam.

load('spamTrain.mat');

fprintf('\nTraining Linear SVM (Spam Classification)\n')
fprintf('(this may take a couple of minutes) ...\n')

C = 0.1;
model = svmTrainOld(X, y, C, @linearKernel);

p = svmPredictOld(model, X);

fprintf('Training Accuracy: %f\n', mean(double(p == y)) * 100);

%% =================== Test Spam Classification ================
%  Lets evaluate how our Spam Predictor is working, now I use the Test set
%  for that purpose

load('spamTest.mat');

fprintf('\nEvaluating the trained Linear SVM on a test set ...\n')

p = svmPredictOld(model, Xtest);

fprintf('Test Accuracy: %f\n', mean(double(p == ytest)) * 100);
pause;


%% ================= Top Predictors of Spam ====================
%  The following code finds the words with
%  the highest weights in the classifier. 
%

[weight, idx] = sort(model.w, 'descend'); % Sorting the weights and obtain the vocabulary list
vocabList = getVocabList();

fprintf('\nTop predictors of spam: \n');
for i = 1:15
    fprintf(' %-15s (%f) \n', vocabList{idx(i)}, weight(i));
end

fprintf('\n\n');
fprintf('\nProgram paused. Press enter to continue.\n');
pause;

%% =================== Try Your Own Emails =====================
%  Now anyone can use this! Just copy-paste any email of yours in spamSample1.txt 
%  as I've done below and use this Spam Classifier, hope it works well ;-)

filename = 'spamSample1.txt';
% I've taken the Spam example from http://web.mit.edu/network/spam/examples/it-training.txt

file_contents = readFile(filename);
word_indices  = processEmail(file_contents);
x             = emailFeatures(word_indices);
p = svmPredictOld(model, x);

fprintf('\nProcessed %s\n\nSpam Classification: %d\n', filename, p);
fprintf('(1 indicates spam, 0 indicates not spam)\n\n');

