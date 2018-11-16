function [feat,mat]=CombineFeatures3D(feat)

%[feat,mat]=CombineFeatures3D(feat)
%
% This function creates a cube equivalent to the result of Feat2PDMatrix in
% the 2D space. For each triplet of features we create an entry which
% contains the names of the features. These features will be used to
% compute posterior probabilities. The output of this function (preferably
% FEAT) can be used with CondProb. 
%
%
% Selim, 10-Feb-2009 11:13:28




%%%% indices for triplet generation
% % % 
% % % [ repmat([repmat(1,9,1);repmat(2,9,1);repmat(3,9,1)],3,1) repmat([ repmat([1],3,1) ;repmat([2],3,1) ;repmat([3],3,1) ],9,1) repmat([1:3]',27,1)]
% % % ans =
% % % 
% % %      1     1     1
% % %      1     1     2
% % %      1     1     3
% % %      1     2     1
% % %      1     2     2
% % %      1     2     3
% % %      1     3     1
% % %      1     3     2
% % %      1     3     3
% % %      2     1     1
% % %      2     1     2
% % %      2     1     3
% % %      2     2     1
% % %      2     2     2
% % %      2     2     3
% % %      2     3     1
% % %      2     3     2
% % %      2     3     3
% % %      3     1     1
% % %     ...
% % %     ...
% % %     ...
%below is the generalization of the above code which is specific to 3
%features to N feature.
    %
    N = length(feat);
    first = [];
    for i = 1:N
        first = [first ;repmat(i,N^2,1)];
    end
    %
    middle = [];
    for i = 1:N    
        middle= [middle ; repmat([i],N,1)]; 
    end
    middle = repmat(middle,N,1);
    %
    last = repmat([1:N]',N^2,1);
    %
    index = [first middle last];
    
% % % %     %ALL THE CODE ABOVE IS EQUIVALENT TO THIS ONE:TOBE REPLACED SOMETIME
% % % %     [x y z] = ind2sub([15 15 15],1:15^3);
% % % %     index = [z;y;x]';
    %
    %use the indices to form the triplets
    for i = 1:size(index,1);
        final{i}=feat(index(i,:))';
    end;
    final = final';
    %put all to a cube
    mat  = reshape(final,[N N N]);
    %output also only the non-redundant part. The below operation is
    %equivalent to have a the below diagonal entries in 2D.
    i    = (index(:,2) >= index(:,3)) & (index(:,1) >= index(:,2));
    %alternatively one can remove the equalities. In this case, the
    %triplets which have the same entries are included in the analysis.
    %This is redundant, however it is a good sanity check. therefore I keep
    %them eventhough they increase the total computation time. Sanity check
    %in the sense that the conditional probability of luminance contrast
    %vs luminance contrast vs luminance contrast must be a diagonal passing
    %a cube and the values must be exactly the same as in 1D Luminance
    %contrast case.
    feat = {final{i}};
    
    
    