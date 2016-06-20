function [A1, A2, I]=dinamica(a1,a2,i,p1,p2,pi,p)
   A1=a1+pi*i-p1*a1;
   A2=a2+p1*a1-p2*a2+p*i;
   I=i+p2*a2-pi*i-p*i;  
   