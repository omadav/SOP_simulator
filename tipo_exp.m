function [Ne_f, largo_f, nCS_f, CS_f, A1cs_f, A2cs_f, Ics_f, p1cs_f, p2cs_f, pIcs_f, p2aux_f, p2_f, US_f, A1us_f, A2us_f, Ius_f, N]=tipo_exp(i,j,Tp1,Tp2,TpI)

fprintf('\n Complete los parámetros correspondientes al tipo de ensayo %d de la fase %d: \n ',j,i);

fprintf('\n Ingrese la cantidad de ensayos: \n ');
Ne_f=input('Ne:');

fprintf('\n Ingrese el largo que tendrá cada ensayo: \n ');
largo_f=input('largo:');

fprintf('\n A continuación debe ingresar parámetros detallados del US: \n ');   
% PARÁMETROS PARA EL US
[A1us_f, A2us_f, Ius_f, C_actUS, D_actUS, T_actUS, I_actUS]=paramUStipo_exp(Ne_f);

fprintf('\n Ingrese la cantidad de CS a utilizar: \n '); 
nCS_f=input('nCS:');
 
p2_f(1,1)=0;        % LA TASA p2 QUE APARECE DESPUÉS DEL PRIMER ENSAYO, producto de la suma de los p2 generados por cada CS

fprintf('\n A continuación debe señalar cual(es) de los CS originales usará en este tipo de ensayo, indicando su número: \n '); 
    for l=1:nCS_f
        fprintf('\n CS %d:',l); 
        N(l)=input('');
        p1cs_f(l)=Tp1(N(l));
        p2cs_f(l)=Tp2(N(l));
        pIcs_f(l)=TpI(N(l));
    end
    
for h=1:nCS_f
        p2aux_f(h,1,1)=0;    % FICTICIO (CS, ensayo, tiempo)
end

fprintf('\n A continuación debe ingresar parámetros detallados para los CS escogidos \n ');   
% PARÁMETROS PARA CADA CS
[A1cs_f, A2cs_f, Ics_f, C_actCS, D_actCS, T_actCS, I_actCS]=paramCStipo_exp(nCS_f, Ne_f);

% Definición de matrices auxiliares para cada CS
for p=1:nCS_f
    CS_f(p,:)=AUXmatrix(largo_f,C_actCS(p),D_actCS(p),I_actCS(p),T_actCS(p));  % matrices de unos y ceros que indican si el CS está o no activo, respectivamente.
end
    
% Definición de matriz auxiliar para el US
US_f=AUXmatrix(largo_f,C_actUS,D_actUS,I_actUS,T_actUS); 



    
    
    
    
    
    
    
    