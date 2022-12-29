cat=cell(1,7);
for i=1:7
    str=['mgg_cms2020_cat',num2str(i-1),'.txt'];
    cat(i)={load(str)};
end
parameter=readmatrix('数据和模型.xlsx');
%%
syms c m
P=int(c*m^(-4.5),m,100,180);
c=double(solve(P==1,c));
%%
Sigma=parameter(:,3);
Ns=parameter(:,2);
Nb=parameter(:,4);
N=Ns+Nb;
M=100:.01:180;
f1=figure;
f1.Position=([0,0,2000,2000]);
for k=1:7
    sj=cat{k};
    sigma=Sigma(k);
    ns=Ns(k);
    nb=Nb(k);
    n=N(k);
    lnLk=0;
    for j=1:length(M)
        m=M(j);
        for i=1:length(sj)
            lnLk=lnLk+log(ns/n*1/(2*pi*sigma^2)^(1/2).*exp(-(sj(i)-m).^2./(2*sigma^2))+nb/n*c.*sj(i).^(-4.5));
        end
        siran(j)=lnLk;
        lnLk=0;
    end
    subplot(3,3,k)
    plot(M,siran)
    xlabel('m')
    ylabel('Likelihood function logarithmic values')
    Tit=['The ',num2str(k),'th category'];
    save([Tit,'.mat'],'siran')
    title(Tit)
    hatm=M(find(siran==max(siran)));
    Hatm(k)=hatm;
end
%%
f2=figure;
f2.Position=([0,0,2000,2000]);
for k=1:7
    sj=cat{k};
    sigma=Sigma(k);
    ns=Ns(k);
    nb=Nb(k);
    n=N(k);
    lnLk=0;
    m=Hatm(k);
    for i=1:length(sj)
        lnLk=lnLk+log(ns/n*1/(2*pi*sigma^2)^(1/2).*exp(-(sj(i)-m).^2./(2*sigma^2))+nb/n*c.*sj(i).^(-4.5));
    end
    pred=lnLk;
    Tit=['The',num2str(k),'th category'];
    load([Tit,'.mat'])
    noname=2.*(pred-siran);
    subplot(3,3,k)
    M=100:.01:180;
    plot(M,noname)
    xlabel('m')
    ylabel('lnL')
    Tit=['The ',num2str(k),'th category'];
    title(Tit);
    ylim([0,4.5]);
    jidian=find(M==m);
    if k~=6
        CLmin(k)=M(find(abs(noname(1:jidian)-1)==min(abs(noname(1:jidian)-1))));
        CLmax(k)=M(find(abs(noname(jidian:end)-1)==min(abs(noname(jidian:end)-1)))-1+jidian);
    elseif k==6
        left=find(M==126);right=find(M==128);
        CLmin(k)=M(find(abs(noname(left:right)-1)==min(abs(noname(left:right)-1)))-1+left);
        CLmax(k)=M(find(abs(noname(right:end)-1)==min(abs(noname(right:end)-1)))-1+right);
    end
end
%% 精细求解hatm
for k=1:7
    sj=cat{k};
    sigma=Sigma(k);
    ns=Ns(k);
    nb=Nb(k);
    n=N(k);
    M=Hatm(k)-0.01:0.0001:Hatm(k)+0.01;
    lnLk=0;
    for j=1:length(M)
        m=M(j);
        for i=1:length(sj)
            lnLk=lnLk+log(ns/n*1/(2*pi*sigma^2)^(1/2).*exp(-(sj(i)-m).^2./(2*sigma^2))+nb/n*c.*sj(i).^(-4.5));
        end
        siran(j)=lnLk;
        lnLk=0;
    end
    PreciseHatm(k)=M(find(siran==max(siran)));
    clear siran
end
%% 精细求解置信区端点
for k=1:7
    sj=cat{k};
    sigma=Sigma(k);
    ns=Ns(k);
    nb=Nb(k);
    n=N(k);
    M=CLmin(k)-0.01:0.0001:CLmin(k)+0.01;
    lnLk=0;
    for j=1:length(M)
        m=M(j);
        for i=1:length(sj)
            lnLk=lnLk+log(ns/n*1/(2*pi*sigma^2)^(1/2).*exp(-(sj(i)-m).^2./(2*sigma^2))+nb/n*c.*sj(i).^(-4.5));
        end
        siran(j)=lnLk;
        lnLk=0;
    end
    lnLk=0;
    m=PreciseHatm(k);
    for i=1:length(sj)
        lnLk=lnLk+log(ns/n*1/(2*pi*sigma^2)^(1/2).*exp(-(sj(i)-m).^2./(2*sigma^2))+nb/n*c.*sj(i).^(-4.5));
    end
    pred=lnLk;
    noname=2.*(pred-siran);
    PreciseCLmin(k)=M(find(abs(noname-1)==min(abs(noname-1))));
end
for k=1:7
    sj=cat{k};
    sigma=Sigma(k);
    ns=Ns(k);
    nb=Nb(k);
    n=N(k);
    M=CLmax(k)-0.01:0.0001:CLmax(k)+0.01;
    lnLk=0;
    for j=1:length(M)
        m=M(j);
        for i=1:length(sj)
            lnLk=lnLk+log(ns/n*1/(2*pi*sigma^2)^(1/2).*exp(-(sj(i)-m).^2./(2*sigma^2))+nb/n*c.*sj(i).^(-4.5));
        end
        siran(j)=lnLk;
        lnLk=0;
    end
    lnLk=0;
    m=PreciseHatm(k);
    for i=1:length(sj)
        lnLk=lnLk+log(ns/n*1/(2*pi*sigma^2)^(1/2).*exp(-(sj(i)-m).^2./(2*sigma^2))+nb/n*c.*sj(i).^(-4.5));
    end
    pred=lnLk;
    noname=2.*(pred-siran);
    PreciseCLmax(k)=M(find(abs(noname-1)==min(abs(noname-1))));
end
%%
f3=figure;
f3.Position=([0,0,2000,2000]);
Unit=zeros(1,8001);
M=100:.01:180;
for k =1:7
    Tit=['The',num2str(k),'th category'];
    load([Tit,'.mat']);
    Unit=Unit+siran;
end
plot(M,Unit)
xlabel('m')
ylabel('lnL')
Tit='United likelihood function logarithmic values';
save([Tit,'.mat'],'Unit')
title(Tit)
unitedhatm=M(find(Unit==max(Unit)));
%%
f4=figure;
f4.Position=([0,0,2000,2000]);
pred=Unit(find(Unit==max(Unit)));
load([Tit,'.mat'])
noname=2.*(pred-Unit);
M=100:.01:180;
plot(M,noname)
xlabel('m')
ylabel('lnL')
title(Tit)
ylim([0,4.5])
jidian=find(Unit==max(Unit));
unitedCLmin=M(find(abs(noname(1:jidian)-1)==min(abs(noname(1:jidian)-1))));
unitedCLmax=M(find(abs(noname(jidian:end)-1)==min(abs(noname(jidian:end)-1)))-1+jidian);
%% Updated
sj=[];
for i=1:7
    sj=[sj,cat{i}'];
end
Sigma=parameter(:,3);
Ns=parameter(:,2);
Nb=parameter(:,4);
N=Ns+Nb;
sigma=(sum(Ns.*Sigma.^2)/sum(Ns))^(1/2);
fs=sum(Ns)/sum(N);
fb=sum(Nb)/sum(N);
M=100:.01:180;
f5=figure;
f5.Position=([0,0,2000,2000]);
lnLk=0;
for j=1:length(M)
    m=M(j);
    for i=1:length(sj)
        lnLk=lnLk+log(fs*1/(2*pi*sigma^2)^(1/2).*exp(-(sj(i)-m).^2./(2*sigma^2))+fb*c.*sj(i).^(-4.5));
    end
    siran(j)=lnLk;
    lnLk=0;
end
plot(M,siran)
xlabel('m')
ylabel('lnL')
Tit='Total likelihood function logarithmic values';
%save([Tit,'.mat'],'siran')
title(Tit)
Totalhatm=M(find(siran==max(siran)));
%%
f6=figure;
f6.Position=([0,0,2000,2000]);
pred=max(siran);
noname=2.*(pred-siran);
M=100:.01:180;
plot(M,noname)
xlabel('m')
ylabel('lnL')
title(Tit)
ylim([0,4.5])
jidian=find(siran==max(siran));
TotalCLmin=M(find(abs(noname(1:jidian)-1)==min(abs(noname(1:jidian)-1))));
TotalCLmax=M(find(abs(noname(jidian:end)-1)==min(abs(noname(jidian:end)-1)))-1+jidian);