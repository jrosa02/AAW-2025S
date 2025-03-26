clc;
clear all;
close all;

format long;

% % utworzenie filtra
% Hg = fspecial('gauss', [3,5], 0.75)
% 
% 
% % sprawdzenie zale¿noœci liniowych wierszy i kolumn
% rankHg = rank(Hg);
% 
% % dekompozycja macierzy
% [U,S,V]=svd(Hg);
% 
% %utworzenie wektorów
% Hv = U(:,1)*sqrt(S(1,1))
% Hh = V(:,1)'*sqrt(S(1,1))
% 
% % test zgodnoœci
% Hc = Hv * Hh;
% equalTest = all(Hc(:)-Hg(:) < 5*max(eps(Hg(:))));
% % figure; surf(Hg);
% % figure; surf(Hc);
% 
% figure;
% I = imread('cameraman.tif');
% subplot(4,2,1); imshow(I);  title('Original Image'); 
% I_filt_1 = imfilter(double(I),Hg);
% I_filt_2 = imfilter(double(I),Hc);
% subplot(4,2,2);imshow(uint8(I_filt_1)); title('Gaussian non - Separable');
% subplot(4,2,3);imshow(uint8(I_filt_2)); title('Gaussian Separable');
% 
% imwrite(I, "cameramen.bmp");
% imwrite(uint8(I_filt_1), "cameramen_nonSeparable.bmp");
% imwrite(uint8(I_filt_2), "cameramen_separable.bmp");


images_res = ["256", "1024", "4096"]

for image_res = images_res
    imagepath = "cameramen_" + image_res + ".bmp"
    I  = (imread(imagepath));
    
    %imshow(I)
    
    tic;
    I_gaus = imgaussfilt(I, 0.75, 'FilterSize', 3);
    T = toc;
    T
    I_gaus = cat(3, I_gaus, I_gaus, I_gaus);

    imwrite(I_gaus, "cameramen_Output_MatLab_" + image_res + ".bmp")
    
    %imshow(I_med)
end
