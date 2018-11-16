function [varargout]=SelectFix(fixmat,varargin)
%[varargout]=SelectFix(fixmat,varargin)
%[y,x]         =SelectFix(fixmat,varargin)
%[fixmat]    =SelectFix(fixmat,varargin)
%   Filters out fixations from FIXMAT structure array according to varargin
%   arguments. FIXMAT is the output of fixread. If two output arguments are
%   given then Y and X coordinates of selected fixations are returned. In the case
%   of when output argument is unique the "cleaned" fixmat is returned. The
%   selection process is realized depending on the VARARGIN arguments which
%   must always be entered in pair. The first arguments must be a string
%   with the same name of one of the fixmat fields (the field you want to
%   make the selection with). The following entry must be a numerical array
%   of numbers. The fixations (each row of the fixmat) which have the
%   required equality constraints will be retained and output in varargout
%   in a form depending on nargout.
%
%  (1) If no varargin is given it considers all the fixations as
%  valid, except the ones which are outside of the range (the size of the
%  image)
%
%  (2a) If varargin is given but it is only a vector then it uses the true
%  statements in the vector as valid fixations. Fixations which are out of
%  the range are removed.
%
%  (2b) If varargin is more then a vector than it considers the first entry as
%  a fixmat field name (for example "image") and the second entry as the selection
%  criteria for that field. It applies the AND operator if many fields are
%  given. Fixations which are out of the range are removed.
%
%   Examples:
%   Any field of the FIXMAT can be used to filter the fixations.
%   SelectFix(fixmat,'image',[1 10 100]) ==> would filter
%   fixations done on only images 1, 10 and 100. This usage is also valid
%   for "subject", "fix", "condition" fields of fixmat where the value
%   following the field name is allowed to be a vector and EQUALITY
%   constraint is used for the selection.
%   
%   SelectFix(fixmat,'start',[100]) ==> would select fixations which 
%   are realized after 100 ms, that is a bigger constraint is apllied. This
%   usage is valid also for the "stop" field where the smaller operator is
%   used.
%
%
%   2006, 11,November; Selim Onat AND Frank Schumann
%   08-Dec-2009, Selim, added the possibility of outputting the selection
%   vector.

%SELECT FIXATIONS
%selection is a logical array containing the indices of the fixations to be deleted
selection = ~(fixmat.x < fixmat.rect(3) | fixmat.x > fixmat.rect(4) | fixmat.y < fixmat.rect(1) | fixmat.y > fixmat.rect(2));
%
%
if isempty(varargin) %(1)
    selection = selection;
else %(2)
    if length(varargin) == 1 %(2a)
        selection = varargin{1}.*selection;
    else%(2b)
        nopt = 1;%run over optional arguments
        while nopt < length(varargin)

            if strcmp(varargin{nopt},'image');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.image,varargin{nopt});
            elseif strcmp(varargin{nopt},'subject');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.subject,varargin{nopt});
            elseif strcmp(varargin{nopt},'condition');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.condition,varargin{nopt});
            elseif strcmp(varargin{nopt},'condition_aligned');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.condition_aligned,varargin{nopt});
            elseif strcmp(varargin{nopt},'start');
                nopt = nopt+1;
                selection = selection & (fixmat.start >= varargin{nopt});
            elseif strcmp(varargin{nopt},'end');
                nopt = nopt+1;
                selection = selection & (fixmat.end <= varargin{nopt});
            elseif strcmp(varargin{nopt},'fix');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.fix,varargin{nopt});            
            elseif strcmp(varargin{nopt},'duration');
                nopt = nopt+1;
                selection = selection & (fixmat.end-fixmat.start >= varargin{nopt});
            elseif  strcmp(varargin{nopt},'gender');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.gender,varargin{nopt}); 
            elseif  strcmp(varargin{nopt},'category');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.category,varargin{nopt}); 
			elseif  strcmp(varargin{nopt},'eye');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.eye,varargin{nopt}); 
            elseif  strcmp(varargin{nopt},'session');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.session,varargin{nopt});                                    
            elseif  strcmp(varargin{nopt},'tms');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.tms,varargin{nopt});   
            elseif  strcmp(varargin{nopt},'source');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.source,varargin{nopt}); 
            elseif  strcmp(varargin{nopt},'phase');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.phase,varargin{nopt});     
            elseif  strcmp(varargin{nopt},'oddball') || strcmp(varargin{nopt},'ucs');
                nopt = nopt+1;
                selection = selection & ismember(fixmat.oddball,varargin{nopt});         
            else
                keyboard
                display(['varargin{' mat2str(nopt) '} does not match to any of the fixmat fields']);
            end
            nopt = nopt+1;
        end
    end
end


%PREPARE OUTPUT
if nargout == 2
    varargout{2} = round(fixmat.x(selection));
    varargout{1} = round(fixmat.y(selection));

elseif nargout == 3            
    varargout{3} = selection;
    varargout{2} = round(fixmat.x(selection));
    varargout{1} = round(fixmat.y(selection));            
elseif nargout == 1
    f  = fieldnames(fixmat);
    tf = length(f);
    for nf = 1:tf        
        if size(fixmat.(f{nf}),2) == size(selection,2)%this if statement is here to bypass the rect field.
            fixmat.(f{nf}) = fixmat.(f{nf})(logical(selection));
        end
    end
    varargout{1} = fixmat;
end
