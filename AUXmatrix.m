function AUX=AUXmatrix(l,C,D,I,T)

cont=0;

for k=1:C+1
    if k==1
         Iaux(k)=0;
    else
         Iaux(k)=I;
    end
end

for t=1:l
    if cont<C
        if  t>=T+cont*Iaux(cont+1)+cont*D  & t<T+cont*Iaux(cont+1)+(cont+1)*D
                 AUX(t)=1;
                     if t==T+cont*Iaux(cont+1)+(cont+1)*D-1
                          cont=cont+1;
                     end
                 else
                     AUX(t)=0;
                 end             
    else 
        AUX(t)=0;
    end
end
%plot(CS)
