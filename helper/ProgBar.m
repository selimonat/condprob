function ProgBar(nf,tf)
%ProgBar(nf,tf)
%
%progress indicator
%NF = current state
%TF = total number of states
%
%
%Selim, 14-Feb-2008 20:44:04


%display([ mat2str(nf./tf*100,2) ' % finished...'])
%faster:
display(sprintf(['%i %% being processed...'],ceil((nf-1)./tf*100)));
