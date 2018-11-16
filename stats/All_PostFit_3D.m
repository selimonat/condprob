function All_PostFit_3D(FileList);


p         = GetParameters;
WriteBase = [p.Base 'PostFit/'];
tf        = length(FileList);
%
res       = [];

%
for nf = 1:tf;%RUN OVER ALL FILES/
    %
    WritePath = [ FileList{nf}];
    %
    i          = regexp(FileList{1},'Fit');
    PDlocation = [FileList{1}(1:i-1) 'Dist' FileList{1}(i+3:end)];      
    display(['file ' mat2str(nf) ' of ' mat2str(tf)]);
    %
    %IF THE RESULTS ARE NOT COMPUTED FOR THIS FILE

        %LOAD THE EMPIRICAL DATA
        load( [ PDlocation ]);
        %
        %
        %run over actual and control ones.
        for nf = {'A' 'C'}
            field = fieldnames(res.(nf{1}));%
            %here we run over all the fields where there is data stored and we
            %will fit curves to each of them.
            for nf2 = 1:length(field);
                %IN THIS PART WE MAKE THE FITTING TO POSTERIOR PROBABILITIES.
                %we fit data with different orders of independent
                %variables.
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
%
%
%
    function GetKLDivergenz;
        dummy = KLDiv([res.C.MeanPDF,res.A.MeanPDF]);
        res.entropy.KL.C2A = dummy(2,1);
        res.entropy.KL.A2C = dummy(1,2);
    end
%
%
    function GetEntropy
        %HERE COMPUTE THE ENTROPIES
        %in order to get rid off 0 values we add a small constant to
        %those entries.
        res.(nf{1}).(field{nf2})(res.(nf{1}).(field{nf2}) == 0) = 10^-20;
        res.entropy.(nf{1}).(field{nf2}) = -diag(res.(nf{1}).(field{nf2})'*log2(res.(nf{1}).(field{nf2})));
        res.entropy.(nf{1}).MaxEntropy = log2(res.nBin.^res.nDimen);
        %IN the perfect world (which want to have) maxentropy must be equal
        %to the entropy of the control distribution (only in 1d case);
    end

end
