function [A1,A2,I, C, D, T, Int]=paramCStipo_exp(ncs,ne)

for p=1:ncs 
    for k=1:ne
        A1(p,k,1)=0;        %(cs, ensayo, tiempo)
        A2(p,k,1)=0;
        I(p,k,1)=1;
    end

fprintf('\n ingrese la cantidad de activaciones del CS %d: \n ',p);
C(p)=input('C_actCS:');    % cantidad de veces que se activará el CS   (ESTAS TRES COSAS DEBERÁN IR DESPUÉS ENLA PARTE DE PARÁMETROS DEL CS)

fprintf('\n ingrese la duración de la presentación del CS %d: \n ',p);
D(p)=input('D_actCS:');    % duración CS activo (ojo que duración de 20 instantes significa que el cs está activo hasta el instante 21)

fprintf('\n ingrese el instante en que será presentado por primera vez el CS %d: \n ',p);
T(p)=input('T_actCS:');    % instante en que se presenta CS por primera vez (se activa en t=1, pero el efecto se refleja en t=2)

fprintf('\n ingrese el largo del intervalo entre presentaciones del CS %d: \n ',p);
Int(p)=input('I_actCS:');  % intervalo entre dos presentaciones del CS (SÓLO SI SE PRESENTA MÁS DE UNA VEZ)

end
