function [p1, p2, pI]=paramCSsop(ncs)

for p=1:ncs
fprintf('\n ingrese los parámetros del estímulo %d: \n ',p);    
p1(p)=input('p1:');      %0.1
p2(p)=input(' p2:');      %0.02;           
pI(p)=input(' pI:');      %0.1;

end