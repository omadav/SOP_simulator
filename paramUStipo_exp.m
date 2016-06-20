function [A1,A2,I, C, D, T, Int]=paramUStipo_exp(ne)

for k=1:ne
A1(k,1)=0;
A2(k,1)=0;
I(k,1)=1;
end

fprintf('\n ingrese la cantidad de activaciones del US : \n ');
C=input('C_actUS:');    % cantidad de veces que se activará el US   

fprintf('\n ingrese la duración de la presentación del US : \n ');
D=input('D_actUS:');    % duración US activo 

fprintf('\n ingrese el instante en que será presentado por primera vez el US: \n ');
T=input('T_actUS:');    % instante en que se presenta US por primera vez (se activa en t=1, pero el efecto se refleja en t=2)

fprintf('\n ingrese el largo del intervalo entre presentaciones del US : \n ');
Int=input('I_actUS:');  % intervalo entre dos presentaciones del US 