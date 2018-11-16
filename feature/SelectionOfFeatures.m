%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SELECTION OF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FEATURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/RG_M*'));pd = Feat2PDMat(p,foi,1);
plot(pd.DKL.d([3 4 5 1 2]),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[3 4 5 1 2]}});
%RG_M : 115~163~91, 45, 23
%
%2
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/YB_M*'));pd = Feat2PDMat(p,foi,1);
plot(pd.DKL.d([3 4 5 1 2]),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[3 4 5 1 2]}});
%YB_M : 91, 23, 115~45
%
%3
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/SAT_M*'));pd = Feat2PDMat(p,foi,1);
plot(pd.DKL.d,1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',pd.feat_short_mat);
%SAT_M : 23, 91~45
%
%4
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/LUM_M*'));pd = Feat2PDMat(p,foi,1);
plot(pd.DKL.d([3 4 5 1 2]),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[3 4 5 1 2]}});
%LUM_M : 23, 45, 91, 115, 163
%
%5
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/LUM_C*'));foi = {foi{[1 2 3 6]}};%discard TC;
pd = Feat2PDMat(p,foi,1);
plot(pd.DKL.d([2 3 4 1]),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[([2 3 4 1])]}});
%LUM_C : 45, 91, 115, 163
%
%6
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/RG_C*'));pd = Feat2PDMat(p,foi,1);
order = [2 3 4 1];
plot(pd.DKL.d(order),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[(order)]}});
%RG_C : 91, 45, 115, 23
%
%7
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/YB_C*'));foi = {foi{4:5}};pd = Feat2PDMat(p,foi,1);
order = [1 2];
plot(pd.DKL.d(order),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[(order)]}});
%YB_C : 91, 45~115, 23
%
%8
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/SAT_C*'));pd = Feat2PDMat(p,foi,1);
order = [1 2 3 ];
plot(pd.DKL.d(order),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[(order)]}});
%SAT_C : 91~45, 23
%
%9
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/LUM_C*'));foi = {foi{[3 4 6 7 8 9]}};pd = Feat2PDMat(p,foi,1);
order = [1:6];
plot(pd.DKL.d(order),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[(order)]}});
%TC_C : 135/ here the problem is that smaller the scale, similar is the TC
%map to LC maps. So I think the scale of the TC maps must be relatively big
%compared to LC scale. 135 seems to be ok.
%
%10
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/harris*'));
foi2 = PrepFeatCell(ListFolders('~/pi/FeatureMaps/*IntDim_2*'));
foi3 = PrepFeatCell(ListFolders('~/pi/FeatureMaps/*PC_CORNER*'));
foi = [foi foi2 foi3]
pd = Feat2PDMat(p,foi,1);
order = [1:13];
plot(pd.DKL.d(order),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[(order)]}});
%Cornerness: harris 17~ID2_3_23, harris15, harris13, harris 10,ID2 45, ID2
%10, .... , PC_Corner Kovesi really bad
%
%11
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/*IntDim_1*'));
foi2 = PrepFeatCell(ListFolders('~/pi/FeatureMaps/*PC_EDGE*'));
foi = [foi foi2];
pd = Feat2PDMat(p,foi,1);
order = [4 1 2 3 5 6 7];
plot(pd.DKL.d(order),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[(order)]}});
%EdgeNess: ID_1 10~PC_EDGE,ID_1_5, ID1_23, ID1_45
%
%
%11
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/*IntDim_0*'));
pd = Feat2PDMat(p,foi,1);
order = [4 1 2 3 5 6];
plot(pd.DKL.d(order),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[(order)]}});
%EdgeNess: ID_0 10~,ID_0_5, ID0_23, ID0_45
%
%12
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/*PS*'));
pd = Feat2PDMat(p,foi,1);
order = [1:length(foi)];
plot(pd.DKL.d(order),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[(order)]}});
%Bi-Symmetry: The best ones are small scales ones and the default Kovesi
%version. However they do not detect symmetry as I want. Therefore I am
%gonna use the LUM_PS_96
%
%13
foi   = PrepFeatCell(ListFolders('~/pi/FeatureMaps/*fastradial*'));
pd    = Feat2PDMat(p,foi,1);
order = [ 1:length(foi) ];
plot(pd.DKL.d(order),1:length(foi),'o-');set(gca,'ytick',1:length(foi),'yticklabel',{pd.feat_short_mat{[(order)]}});
%Radial Symmetry : 75_3 is the best...













