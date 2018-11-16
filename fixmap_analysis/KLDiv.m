function [D]=KLDiv(P);
%[D]=KLDiv(p);
%   Measures the Kullback-Leibler divergence, D, between two probability
%   distributions. P contains the probability distributions on its columns.
%   D is a matrix, each entry corresponds to KLDiv between corresponding pdfs.
%   For more theoretical information, see Theoretical Neuroscience
%   (Dayan-Abbott) page 128. 
%
%   D is a non-symmetric (hence divergence not distance) square matrix with
%   number of entries equal to the number of columns in P. D(y,x) is the KL
%   divergence value of probability distribution at Xth column from
%   probability distribution of column Yth.
%
%   
P = P + 10^-20;
Psize = size(P,2);
for x = 1:Psize
    for y = 1:Psize
        D(y,x) = sum( P(:,x).*log2(P(:,x)./P(:,y)) );
    end
end
