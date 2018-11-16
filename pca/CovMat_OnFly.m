function [first_term,second_term]=CovMat_OnFly(data, first_term, second_term)
%[first_term,second_term,result]=CovMat_OnFly(first_term,second_term)
%
%This function is used to compute covariance matrices on the fly with a
%stream of continouse data; the classic formula of cov(x,y) is 
%       
%           sum( (xi-E(x))(yi-E(y)) ) 
%
%which could be written also as the following:
%
%       sum( xi'*yi) - 1/n*sum(xi)'*sum(yi)
%
%here sum operator runs over the repetitions and X and Y are two different
%variables. In the second formula the terms can be computed online meaning
%that their value can be updated each time a new repetition is available.
%The FIRST_TERM and SECOND TERM in the input and output arguments
%corresponds to the first and second terms in the formula. RESULT is the
%current covariance matrix. FIRST_TERM must be matrix of the size of the
%resulting covariance matrix; SECOND_TERM must be a row vector of the size
%equal to the number of dimensions that is the length of row vector DATA.
%
%NTRIAL is the current value of the repetition.
%
%
%Selim, 31-Oct-2007 15:32:45

%
first_term        = first_term + data'*data;
second_term       = second_term + data;
%second_term_final = second_term'*second_term./nTrial;
%
%result            = (first_term - second_term_final)./nTrial;