function [l,D_x,D_y]=derivative(G)
D_x = 1/32*[3 0 -3; 10 0 -10; 3 0 -3];
D_x = conv2(G,D_x,'valid');
D_y = 1/32*[3 10 3; 0 0 0; -3 -10 -3];
D_y = conv2(G,D_y,'valid');
lap = 1/4*[1 2 1; 2 -12 2; 1 2 1];
l=conv2(G,lap,'valid');