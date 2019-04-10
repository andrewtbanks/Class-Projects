
%% Author: Andy Banks 2016 - Univeristy of Kansas Dept. of Geology
% Geostatistis GEOL 791 Final project
% function to predict RGB pixel hues for an image using universal kriging
% red green and blue picel hues aresampled a small number of times (nsamp = 300)
% Variograms fitted to sampled data and universal kringing used to estimate
% intermediate hues. 

% This code is poorly documented however if you run the code in its current
% state you can see examples of the results 

% the figure ' Samples RGB data shows the initial image with the locations
% of sampling points

% the figure 'kriging' shows the kiring results. Maximize this window to
% enlarge the subplots 


clc
clear
close all


nsamp=300; %number of samples (try changing this!!)

%% Load a picture to use as dataset %% 
addpath('support_functions');
img=imread('hamburger.jpg');
a = zeros(size(img, 1), size(img, 2)); 

%% Seperate image layers and treat as parameters %%
% -- pixel hues analagous to spatial parameters
% -- at any point in the field r g and b hues (between 0 & 1) can be measured

R = im2double(img(:,:,1));   % Red channel  
G = im2double(img(:,:,2));   % Green channel 
B = im2double(img(:,:,3));   % Blue channel

%% Plot True Field & RGB Hue Components ("parameters") %%

figure

set(gcf,'numbertitle','off','name','True Field') 
subplot(2,2,1)
imshow(img);                    title('Full True "Parameter" Field');
subplot(2,2,2) 
imshow(cat(3,img(:,:,1),a,a));  title('True Red Component')
subplot(2,2,3) 
imshow(cat(3,a,img(:,:,2),a));  title('True Green Component')
subplot(2,2,4) 
imshow(cat(3,a,a,img(:,:,3)));  title('True Blue Component')

%% Discretize and Sample Field at random XY locations %%
[rows cols]=size(a); 



x=ceil(cols*(rand(nsamp,1))); %random x (column) sampling points
y=ceil(rows*(rand(nsamp,1))); %random y (row) sampling points

pos=[x,y]; %[x,y] 2*nsamp vector of sampling positions

for i=1:nsamp
    r(i)=R(pos(i,2),pos(i,1)); %sample R
    g(i)=G(pos(i,2),pos(i,1)); %sample G
    b(i)=B(pos(i,2),pos(i,1)); %sample B
end

%% Examine Sample r g b Data %%

figure
set(gcf,'numbertitle','off','name','Sampled r g b Data') 
subplot(2,1,1)
imagesc(flipud(img)); axis xy; grid on;  hold on 
scatter(x,y,15,'wo','filled','MarkerEdgeColor','black')
title('True Field With Sampling Locations')

subplot(2,1,2)
hold on
scatter(x(find(r<0.8 )),y(find(r<0.8 )),10,r(find(r<0.8 )),'ro'); 
scatter(x(find(g<0.8 )),y(find(g<0.8 )),10,g(find(g<0.8 )),'gs'); 
scatter(x(find(b<0.8 )),y(find(b<0.8 )),10,b(find(b<0.8 )),'b^'); 

scatter(x(find(r>=0.2 & r<0.4)),y(find(r>=0.2 & r<0.4)),20,r(find(r>=0.2 & r<0.4)),'ro'); 
scatter(x(find(g>=0.2 & g<0.4)),y(find(g>=0.2 & g<0.4)),20,g(find(g>=0.2 & g<0.4)),'gs'); 
scatter(x(find(b>=0.2 & b<0.4)),y(find(b>=0.2 & b<0.4)),20,b(find(b>=0.2 & b<0.4)),'b^');  

scatter(x(find(r>=0.4 & r<0.6)),y(find(r>=0.4 & r<0.6)),30,r(find(r>=0.4 & r<0.6)),'ro'); 
scatter(x(find(g>=0.4 & g<0.6)),y(find(g>=0.4 & g<0.6)),30,g(find(g>=0.4 & g<0.6)),'gs'); 
scatter(x(find(b>=0.4 & b<0.6)),y(find(b>=0.4 & b<0.6)),30,b(find(b>=0.4 & b<0.6)),'b^'); 

scatter(x(find(r>=0.6 & r<0.8)),y(find(r>=0.6 & r<0.8)),40,r(find(r>=0.6 & r<0.8)),'ro'); 
scatter(x(find(g>=0.6 & g<0.8)),y(find(g>=0.6 & g<0.8)),40,g(find(g>=0.6 & g<0.8)),'gs'); 
scatter(x(find(b>=0.6 & b<0.8)),y(find(b>=0.6 & b<0.8)),40,b(find(b>=0.6 & b<0.8)),'b^'); 

scatter(x(find(r>=0.8 )),y(find(r>=0.8 )),50,r(find(r>=0.8 )),'ro'); 
scatter(x(find(g>=0.8 )),y(find(g>=0.8 )),50,g(find(g>=0.8 )),'gs'); 
scatter(x(find(b>=0.8 )),y(find(b>=0.8 )),50,b(find(b>=0.8 )),'b^'); 

axis([0 cols 0 rows])
grid on
title('Sampled RGB Hue Intensity (Marker Size)')
legend('r','g','b')

%% Setup Indicator vars rind gind bind

% [0 1]
rind1=r;
rind1(find(rind1<0.5))=0; %round down to 0 from <0.5
rind1(find(rind1>=0.5))=1; %round up from =>0.5 to 1

gind1=g;
gind1(find(gind1<0.5))=0; %round down to 0 from <0.5
gind1(find(gind1>=0.5))=1; %round up from =>0.5 to 1

bind1=b;
bind1(find(bind1<0.5))=0; %round down to 0 from <0.5
bind1(find(bind1>=0.5))=1; %round up from =>0.5 to 1

%[0 0.5 1]
rind2=r;
rind2(find(rind2<=0.333))=0; %round down to 0 from <0.25
rind2(find(rind2>0.333 & rind2<=0.666))=0.5; %round up/down from >0.333 <=0.666 to 0.5
rind2(find(rind2>0.666 & rind2<=1))=1; %round up from >0.666 <=1 to 1

gind2=g;
gind2(find(gind2<=0.333))=0; %round down to 0 from <0.25
gind2(find(gind2>0.333 & gind2<=0.666))=0.5; %round up/down from >0.333 <=0.666 to 0.5
gind2(find(gind2>0.666 & gind2<=1))=1; %round up from >0.666 <=1 to 1

bind2=b;
bind2(find(bind2<=0.333))=0; %round down to 0 from <0.25
bind2(find(bind2>0.333 & bind2<=0.666))=0.5; %round up/down from >0.333 <=0.666 to 0.5
bind2(find(bind2>0.666 & bind2<=1))=1; %round up from >0.666 <=1 to 1

%[0 0.33 0.66 1]
ind=[0 0.33 0.66 1];
rng=[];
rng(1)=ind(2)/2; rng(2)=ind(2)+rng(1); rng(3)=ind(4)-rng(1); rng(4)=ind(4);
rind3=r;
rind3(find(rind3<=rng(1)))=ind(1); 
rind3(find(rind3>rng(1) & rind3<=rng(2)))=ind(2); 
rind3(find(rind3>rng(2) & rind3<=rng(3)))=ind(3); 
rind3(find(rind3>rng(3) & rind3<=rng(4)))=ind(4); 
gind3=g;
gind3(find(gind3<=rng(1)))=ind(1); 
gind3(find(gind3>rng(1) & gind3<=rng(2)))=ind(2); 
gind3(find(gind3>rng(2) & gind3<=rng(3)))=ind(3); 
gind3(find(gind3>rng(3) & gind3<=rng(4)))=ind(4); 
bind3=b;
bind3(find(bind3<=rng(1)))=ind(1); 
bind3(find(bind3>rng(1) & bind3<=rng(2)))=ind(2); 
bind3(find(bind3>rng(2) & bind3<=rng(3)))=ind(3); 
bind3(find(bind3>rng(3) & bind3<=rng(4)))=ind(4); 

%[0 0.25 0.5 0.75 1]
ind=[0 0.25 0.5 0.75 1];
rng=[];
rng(1)=ind(2)/2; rng(2)=ind(2)+rng(1); rng(3)=ind(4)-rng(1); rng(4)=ind(4)+rng(1); rng(5)=ind(5);
rind4=r;
rind4(find(rind4<=rng(1)))=ind(1); 
rind4(find(rind4>rng(1) & rind4<=rng(2)))=ind(2); 
rind4(find(rind4>rng(2) & rind4<=rng(3)))=ind(3); 
rind4(find(rind4>rng(3) & rind4<=rng(4)))=ind(4); 
rind4(find(rind4>rng(4) & rind4<=rng(5)))=ind(5);
gind4=g;
gind4(find(gind4<=rng(1)))=ind(1); 
gind4(find(gind4>rng(1) & gind4<=rng(2)))=ind(2); 
gind4(find(gind4>rng(2) & gind4<=rng(3)))=ind(3); 
gind4(find(gind4>rng(3) & gind4<=rng(4)))=ind(4); 
gind4(find(gind4>rng(4) & gind4<=rng(5)))=ind(5);
bind4=b;
bind4(find(bind4<=rng(1)))=ind(1); 
bind4(find(bind4>rng(1) & bind4<=rng(2)))=ind(2); 
bind4(find(bind4>rng(2) & bind4<=rng(3)))=ind(3); 
bind4(find(bind4>rng(3) & bind4<=rng(4)))=ind(4); 
bind4(find(bind4>rng(4) & bind4<=rng(5)))=ind(5);

%[0 0.2 0.4 0.6 0.8 1]
ind=[0 0.2 0.4 0.6 0.8 1];
rng=[];
rng(1)=ind(2)/2; rng(2)=ind(2)+rng(1); rng(3)=ind(4)-rng(1); rng(4)=ind(4)+rng(1); rng(5)=ind(6)-rng(1); rng(6)=ind(6);
rind5=r;
rind5(find(rind5<=rng(1)))=ind(1); 
rind5(find(rind5>rng(1) & rind5<=rng(2)))=ind(2); 
rind5(find(rind5>rng(2) & rind5<=rng(3)))=ind(3); 
rind5(find(rind5>rng(3) & rind5<=rng(4)))=ind(4); 
rind5(find(rind5>rng(4) & rind5<=rng(5)))=ind(5);
rind5(find(rind5>rng(5) & rind5<=rng(6)))=ind(6);
gind5=g;
gind5(find(gind5<=rng(1)))=ind(1); 
gind5(find(gind5>rng(1) & gind5<=rng(2)))=ind(2); 
gind5(find(gind5>rng(2) & gind5<=rng(3)))=ind(3); 
gind5(find(gind5>rng(3) & gind5<=rng(4)))=ind(4); 
gind5(find(gind5>rng(4) & gind5<=rng(5)))=ind(5);
gind5(find(gind5>rng(5) & gind5<=rng(6)))=ind(6);
bind5=b;
bind5(find(bind5<=rng(1)))=ind(1); 
bind5(find(bind5>rng(1) & bind5<=rng(2)))=ind(2); 
bind5(find(bind5>rng(2) & bind5<=rng(3)))=ind(3); 
bind5(find(bind5>rng(3) & bind5<=rng(4)))=ind(4); 
bind5(find(bind5>rng(4) & bind5<=rng(5)))=ind(5);
bind5(find(bind5>rng(5) & bind5<=rng(6)))=ind(6);

%[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]
ind=[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
rng=[];
rng(1)=ind(2)/2; rng(2)=ind(2)+rng(1); rng(3)=ind(3)+rng(1); rng(4)=ind(4)+rng(1); rng(5)=ind(5)+rng(1); rng(6)=ind(6)+rng(1); rng(7)=ind(7)+rng(1); rng(8)=ind(8)+rng(1); rng(9)=ind(9)+rng(1); rng(10)=ind(11); 
rind6=r;
rind6(find(rind6<=rng(1)))=ind(1); 
rind6(find(rind6>rng(1) & rind6<=rng(2)))=ind(2); 
rind6(find(rind6>rng(2) & rind6<=rng(3)))=ind(3); 
rind6(find(rind6>rng(3) & rind6<=rng(4)))=ind(4); 
rind6(find(rind6>rng(4) & rind6<=rng(5)))=ind(5);
rind6(find(rind6>rng(5) & rind6<=rng(6)))=ind(6);
rind6(find(rind6>rng(6) & rind6<=rng(7)))=ind(7);
rind6(find(rind6>rng(7) & rind6<=rng(8)))=ind(8);
rind6(find(rind6>rng(8) & rind6<=rng(9)))=ind(9);
rind6(find(rind6>rng(9) & rind6<=rng(10)))=ind(10);

gind6=g;
gind6(find(gind6<=rng(1)))=ind(1); 
gind6(find(gind6>rng(1) & gind6<=rng(2)))=ind(2); 
gind6(find(gind6>rng(2) & gind6<=rng(3)))=ind(3); 
gind6(find(gind6>rng(3) & gind6<=rng(4)))=ind(4); 
gind6(find(gind6>rng(4) & gind6<=rng(5)))=ind(5);
gind6(find(gind6>rng(5) & gind6<=rng(6)))=ind(6);
gind6(find(gind6>rng(6) & gind6<=rng(7)))=ind(7);
gind6(find(gind6>rng(7) & gind6<=rng(8)))=ind(8);
gind6(find(gind6>rng(8) & gind6<=rng(9)))=ind(9);
gind6(find(gind6>rng(9) & gind6<=rng(10)))=ind(10);

bind6=b;
bind6(find(bind6<=rng(1)))=ind(1); 
bind6(find(bind6>rng(1) & bind6<=rng(2)))=ind(2); 
bind6(find(bind6>rng(2) & bind6<=rng(3)))=ind(3); 
bind6(find(bind6>rng(3) & bind6<=rng(4)))=ind(4); 
bind6(find(bind6>rng(4) & bind6<=rng(5)))=ind(5);
bind6(find(bind6>rng(5) & bind6<=rng(6)))=ind(6);
bind6(find(bind6>rng(6) & bind6<=rng(7)))=ind(7);
bind6(find(bind6>rng(7) & bind6<=rng(8)))=ind(8);
bind6(find(bind6>rng(8) & bind6<=rng(9)))=ind(9);
bind6(find(bind6>rng(9) & bind6<=rng(10)))=ind(10);

%%  Residual Kriging (Universal) 


figure 
set(gcf,'numbertitle','off','name','Universal Kriging Variograms') 
axs=[0 1200 0 0.35];%for fitted variogram axes
nrbins=25;%for variogram bins
nbin=30; %for histogram bins



%%%

tbl=table(x,y,r','VariableNames',{'x','y','r'});
rmdl=fitlm(tbl,'r~x+y');
tbl=table(x,y,g','VariableNames',{'x','y','g'});
gmdl=fitlm(tbl,'g~x+y');
tbl=table(x,y,b','VariableNames',{'x','y','b'});
bmdl=fitlm(tbl,'b~x+y');

dr = variogram(pos,table2array(rmdl.Residuals(:,1)),'nrbins',nrbins); 
dg = variogram(pos,table2array(gmdl.Residuals(:,1)),'nrbins',nrbins);
db = variogram(pos,table2array(bmdl.Residuals(:,1)),'nrbins',nrbins);
a0=8000; c0=0.05;

ax=subplot(3,7,1);
[ar,cr,nr,drstruct] = variogramfit(dr.distance,dr.val,a0,c0,[]);axis(axs); grid on; title({['Fitted Spherical'];[' Semivariogram'];['n_i_n_d=n_s_a_m_p=',num2str(nsamp)]}); ylabel({['Red (r)'];['\gamma (h)']})
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','r'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h1=histogram(r,nbin,'FaceColor','r');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(rmdl.Residuals(:,1)),'rs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','r'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];


ax=subplot(3,7,8);
[ag,cg,ng,dgstruct] = variogramfit(dg.distance,dg.val,a0,c0,[]); axis(axs); grid on; ylabel({['Green (g)'];['\gamma (h)']})
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','g'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h2=histogram(r,nbin,'FaceColor','g');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(gmdl.Residuals(:,1)),'gs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','g'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];
 
ax=subplot(3,7,15);
[ab,cb,nb,dbstruct] = variogramfit(db.distance,db.val,a0,c0,[]); axis(axs); grid on; ylabel({['Blue (b)'];['\gamma (h)']})
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','b'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h3=histogram(r,nbin,'FaceColor','b');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(bmdl.Residuals(:,1)),'bs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','b'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];


%%%%

tbl=table(x,y,rind1','VariableNames',{'x','y','r'});
rmdl=fitlm(tbl,'r~x+y');
tbl=table(x,y,gind1','VariableNames',{'x','y','g'});
gmdl=fitlm(tbl,'g~x+y');
tbl=table(x,y,bind1','VariableNames',{'x','y','b'});
bmdl=fitlm(tbl,'b~x+y');

dr1 = variogram(pos,table2array(rmdl.Residuals(:,1)),'nrbins',nrbins); 
dg1 = variogram(pos,table2array(gmdl.Residuals(:,1)),'nrbins',nrbins);
db1 = variogram(pos,table2array(bmdl.Residuals(:,1)),'nrbins',nrbins);
a0=8000; c0=0.3;

ax=subplot(3,7,2);
[ar1,cr1,nr1,dr1struct] = variogramfit(dr1.distance,dr1.val,a0,c0,[]);axis(axs);grid on;title({['Fitted Spherical'];[' Semivariogram'];['n_i_n_d=2']}); ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','r'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.006]; ax2=axes('Position',posi); 
h1=histogram(rind1,nbin,'FaceColor','r');grid on; axis([0 1.1 0 60]);ax2.XAxisLocation='top';
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.02,0.006]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(rmdl.Residuals(:,1)),'rs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','r'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.XAxisLocation='top'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];

ax=subplot(3,7,9);
[ag1,cg1,ng1,dg1struct] = variogramfit(dg1.distance,dg1.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','g'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.006]; ax2=axes('Position',posi);
h2=histogram(gind1,nbin,'FaceColor','g');grid on; axis([0 1.1 0 60]);ax2.XAxisLocation='top';
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.02,0.006]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(gmdl.Residuals(:,1)),'gs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','g'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.XAxisLocation='top'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];
 

ax=subplot(3,7,16);
[ab1,cb1,nb1,db1struct] = variogramfit(db1.distance,db1.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','b'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.006]; ax2=axes('Position',posi);
h3=histogram(bind1,nbin,'FaceColor','b');grid on; axis([0 1.1 0 60]);ax2.XAxisLocation='top';
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.02,0.006]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(bmdl.Residuals(:,1)),'bs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','b'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.XAxisLocation='top'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];

%%%%

tbl=table(x,y,rind2','VariableNames',{'x','y','r'});
rmdl=fitlm(tbl,'r~x+y');
tbl=table(x,y,gind2','VariableNames',{'x','y','g'});
gmdl=fitlm(tbl,'g~x+y');
tbl=table(x,y,bind2','VariableNames',{'x','y','b'});
bmdl=fitlm(tbl,'b~x+y');

dr2 = variogram(pos,table2array(rmdl.Residuals(:,1)),'nrbins',nrbins); 
dg2 = variogram(pos,table2array(gmdl.Residuals(:,1)),'nrbins',nrbins);
db2 = variogram(pos,table2array(bmdl.Residuals(:,1)),'nrbins',nrbins);
a0=8000; c0=0.2;

ax=subplot(3,7,3);
[ar2,cr2,nr2,dr2struct] = variogramfit(dr2.distance,dr2.val,a0,c0,[]);axis(axs); grid on;title({['Fitted Spherical'];[' Semivariogram'];['n_i_n_d=3']}); ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','r'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h1=histogram(rind2,nbin,'FaceColor','r');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(rmdl.Residuals(:,1)),'rs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','r'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];
 
ax=subplot(3,7,10);
[ag2,cg2,ng2,dg2struct] = variogramfit(dg2.distance,dg2.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','g'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h2=histogram(gind2,nbin,'FaceColor','g');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(gmdl.Residuals(:,1)),'gs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','g'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];
 
ax=subplot(3,7,17);
[ab2,cb2,nb2,db2struct] = variogramfit(db2.distance,db2.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','b'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h3=histogram(bind2,nbin,'FaceColor','b');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(bmdl.Residuals(:,1)),'bs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','b'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];

%%%%

tbl=table(x,y,rind3','VariableNames',{'x','y','r'});
rmdl=fitlm(tbl,'r~x+y');
tbl=table(x,y,gind3','VariableNames',{'x','y','g'});
gmdl=fitlm(tbl,'g~x+y');
tbl=table(x,y,bind3','VariableNames',{'x','y','b'});
bmdl=fitlm(tbl,'b~x+y');

dr3 = variogram(pos,table2array(rmdl.Residuals(:,1)),'nrbins',nrbins); 
dg3 = variogram(pos,table2array(gmdl.Residuals(:,1)),'nrbins',nrbins);
db3 = variogram(pos,table2array(bmdl.Residuals(:,1)),'nrbins',nrbins);
a0=8000; c0=0.2;

ax=subplot(3,7,4);
[ar3,cr3,nr3,dr3struct] = variogramfit(dr3.distance,dr3.val,a0,c0,[]);axis(axs); grid on;title({['Fitted Spherical'];[' Semivariogram'];['n_i_n_d=4']}); ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','r'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h1=histogram(rind3,nbin,'FaceColor','r');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(rmdl.Residuals(:,1)),'rs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','r'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];

ax=subplot(3,7,11);
[ag3,cg3,ng2,dg3struct] = variogramfit(dg3.distance,dg3.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','g'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h2=histogram(gind3,nbin,'FaceColor','g');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(gmdl.Residuals(:,1)),'gs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','g'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];
 
ax=subplot(3,7,18);
[ab3,cb3,nb3,db3struct] = variogramfit(db3.distance,db3.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','b'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h3=histogram(bind3,nbin,'FaceColor','b');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(bmdl.Residuals(:,1)),'bs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','b'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];

%%%%
tbl=table(x,y,rind4','VariableNames',{'x','y','r'});
rmdl=fitlm(tbl,'r~x+y');
tbl=table(x,y,gind4','VariableNames',{'x','y','g'});
gmdl=fitlm(tbl,'g~x+y');
tbl=table(x,y,bind4','VariableNames',{'x','y','b'});
bmdl=fitlm(tbl,'b~x+y');

dr4 = variogram(pos,table2array(rmdl.Residuals(:,1)),'nrbins',nrbins); 
dg4 = variogram(pos,table2array(gmdl.Residuals(:,1)),'nrbins',nrbins);
db4 = variogram(pos,table2array(bmdl.Residuals(:,1)),'nrbins',nrbins);
a0=8000; c0=0.2;

ax=subplot(3,7,5);
[ar4,cr4,nr4,dr4struct] = variogramfit(dr4.distance,dr4.val,a0,c0,[]);axis(axs); grid on;title({['Fitted Spherical'];[' Semivariogram'];['n_i_n_d=5']}); ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','r'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h1=histogram(rind4,nbin,'FaceColor','r');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(rmdl.Residuals(:,1)),'rs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','r'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];

ax=subplot(3,7,12);
[ag4,cg4,ng4,dg4struct] = variogramfit(dg4.distance,dg4.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','g'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h2=histogram(gind4,nbin,'FaceColor','g');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(gmdl.Residuals(:,1)),'gs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','g'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];
 
ax=subplot(3,7,19);
[ab4,cb4,nb4,db4struct] = variogramfit(db4.distance,db4.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','b'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h3=histogram(bind4,nbin,'FaceColor','b');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(bmdl.Residuals(:,1)),'bs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','b'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];

%%%%
tbl=table(x,y,rind5','VariableNames',{'x','y','r'});
rmdl=fitlm(tbl,'r~x+y');
tbl=table(x,y,gind5','VariableNames',{'x','y','g'});
gmdl=fitlm(tbl,'g~x+y');
tbl=table(x,y,bind5','VariableNames',{'x','y','b'});
bmdl=fitlm(tbl,'b~x+y');

dr5 = variogram(pos,table2array(rmdl.Residuals(:,1)),'nrbins',nrbins); 
dg5 = variogram(pos,table2array(gmdl.Residuals(:,1)),'nrbins',nrbins);
db5 = variogram(pos,table2array(bmdl.Residuals(:,1)),'nrbins',nrbins);
a0=8000; c0=0.2;

ax=subplot(3,7,6);
[ar5,cr5,nr5,dr5struct] = variogramfit(dr5.distance,dr5.val,a0,c0,[]);axis(axs); grid on;title({['Fitted Spherical'];[' Semivariogram'];['n_i_n_d=6']}); ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','r'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h1=histogram(rind5,nbin,'FaceColor','r');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(rmdl.Residuals(:,1)),'rs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','r'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];

ax=subplot(3,7,13);
[ag5,cg5,ng5,dg5struct] = variogramfit(dg5.distance,dg5.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','g'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h2=histogram(gind5,nbin,'FaceColor','g');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(gmdl.Residuals(:,1)),'gs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','g'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];
 
ax=subplot(3,7,20);
[ab5,cb5,nb5,db5struct] = variogramfit(db5.distance,db5.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','b'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h3=histogram(bind5,nbin,'FaceColor','b');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(bmdl.Residuals(:,1)),'bs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','b'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];

%%%%
tbl=table(x,y,rind6','VariableNames',{'x','y','r'});
rmdl=fitlm(tbl,'r~x+y');
tbl=table(x,y,gind6','VariableNames',{'x','y','g'});
gmdl=fitlm(tbl,'g~x+y');
tbl=table(x,y,bind6','VariableNames',{'x','y','b'});
bmdl=fitlm(tbl,'b~x+y');

dr6 = variogram(pos,table2array(rmdl.Residuals(:,1)),'nrbins',nrbins); 
dg6 = variogram(pos,table2array(gmdl.Residuals(:,1)),'nrbins',nrbins);
db6 = variogram(pos,table2array(bmdl.Residuals(:,1)),'nrbins',nrbins);
a0=8000; c0=0.2;

ax=subplot(3,7,7);
[ar6,cr6,nr6,dr6struct] = variogramfit(dr6.distance,dr6.val,a0,c0,[]);axis(axs); grid on;title({['Fitted Spherical'];[' Semivariogram'];['n_i_n_d=10']}); ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','r'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h1=histogram(rind6,nbin,'FaceColor','r');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(rmdl.Residuals(:,1)),'rs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','r'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];

ax=subplot(3,7,14);
[ag6,cg6,ng6,dg6struct] = variogramfit(dg6.distance,dg6.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','g'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h2=histogram(gind6,nbin,'FaceColor','g');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(gmdl.Residuals(:,1)),'gs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','g'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];
 
ax=subplot(3,7,21);
[ab6,cb6,nb6,db6struct] = variogramfit(db6.distance,db6.val,a0,c0,[]); axis(axs);grid on;ylabel(' ')
l1=get(ax,'Children'); set(l1,'MarkerFaceColor','b'); set(l1,'Color','black'); set(l1,'MarkerEdgeColor','black');
posi=get(ax,'position'); posi(3:4)=0.3*posi(3:4); posi(1:2)=posi(1:2)+0.99*[0.06,0.145]; ax2=axes('Position',posi);
h3=histogram(bind6,nbin,'FaceColor','b');grid on; axis([0 1.1 0 60]);
posi2=get(ax,'position'); posi2(3:4)=0.3*posi2(3:4); posi2(1:2)=posi2(1:2)+0.99*[0.005,0.145]; ax3=axes('Position',posi2);
p1=plot([1:1:nsamp],table2array(bmdl.Residuals(:,1)),'bs','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','b'); hold on; p2=plot([1:1:nsamp],zeros(1,nsamp),'w--'); ax3.YAxisLocation='right'; axis([0 nsamp -1 1]); ax3.XTick=[0 floor(nsamp/2) nsamp];

% %%%%

%% Unversal indicator kriging 
[X,Y]=meshgrid(linspace(0,cols,nsamp),linspace(0,rows,nsamp));

colornum=300;
rmap=zeros(colornum,3);rmap(:,1)=linspace(0,1,colornum);
gmap=zeros(colornum,3);gmap(:,2)=linspace(0,1,colornum);
bmap=zeros(colornum,3); bmap(:,3)=linspace(0,1,colornum);
figure
set(gcf,'numbertitle','off','name','Kriging')

%%%%
[rZhat,rZvar] = kriging(drstruct,x,y,r,X,Y);
[gZhat,gZvar] = kriging(dgstruct,x,y,g,X,Y);
[bZhat,bZvar] = kriging(dbstruct,x,y,b,X,Y);

ax = subplot(4,8,1);
     imagesc(X(1,:),Y(:,1),rZhat); axis image; axis xy; colormap(ax,rmap); title({['Kriging Predictions'];['n_i_n_d=n_s_a_m_p =',num2str(nsamp)]}); 
ax = subplot(4,8,9);
     imagesc(X(1,:),Y(:,1),gZhat); axis image; axis xy; colormap(ax,gmap); 
ax = subplot(4,8,17)
     imagesc(X(1,:),Y(:,1),bZhat); axis image; axis xy; colormap(ax,bmap); 
ax = subplot(4,8,25);
     krImg=cat(3,rZhat,gZhat,bZhat); imshow(krImg);  
%%%%
[rZhat1,rZvar1] = kriging(dr1struct,x,y,rind1,X,Y);
[gZhat1,gZvar1] = kriging(dg1struct,x,y,gind1,X,Y);
[bZhat1,bZvar1] = kriging(db1struct,x,y,bind1,X,Y);

ax = subplot(4,8,2);
     imagesc(X(1,:),Y(:,1),rZhat1); axis image; axis xy; colormap(ax,rmap); title({['Kriging Predictions'];['n_i_n_d=2']}); 
ax = subplot(4,8,10);
     imagesc(X(1,:),Y(:,1),gZhat1); axis image; axis xy; colormap(ax,gmap); 
ax = subplot(4,8,18)
     imagesc(X(1,:),Y(:,1),bZhat1); axis image; axis xy; colormap(ax,bmap); 
ax = subplot(4,8,26);
     krImg=cat(3,rZhat1,gZhat1,bZhat1); imshow(krImg); 
%%%%
[rZhat2,rZvar2] = kriging(dr2struct,x,y,rind2,X,Y);
[gZhat2,gZvar2] = kriging(dg2struct,x,y,gind2,X,Y);
[bZhat2,bZvar2] = kriging(db2struct,x,y,bind2,X,Y);

ax = subplot(4,8,3);
     imagesc(X(1,:),Y(:,1),rZhat2); axis image; axis xy; colormap(ax,rmap); title({['Kriging Predictions'];['n_i_n_d=3']}); 
ax = subplot(4,8,11);
     imagesc(X(1,:),Y(:,1),gZhat2); axis image; axis xy; colormap(ax,gmap); 
ax = subplot(4,8,19)
     imagesc(X(1,:),Y(:,1),bZhat2); axis image; axis xy; colormap(ax,bmap); 
ax = subplot(4,8,27);
     krImg=cat(3,rZhat2,gZhat2,bZhat2); imshow(krImg); 
%%%%
[rZhat3,rZvar3] = kriging(dr3struct,x,y,rind3,X,Y);
[gZhat3,gZvar3] = kriging(dg3struct,x,y,gind3,X,Y);
[bZhat3,bZvar3] = kriging(db3struct,x,y,bind3,X,Y);

ax = subplot(4,8,4);
     imagesc(X(1,:),Y(:,1),rZhat3); axis image; axis xy; colormap(ax,rmap); title({['Kriging Predictions'];['n_i_n_d=4']}); 
ax = subplot(4,8,12);
     imagesc(X(1,:),Y(:,1),gZhat3); axis image; axis xy; colormap(ax,gmap); 
ax = subplot(4,8,20)
     imagesc(X(1,:),Y(:,1),bZhat3); axis image; axis xy; colormap(ax,bmap); 
ax = subplot(4,8,28);
     krImg=cat(3,rZhat3,gZhat3,bZhat3); imshow(krImg); 
%%%%
[rZhat4,rZvar4] = kriging(dr4struct,x,y,rind4,X,Y);
[gZhat4,gZvar4] = kriging(dg4struct,x,y,gind4,X,Y);
[bZhat4,bZvar4] = kriging(db4struct,x,y,bind4,X,Y);

ax = subplot(4,8,5);
     imagesc(X(1,:),Y(:,1),rZhat4); axis image; axis xy; colormap(ax,rmap); title({['Kriging Predictions'];['n_i_n_d=5']}); 
ax = subplot(4,8,13);
     imagesc(X(1,:),Y(:,1),gZhat4); axis image; axis xy; colormap(ax,gmap); 
ax = subplot(4,8,21)
     imagesc(X(1,:),Y(:,1),bZhat4); axis image; axis xy; colormap(ax,bmap); 
ax = subplot(4,8,29);
     krImg=cat(3,rZhat4,gZhat4,bZhat4); imshow(krImg); 
%%%%
[rZhat5,rZvar5] = kriging(dr5struct,x,y,rind5,X,Y);
[gZhat5,gZvar5] = kriging(dg5struct,x,y,gind5,X,Y);
[bZhat5,bZvar5] = kriging(db5struct,x,y,bind5,X,Y);

ax = subplot(4,8,6);
     imagesc(X(1,:),Y(:,1),rZhat5); axis image; axis xy; colormap(ax,rmap); title({['Kriging Predictions'];['n_i_n_d=6']}); 
ax = subplot(4,8,14);
     imagesc(X(1,:),Y(:,1),gZhat5); axis image; axis xy; colormap(ax,gmap); 
ax = subplot(4,8,22)
     imagesc(X(1,:),Y(:,1),bZhat5); axis image; axis xy; colormap(ax,bmap); 
ax = subplot(4,8,30);
     krImg=cat(3,rZhat5,gZhat5,bZhat5); imshow(krImg); 
%%%%
[rZhat6,rZvar6] = kriging(dr6struct,x,y,rind6,X,Y);
[gZhat6,gZvar6] = kriging(dg6struct,x,y,gind6,X,Y);
[bZhat6,bZvar6] = kriging(db6struct,x,y,bind6,X,Y);

ax = subplot(4,8,7);
     imagesc(X(1,:),Y(:,1),rZhat6); axis image; axis xy; colormap(ax,rmap); title({['Kriging Predictions'];['n_i_n_d=10']}); 
ax = subplot(4,8,15);
     imagesc(X(1,:),Y(:,1),gZhat6); axis image; axis xy; colormap(ax,gmap); 
ax = subplot(4,8,23)
     imagesc(X(1,:),Y(:,1),bZhat6); axis image; axis xy; colormap(ax,bmap); 
ax = subplot(4,8,31);
     krImg=cat(3,rZhat6,gZhat6,bZhat6); imshow(krImg);