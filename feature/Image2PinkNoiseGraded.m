function [Scrambled]=Image2PinkNoiseGraded(im, f)
%[Pink]=Image2PinkNoise(im,f)
%IM is the image from which the power spectra is taken and used to create
%the pink noise. IT HAS TO BE A DOUBLE PRECISION VARIABLE otherwise you will
%get warning messages. Power spectra is then combined with random phase
%information and transformed back to the pixel space. The resulting matrix
%PINK has the same power spectra as IM which also means that mean and
%standard deviations of IM and PINK are exactly the same. F is the factor
%that controls the amount of phase scrambling. if F is 0 the original image
%is returned, if F is equal to 1, full randomization is performed.
%
%Selim 2006
%Selim Alper 2006 -> graded randomization of phase is implemented.

%fourier transform the image.
imf   = fft2(im);
%Store the amplitudes, we will use those with the random angles;
Amp = abs(imf);
ori = angle(imf);
%now we need random phases. We obtain that from the fft2 of a white noise
%array.
RandAngles = angle(fft2(rand(size(im))));

%The amount of phase noise (f) determines how much of the random phases
%will be added to the original phases
AngleChange = RandAngles*f;
NewAngles = (ori + AngleChange);

%Addition in circular scale makes the values leave the range (-pi to +pi), the below
%operations take care of this (this step is not neessary - think about this!-, but elegant)
%For an illustration: Uncomment the lines below
%the UNCOMMENT lines below

%UNCOMMENT 
%figure, hist(ori(:), 50), title('Phase Distribution - original'); 
%figure, hist(NewAngles(:), 50), title('Phase Distribution - after addition'); 

% % NewAngles(NewAngles > pi) = NewAngles(NewAngles > pi) - 2*pi;
% % NewAngles(NewAngles < (-1)*pi) = NewAngles(NewAngles < (-1)*pi) + 2*pi;

%UNCOMMENT 
%figure, hist(NewAngles(:), 50), title('Phase Distribution - after correction');


%Use the Random Angles and the Amplitudes and convert back to the pixel
%space. 
Scrambled = real(ifftn(Amp.*exp(i.*(NewAngles))));


