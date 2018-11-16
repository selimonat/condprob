for i  = 16:50;
    %
    im = Load_RGBImage(i);
    imagesc(im)
    ims = size(im);
    colormap gray
    %
    fm = SelectFix(fixmat,'image',i);

    %
    tfix = 10;
    %tfix = length(fm.x( fm.subject == ns & fm.fix == nf));
    for nf = 1:tfix
        imagesc(im)
        colormap gray
        hold on
        for ns = unique(fm.subject);
            i = fm.subject == ns & fm.fix == nf
            if sum((i)) ~= 0
            %image coordinates
            fix_x(nf,ns) =  fm.x(i);
            fix_y(nf,ns) =  fm.y(i);
            %
            plot(fix_x(nf,ns),fix_y(nf,ns),'o','markersize',30);
            %
            if nf > 2
                delete(h(ns))
            end
            if nf ~=1
                %matlab figure coordinates
                as = get(gca,'position');
                %current fixation
                x  = as(1)+(fix_x(nf,ns)./size(im,2))*as(3);
                y  = 1-(as(2)+(fix_y(nf,ns)./size(im,1))*as(4));
                %previous fixations
                x_p  = as(1)+(fix_x(nf-1,ns)./size(im,2))*as(3);
                y_p  = 1-(as(2)+(fix_y(nf-1,ns)./size(im,1))*as(4));
                %
                h(ns) = annotation('arrow',[x_p x],[y_p y],'linewidth',5);
                %
            end
            end
            drawnow;
        end
        pause;
        hold off
    end
end