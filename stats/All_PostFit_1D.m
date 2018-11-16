function All_PostFit_1D(FileList);;
%All_PostFit_1D(FileList);
%
%
%Makes a variety of analysis to 1D posterior probability curves. Refer to
%All_PostFit_2D for two dimensional cases. In this function 1st, 2nd and
%3rd order polynomials are fit to one dimensional posterior distributions
%and the entropies of probability functions are computed. The results are
%saved in a $/PostFit with the same file names as the files in $/PostDist/
%
%Organization of the result variable RES:
%
%When you load a file which is located in $/PostFit, RES variable appears
%on the workspace. This variable contains the posterior probabilities
%which were computed by GetDist. But in addition to this, the fits and entropy measurements
%computed by All_PostFit_1D. The fields RES.FIT and RES.ENTROPY contain the
%fit parameters and entropy values respectively. RES.FIT(N) would contain
%the results computed by using Nth order polynomial. In RES.FIT(N), field
%names are the same as the fields in RES.A which stores the actual
%posterior probabilities. Within each of these fields, for each of the
%probability distributions there are a number of parameters that are
%extracted. For example:
% res.fit(1).Raw
% ans =
%        beta: [2x64 double]
%     beta_ci: [2x64 double]
%         mse: [1x64 single]
%       indep: [20x2 double]
%      fitted: [20x64 double]
%           p: [1x64 single]
%           F: [1x64 single]
%           r: [1x64 single]
%
%For example RES.FIT(1).RAW contains for each of the 64 probability
%distributions the fitted parameters of the first order model (intercept
%and slope). This generelizes to other fields as well as other orders of
%the fitted model.
%
%Selim, 10-Sep-2007 20:44:41


p         = GetParameters;
%FileList  = ListFiles([ReadBase '1Dimen*.mat']);
tf        = length(FileList);
%
%
bat{1} = @(x) ones(size(x));;
bat{2} = @(x) x;
bat{3} = @(x) x.*x;
bat{4} = @(x) x.*x.*x;
%
bc        = [];
indep     = [];
S         = [];
indep_foo = [];
res       = [];
model     = [];
%
for nf = 1:tf;%RUN OVER ALL FILES/


    WritePath = [ FileList{nf}];
    %detact the path to PDs, becoz we want to load them to take the data to
    %be fitted!
    i = regexp(FileList{1},'Fit');
    PDlocation = [FileList{1}(1:i-1) 'Dist' FileList{1}(i+3:end)];

    display(['file ' mat2str(nf) ' of ' mat2str(tf)]);
    %
    %IF THE RESULTS ARE NOT COMPUTED FOR THIS FILE
    %LOAD THE EMPIRICAL DATA
    load( [ PDlocation ]);
    %
    [bc]=GetBinCenters(res);
    %
    %run over actual and control ones.
    for nf = {'A' 'C'}
        field = fieldnames(res.(nf{1}));%
        %here we run over all the fields where there is data stored and we
        %will fit curves to each of them.
        for nf2 = 1:length(field);
            %IN THIS PART WE MAKE THE FITTING TO POSTERIOR PROBABILITIES.
            %we fit data with different orders of independent variables.

            for order = 1:3%
                %
                UpdateIndep;
                %
                Column2Fit
                %
                UpdateRes;
            end
            GetEntropy;
            %
        end
    end
    GetKLDivergenz;
    %we compute the Kullback-Leibler divergenz between the Actual and
    %Control distributions. This is a metric to be computed exclusively
    %between C and A so it does not make sense to put it within the for
    %loop.
    save(WritePath,'res');
end


    function [bc]=GetBinCenters(res);
        be    = linspace(0,100,res.nBin+1)';%these are the binedges. We have 21 bin edges.
        %we will use these as independent variables but before we need to
        %transform them to bincenters.
        bc{1} = be(1:end-1) + mean(diff(be))/2;
        bc{1} = bc{1}(:);
    end
%
%
    function Column2Fit
        %Find the best fitting parameters for each of the columns in the results.
        %lscov does not need a for loop.
        clear beta beta_ci p F r S;
        [dummy3,dummy4,dummy5] = lscov( indep , res.(nf{1}).(field{nf2}));
        S.mse = dummy5;
        for nvec = 1:size(res.(nf{1}).(field{nf2}),2);
            
            if ~isnan(sum(res.A.(field{nf2})(:,nvec)))
                [b,bi,dummy,dummy2,stats] = regress( res.A.(field{nf2})(:,nvec) , indep );
                S.r(nvec)         = stats(1);
                S.F(nvec)         = stats(2);
                S.p(nvec)         = stats(3);
                S.beta(:,nvec)    = b;
                S.beta_ci(:,nvec) = abs(bi(:,1)-b);
            else
                S.r(nvec)         = NaN;
                S.F(nvec)         = NaN;
                S.p(nvec)         = NaN;
                S.beta(:,nvec)    = repmat(NaN,size(indep,2),1);
                S.beta_ci(:,nvec) = repmat(NaN,size(indep,2),1);
            end
        end
    end
%
    function UpdateRes
        res.fit(order).(nf{1}).(field{nf2}).beta    = S.beta;
        res.fit(order).(nf{1}).(field{nf2}).beta_ci = S.beta_ci;%ones sided interval
        res.fit(order).(nf{1}).(field{nf2}).mse     = S.mse;
        res.fit(order).(nf{1}).(field{nf2}).indep   = indep;
        res.fit(order).(nf{1}).(field{nf2}).model   = model;
        res.fit(order).(nf{1}).(field{nf2}).fitted  = indep*res.fit(order).(nf{1}).(field{nf2}).beta;
        res.fit(order).(nf{1}).(field{nf2}).p       = S.p;
        res.fit(order).(nf{1}).(field{nf2}).F       = S.F;
        res.fit(order).(nf{1}).(field{nf2}).r       = S.r;
    end
%
    function GetKLDivergenz;
        dummy = KLDiv([res.C.MeanPDF,res.A.MeanPDF]);
        res.entropy.KL.C2A = dummy(2,1);
        res.entropy.KL.A2C = dummy(1,2);
        %for individuel images:
        for i = 1:size(res.C.Raw,2)
            %
            dummy = KLDiv([res.C.Raw(:,i) , res.A.Raw(:,i) ]);
            res.entropy.KL.rawC2A(i) = dummy(2,1);
            res.entropy.KL.rawA2C(i) = dummy(1,2);
            %
        end
        
    end

%
    function GetEntropy
        %HERE COMPUTE THE ENTROPIES
        %in order to get rid off 0 values we add a small constant to
        %those entries.
        res.(nf{1}).(field{nf2})(res.(nf{1}).(field{nf2}) == 0) = 10^-20;
        res.entropy.(nf{1}).(field{nf2}) = -diag(res.(nf{1}).(field{nf2})'*log2(res.(nf{1}).(field{nf2})));
        res.entropy.(nf{1}).MaxEntropy = log2(res.nBin);
        %
    end
%
    function UpdateIndep

        intercept = repmat(bat{1}(1),res.nBin.^res.nDimen,1);%

        if order == 1
            %this is first order model a + b*x + c*y
            indep = [intercept  bat{2}(bc{1}) ];
            model = {bat{1} bat{2}};
        elseif order == 2
            %this model is same as the first with the addition of
            %multiplicatif component. That is a + b*x + c*y + d*x*y
            indep = [intercept  bat{2}(bc{1}) bat{3}(bc{1})];
            model = {bat{1} bat{2} bat{3}};
        elseif order == 3
            %this is the full second order model:
            %That is a + b*x + c*y + d*x*y + e*x.*x + f*y*y.
            indep = [intercept  bat{2}(bc{1}) bat{3}(bc{1}) bat{4}(bc{1})];
            model = {bat{1} bat{2} bat{3} bat{4}};
        end

        %here we put all the independent variable to the same order of
        %magnitude.
        foo = indep./repmat(geomean(indep),size(indep,1),1);
        indep = foo;
    end

end