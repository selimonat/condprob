

var              = res;
var.count        = single(var.count);
var.count_c      = single(var.count_c);
var.count_mean   = [mean(var.count(:,1:64),2) mean(var.count(:,65:128),2) mean(var.count(:,129:192),2) mean(var.count(:,193:255),2)]
var.count_c_mean = [mean(var.count_c,2) ];
%
figure
hold on
plot(var.binedges, var.count(:,1:64),'g')
plot(var.binedges, var.count(:,65:128),'b')
plot(var.binedges, var.count(:,129:192),'k')
plot(var.binedges, var.count(:,193:255),'m')
xlabel('r');
ylabel('counts');
axis([0 1 0 max(var.count(:)) ])
%SaveFigure('/mnt/sonat/project_Integration/matlab/condprob/latex/IOV_raw');

figure
hold on
plot(var.binedges, var.count_mean(:,1)./sum(var.count_mean(:,1)),'g')
plot(var.binedges, var.count_mean(:,2)./sum(var.count_mean(:,2)),'b')
plot(var.binedges, var.count_mean(:,3)./sum(var.count_mean(:,3)),'k')
plot(var.binedges, var.count_mean(:,4)./sum(var.count_mean(:,4)),'m')
plot(var.binedges, var.count_c_mean./sum(var.count_c_mean),'r','linewidth',5)
xlim([ 0 1])
xlabel('r');
ylabel('counts');
legend({'natural' 'fractal' 'urban' 'pink'});
SaveFigure('/mnt/sonat/project_Integration/matlab/condprob/latex/IOV_64_mean');
