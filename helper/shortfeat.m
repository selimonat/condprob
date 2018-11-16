function [s]=shortfeat(feat)


short = {...
'LC'
'TC'
'LC'
'TC'
'ID0'
'ID0'
'ID0'
'ID1'
'ID1'
'ID1'
'ID2'
'ID2'
'ID2'
'LM'
'RGC'
'RGC'
'RGM'
'SATC'
'SATC'
'SATM'
};

%long feature names
long = { ...
'LUM_C_Radius_27' 
'LUM_C_Radius_27_C_Radius_71' 
'LUM_C_Radius_53'
'LUM_C_Radius_53_C_Radius_71' 
'LUM_IntDim_0_prestd_3_std_13'
'LUM_IntDim_0_prestd_3_std_27' 
'LUM_IntDim_0_prestd_3_std_7'
'LUM_IntDim_1_prestd_3_std_13' 
'LUM_IntDim_1_prestd_3_std_27'
'LUM_IntDim_1_prestd_3_std_7' 
'LUM_IntDim_2_prestd_3_std_13'
'LUM_IntDim_2_prestd_3_std_27' 
'LUM_IntDim_2_prestd_3_std_7'
'LUM_M_Radius_27' 
'RG_C_Radius_27' 
'RG_C_Radius_53' 
'RG_M_Radius_27'
'SAT_C_Radius_27' 
'SAT_C_Radius_53' 
'SAT_M_Radius_27'
};
%find the input arguments index in the list of features and find the non
%empty array and use it as index for the abbreviation cell array's index
for nf = 1:length(feat)
 i = find(cell2str(regexp(long,feat{nf})') == '1');
    if ~isempty(i) & length(i) == 1
        s{nf} = short{i};
    else%if the short name is not found take the long name
        s{nf} = feat{nf};
    end
end
