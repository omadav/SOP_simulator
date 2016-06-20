function [Ne_f, largo_f, nCS_f, CS_f, A1cs_f, A2cs_f, Ics_f, p1cs_f, p2cs_f, pIcs_f, p2aux_f, p2_f, US_f, A1us_f, A2us_f, Ius_f, N]=tipo_exp(i,j,Tp1,Tp2,TpI)

fprintf('\n Complete los par�metros correspondientes al tipo de ensayo %d de la fase %d: \n ',j,i);

fprintf('\n Ingrese la cantidad de ensayos: \n ');
Ne_f=input('Ne:');

fprintf('\n Ingrese el largo que tendr� cada ensayo: \n ');
largo_f=input('largo:');

fprintf('\n A continuaci�n debe ingresar par�metros detallados del US: \n ');   
% PAR�METROS PARA EL US
[A1us_f, A2us_f, Ius_f, C_actUS, D_actUS, T_actUS, I_actUS]=paramUStipo_exp(Ne_f);

fprintf('\n Ingrese la cantidad de CS a utilizar: \n '); 
nCS_f=input('nCS:');
 
p2_f(1,1)=0;        % LA TASA p2 QUE APARECE DESPU�S DEL PRIMER ENSAYO, producto de la suma de los p2 generados por cada CS

fprintf('\n A continuaci�n debe se�alar cual(es) de los CS originales usar� en este tipo de ensayo, indicando su n�mero: \n '); 
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

fprintf('\n A continuaci�n debe ingresar par�metros detallados para los CS escogidos \n ');   
% PAR�METROS PARA CADA CS
[A1cs_f, A2cs_f, Ics_f, C_actCS, D_actCS, T_actCS, I_actCS]=paramCStipo_exp(nCS_f, Ne_f);

% Definici�n de matrices auxiliares para cada CS
for p=1:nCS_f
    CS_f(p,:)=AUXmatrix(largo_f,C_actCS(p),D_actCS(p),I_actCS(p),T_actCS(p));  % matrices de unos y ceros que indican si el CS est� o no activo, respectivamente.
end
    
% Definici�n de matriz auxiliar para el US
US_f=AUXmatrix(largo_f,C_actUS,D_actUS,I_actUS,T_actUS); 



    
    
    
    
    
    
    
    