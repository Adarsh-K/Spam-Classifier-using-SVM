function x = emailFeatures(word_indices)
%   x = EMAILFEATURES(word_indices) takes in a word_indices vector and 
%   produces a feature vector from the word indices. 

n = 1899; % Total number of words in the dictionary

x = zeros(n, 1);

for i=1:length(word_indices)
    x(word_indices(i))=1;
end

end
