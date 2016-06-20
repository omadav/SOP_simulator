clear all
clc

%////////////////////////////////// DEFINICI�N DE PAR�METROS GLOBALES ///////////////////////////////////////////////

fprintf('\n Ingrese la cantidad de CS a utilizar en el experimento: \n ');  % cantidad total de CS a utilizar en todo el experimento
nCSexp=input('nCSexp:');

fprintf('\n A continuaci�n debe definir los par�metros de cada CS \n ');   

% PAR�METROS PARA CADA CS
[Tp1cs, Tp2cs, TpIcs]=paramCSsop(nCSexp);  % paramCSsop es la funci�n que permite llenar los par�metros principales de cada CS (tantos seg�n indique el valor nCSexp)

fprintf('\n A continuaci�n debe definir los par�metros del US \n ');

% PAR�METROS PARA EL US
[p1us, p2us, pIus]=paramUSsop();  % paramUSsop es la funci�n que permite llenar los par�metros principales del US

% CANTIDAD DE FASES DEL EXPERIMENTO
fprintf('\n Ingrese el n�mero de fases que tendr� el experimento: \n ');
numero_fases=input('fases:');

% CANTIDAD DE TIPOS DE ENSAYOS POR CADA FASE
for i=1:numero_fases
   fprintf('\n Ingrese la cantidad de tipos de ensayos que tendr� la fase %d: \n ',i); 
   tipos_exp_fase(i)=input('');    % esta variable guarda la cantidad de tipos de ensayos que tendr� la fase "i" 
end

Lmas=0.01;
Lmenos=0.002;     % Lmas y Lmenos par�metros fijos

%///////////////////////// DEFINICI�N DE PAR�METROS QUE DAN FORMA A CADA TIPO DE ENSAYO //////////////////////////

for f=1:numero_fases   % ac� quedan indexadas todas las entradas por los �ndices (fase, tipo de ensayo)
    for t=1:tipos_exp_fase(f)
        [Ne(f,t), largo(f,t), nCS(f,t), CS_cell{f,t}, A1cs_cell{f,t}, A2cs_cell{f,t}, Ics_cell{f,t}, p1cs_cell{f,t}, p2cs_cell{f,t}, pIcs_cell{f,t}, p2aux_cell{f,t},...
            p2_cell{f,t}, US_cell{f,t}, A1us_cell{f,t}, A2us_cell{f,t}, Ius_cell{f,t}, n_cell{f,t}]=tipo_exp(f,t,Tp1cs, Tp2cs, TpIcs);
    end
end

%////////////////////////////// DESARROLLO DEL PROGRAMA ////////////////////////////////////////////////////////////////////

% programa en orden predeterminado
for p=1:nCSexp
    for r=1:numero_fases
        Vtipo_exp(p,r,1)=0;    % Vtipo_exp(cs, fase, tipo_ensayo)
    end
end

for f=1:numero_fases
    for t=1:tipos_exp_fase(f)
        CS=[CS_cell{f,t}];    
        A1cs=[A1cs_cell{f,t}];
        A2cs=[A2cs_cell{f,t}];
        Ics=[Ics_cell{f,t}];
        p1cs=[p1cs_cell{f,t}];
        p2cs=[p2cs_cell{f,t}];
        pIcs=[pIcs_cell{f,t}];
        p2aux=[p2aux_cell{f,t}];
        p2=[p2_cell{f,t}];
        US=[US_cell{f,t}];
        A1us=[A1us_cell{f,t}];
        A2us=[A2us_cell{f,t}];
        Ius=[Ius_cell{f,t}];
        n=[n_cell{f,t}];
        for p=1:nCS(f,t)             % nCS: n�mero de CS a utilizar en el presente bloque
              Vmas(p,1,1)=0;         % (CS, ensayo, tiempo) 
              Vmenos(p,1,1)=0;
              V(p,1,1)=0; 
        end
        for p=1:nCS(f,t)
            Vf(p,1)=Vtipo_exp(n(p),f,t);
        end
        [Vf_cell{f,t}, V_cell{f,t}, Ve_cell{f,t}]=desarrollo(f, t, Ne(f,t), largo(f,t), nCS(f,t), CS, A1cs, A2cs, Ics, p1cs, p2cs, pIcs, p2aux, Vf, p2, US, A1us, A2us, Ius, p1us, p2us, pIus, V, Lmas, Lmenos);
        Vf=[Vf_cell{f,t}];                        % Las variables cell que aparecen en la salida de la funci�n desarrollo tienen la �nica funci�n de mostrar cosas en pantalla, salvo Vf
        for i=1:nCS(f,t)
           Vtipo_exp(n(i),f,t)=Vf(i,Ne(f,t)+1); 
           Vtipo_exp(n(i),f,t+1)=Vtipo_exp(n(i),f,t);
        end
    end
    for j=1:nCS(f,t)
       Vtipo_exp(n(j),f+1,1)=Vtipo_exp(n(j),f,t+1);     % por esta instrucci�n (espec�ficamente por f+1 y t+1 en los �ltimos valores del loop) es que
    end                                                 % el vector Vtipo_exp da una dimensi�n m�s tanto en la coordenada fase como en la coordenada tipo de exp.
end                                                     % Esto se corrige abajo, definiendo una nueva variable que contenga los resultados

for i=1:numero_fases                                        % Rutina para visualizar los resultados correspondientes a cada CS, por fase y por tipo de ensayo
V_fase_tipo{i}=Vtipo_exp(:,i,1:tipos_exp_fase(i));          % visualizar por fase: V_fase_tipo{1,fase}  
end                                                         % si la fase tiene m�s de un tipo de exp: V_fase_tipo{1,fase}(:,tipo_exp)



















