b=3.2;
s=6.8;
lambda=s+b;
N=poissrnd(lambda,[1,1000000]);
Bsig=0;
Fsig=0;
for i=1:length(N)
    n=N(i);
    p=1-0.1*(1-chi2cdf(2*b,2*(n+1)));
    BCLup=1/2*chi2inv(p,2*(n+1))-b;
    FCLup=1/2*chi2inv(0.9,2*(n+1))-b;
    if BCLup>=s
        Bsig=Bsig+1;
    end
    if FCLup>=s
        Fsig=Fsig+1;
    end
end
%%
S=0.1:0.1:20;
b=3.2;
for j=1:length(S)
    s=S(j);
    lambda=s+b;
    N=poissrnd(lambda,[1,1000000]);
    Bsig=0;
    Fsig=0;
    for i=1:length(N)
        n=N(i);
        p=1-0.1*(1-chi2cdf(2*b,2*(n+1)));
        BCLup=1/2*chi2inv(p,2*(n+1))-b;
        FCLup=1/2*chi2inv(0.9,2*(n+1))-b;
        if BCLup>=s
            Bsig=Bsig+1;
        end
        if FCLup>=s
            Fsig=Fsig+1;
        end
    end
    p1(j)=Bsig/1000000;
    p2(j)=Fsig/1000000;
end
save('Byes Cover Probablity.mat','p1')
save('Frequency Cover Probablity.mat','p2')