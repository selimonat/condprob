ff = ListFolders('*_*');
for x = 1:length(ff);f{x}{1}=ff{x};end

p{1}  = GetParameters('start',0,'end',1000);
All_GetDist2(p{1},f);

p{2} = GetParameters('start',1000,'end',2000);
All_GetDist2(p{2},f);

p{3} = GetParameters('start',2000,'end',3000);
All_GetDist2(p{3},f);

p{4} = GetParameters('start',3000,'end',4000);
All_GetDist2(p{4},f);

p{5} = GetParameters('start',4000,'end',5000);
All_GetDist2(p{5},f);

p{6} = GetParameters('start',5000,'end',6500);
All_GetDist2(p{6},f);

%
p{1} = GetParameters('start',1000,'end',2000);
p{2} = GetParameters('start',2000,'end',3000);
p{3} = GetParameters('start',3000,'end',4000);
p{4} = GetParameters('start',4000,'end',5000);
p{5} = GetParameters('start',5000,'end',6000);
%
f = {'ClickMap_FWHM_45'
'FixMap_FWHM_45'    
'LUM_IntDim_2_prestd_3_std_23'
'LUM_PC_EDGE_WL_24'
'LUM_IntDim_0_prestd_3_std_45'
'LUM_PC_CORNER_WL_24'
'RG_C_Radius_45'
'LUM_C_Radius_45'
'SAT_C_Radius_45'
'YB_C_Radius_45'
'LUM_PS_WL_24'
'LUM_C_Radius_45_C_Radius_135'
'LUM_DX_STD_3'
'LUM_DY_STD_3'
'LUM_LAP_STD_23'
'RG_M_Radius_91'
'LUM_M_Radius_91'
'SAT_M_Radius_91'
'YB_M_Radius_91'}


for nf = 1:length(f)
    ProgBar(nf,length(f))
    for t = 1:5
    [FM{t}]=GetPlotMatrixLabel({f{nf}},p{t});
    end
    for cat = 1:4
        for t = [1 2 3 4 5]
            load(['~/project_Integration/PostFit/' FM{t}{cat}]);
            data(nf,cat,t) = res.entropy.C.MeanPDF-res.entropy.A.MeanPDF;            
        end
    end
end