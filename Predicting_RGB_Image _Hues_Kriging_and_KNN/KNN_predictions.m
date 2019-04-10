%% Author: Andy Banks 2016 - Univeristy of Kansas Dept. of Geology
% Geostatistis GEOL 791 Final project
% function to predict RGB pixel hues for an image using K nearest neighbors
% Image is sampled a small number of times (nsamp)
% K nearest neighbors algorithim predicts resulting hues

clc
clear
close all

% This code is poorly documented however if you run the code in its current
% state you can see examples of the results 

% try changing these parameters to see how the KNN predicitons change 
nsamp=300; %number of samples
k=1; % k parameter in KNN algorithim (try 1 or 10 or 50!!) -number of nearest neighbors to average
npred=25; % number of prediction points 

%%% BEGIN REST OF CODE %%%%%





%% Load a picture of hamburger to use as dataset %% 
addpath('support_functions');
img=imread('hamburger.jpg');
a = zeros(size(img, 1), size(img, 2)); 


R = im2double(img(:,:,1));   % Red channel  
G = im2double(img(:,:,2));   % Green channel 
B = im2double(img(:,:,3));   % Blue channel



%% Discretize and Sample Field at random XY locations %%
[rows cols]=size(a); 

x=randi(cols,nsamp,1);
y=randi(rows,nsamp,1);
pos=[x,y];

 for i=1:length(x)

    r(i)=R(y(i),x(i)); %sample R
    g(i)=G(y(i),x(i)); %sample G
    b(i)=B(y(i),x(i)); %sample B

 end
 

 %%


[X,Y]=meshgrid(linspace(1,cols,npred),linspace(1,rows,npred));
POS=[reshape(X,[],1),reshape(Y,[],1)]; 


%% %% build KNN tables
figure
set(gcf,'numbertitle','off','name','Knn1') 


cnum=10;
cnum2=10;

rmap=zeros(cnum,3);rmap(:,1)=linspace(0,1,cnum);% rmap(:,2)=linspace(0,1,cnum2); 
gmap=zeros(cnum,3);gmap(:,2)=linspace(0,1,cnum); %gmap(:,3)=linspace(0,1,cnum2); 
bmap=zeros(cnum,3); bmap(:,3)=linspace(0,1,cnum);%bmap(:,1)=linspace(0,1,cnum2); 


knnR=Knn_pred(pos,r',POS,k);
knnG=Knn_pred(pos,g',POS,k);
knnB=Knn_pred(pos,b',POS,k);

predr=reshape(knnR.pred,npred,npred);
predg=reshape(knnG.pred,npred,npred);
predb=reshape(knnB.pred,npred,npred);

KrImg=cat(3,predr,predg,predb);


imagesc(X(1,:),Y(:,1),flipud(KrImg)); axis image; axis xy; title({[' k-NN Predictions']}) 
 ylabel('Y [dist]')

figure(2)
ax=subplot(3,1,1)
imagesc(X(1,:),Y(:,1),flipud(predr)); colormap(ax,rmap); colorbar ;axis image; axis xy ; title({['Red k-NN Predictions']}) 
 ylabel('Y [dist]')
ax=subplot(3,1,2)
imagesc(X(1,:),Y(:,1),flipud(predg)); colormap(ax,gmap); colorbar ; axis image; axis xy ;title({['Green k-NN Predictions']}) 
 ylabel('Y [dist]')
ax=subplot(3,1,3)
imagesc(X(1,:),Y(:,1),flipud(predb)); colormap(ax,bmap); colorbar ; axis image; axis xy;title({['Blue k-NN Predictions']}) 
xlabel('X [dist]'); ylabel('Y [dist]')
%%

 %% Compare to True
[X,Y]=meshgrid(linspace(1,cols,npred),linspace(1,rows,npred));
POS=[reshape(X,[],1),reshape(Y,[],1)]; 
X=reshape(X,[],1); Y=reshape(Y,[],1);
xValid=ceil(X); yValid=ceil(Y);
RValid=[];GValid=[];BValid=[];

 for i=1:length(xValid)
    RValid(i)=R(yValid(i),xValid(i)); %sample R at prediction locations 
    GValid(i)=G(yValid(i),xValid(i)); %sample G at prediction locations 
    BValid(i)=B(yValid(i),xValid(i)); %sample B at prediction locations 
 end
 
figure
ax=subplot(3,1,1);
plot(sort(knnR.pred),'r-','Color',[0.8 0 0],'LineWidth',2); hold on
plot(sort(RValid),'r--','Color',[0.8 0 0],'LineWidth',2);  
posi=get(ax,'position');
%annotation('textbox',[.003+posi(1) .55+posi(2) 0.5*posi(3) 0.2*posi(4)],'String',{['||R_t_r_u_e - R_k_n_n||_2 = ', num2str(norm(sort(knnR.pred)'-sort(RValid)))]},'FontWeight','bold','FitBoxToText','on','BackgroundColor',[0.9 0.8 0.8],'LineWidth',2)
legend({'k-NN R','True R'},'Location','southeast');
axis([0 npred^2 0 1.2]);
grid on
title({['||R_t_r_u_e - R_k_n_n||_2 = ', num2str(norm(sort(knnR.pred)'-sort(RValid)))]},'FontSize',10);
ylabel('Red Hue Intensity');
ax=subplot(3,1,2);
plot(sort(knnG.pred),'g-','Color',[0 0.8 0],'LineWidth',2); hold on
plot(sort(GValid),'g--','Color',[0 0.8 0],'LineWidth',2);  
posi=get(ax,'position');
%annotation('textbox',[.003+posi(1) .55+posi(2) 0.5*posi(3) 0.2*posi(4)],'String',{['||G_t_r_u_e - G_k_n_n||_2 = ', num2str(norm(sort(knnG.pred)'-sort(GValid)))]},'FontWeight','bold','FitBoxToText','on','BackgroundColor',[0.8 0.9 0.8],'LineWidth',2)
legend({'k-NN G','True G'},'Location','southeast');
axis([0 npred^2 0 1.2]);
grid on
title({['||G_t_r_u_e - G_k_n_n||_2 = ', num2str(norm(sort(knnG.pred)'-sort(GValid)))]},'FontSize',10);
ylabel('Green Hue Intensity');
ax=subplot(3,1,3);
plot(sort(knnB.pred),'b-','Color',[ 0 0 0.8],'LineWidth',2); hold on
plot(sort(BValid),'b--','Color',[ 0 0 0.8],'LineWidth',2);   
posi=get(ax,'position');
%annotation('textbox',[.003+posi(1) .55+posi(2) 0.5*posi(3) 0.2*posi(4)],'String',{['||B_t_r_u_e - B_k_n_n||_2 = ', num2str(norm(sort(knnB.pred)'-sort(BValid)))]},'FontWeight','bold','FitBoxToText','on','BackgroundColor',[0.8 0.8 0.9],'LineWidth',2)
legend({'k-NN B','True B'},'Location','southeast');
axis([0 npred^2 0 1.2]);
grid on
title({['||B_t_r_u_e - B_k_n_n||_2 = ', num2str(norm(sort(knnB.pred)'-sort(BValid)))]},'FontSize',10);
xlabel('Sorted Hue Values');
ylabel('Blue Hue Intensity');







 
 
