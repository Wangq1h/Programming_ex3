b=3.2;
s=6.8;
sigma=3;
lambda=5;
N=poissrnd(lambda,[1,1000000]);
sig=0;
for i=1:1000000
    n=N(i);
    tlo=tinv(0.05,n-1);
    tup=-tlo;
    T=normrnd(s+b,sigma,[1,n]);
    Tbar=mean(T);
    TS=var(T,0);
    CLlo=Tbar+TS/n^(1/2)*tlo;
    CLup=Tbar+TS/n^(1/2)*tup;
    if CLlo<=s+b&CLup>=s+b
        sig=sig+1;
    end
    clear T
end
%%
S=0.1:0.1:20;
b=3.2;
lambda=5;
sigma=3;
N=poissrnd(lambda,[1,1000000]);
for j=1:length(S)
    s=S(j);
    sig=0;
    for i=1:1000000
        n=N(i);
        tlo=tinv(0.05,n-1);
        tup=-tlo;
        T=normrnd(s+b,sigma,[1,n]);
        Tbar=mean(T);
        TS=var(T,0);
        CLlo=Tbar+TS/n^(1/2)*tlo;
        CLup=Tbar+TS/n^(1/2)*tup;
        if CLlo<=s+b&CLup>=s+b
            sig=sig+1;
        end
        clear T
    end
    p(j)=sig/1000000;
end
save('Cover Probablity.mat','p')