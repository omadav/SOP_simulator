clear all
clc

%////////////////////////////////// DEFINICIÓN DE PARÁMETROS GLOBALES ///////////////////////////////////////////////

fprintf('\n Ingrese la cantidad de CS a utilizar en el experimento: \n ');  % cantidad total de CS a utilizar en todo el experimento
nCSexp=input('nCSexp:');

fprintf('\n A continuación debe definir los parámetros de cada CS \n ');   

% PARÁMETROS PARA CADA CS
[Tp1cs, Tp2cs, TpIcs]=paramCSsop(nCSexp);  % paramCSsop es la función que permite llenar los parámetros principales de cada CS (tantos según indique el valor nCSexp)

fprintf('\n A continuación debe definir los parámetros del US \n ');

% PARÁMETROS PARA EL US
[p1us, p2us, pIus]=paramUSsop();  % paramUSsop es la función que permite llenar los parámetros principales del US

% CANTIDAD DE FASES DEL EXPERIMENTO
fprintf('\n Ingrese el número de fases que tendrá el experimento: \n ');
numero_fases=input('fases:');

% CANTIDAD DE TIPOS DE ENSAYOS POR CADA FASE
for i=1:numero_fases
   fprintf('\n Ingrese la cantidad de tipos de ensayos que tendrá la fase %d: \n ',i); 
   tipos_exp_fase(i)=input('');    % esta variable guarda la cantidad de tipos de ensayos que tendrá la fase "i" 
end

Lmas=0.01;
Lmenos=0.002;     % Lmas y Lmenos parámetros fijos

%///////////////////////// DEFINICIÓN DE PARÁMETROS QUE DAN FORMA A CADA TIPO DE ENSAYO //////////////////////////

for f=1:numero_fases   % acá quedan indexadas todas las entradas por los índices (fase, tipo de ensayo)
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
        for p=1:nCS(f,t)             % nCS: número de CS a utilizar en el presente bloque
              Vmas(p,1,1)=0;         % (CS, ensayo, tiempo) 
              Vmenos(p,1,1)=0;
              V(p,1,1)=0; 
        end
        for p=1:nCS(f,t)
            Vf(p,1)=Vtipo_exp(n(p),f,t);
        end
        [Vf_cell{f,t}, V_cell{f,t}, Ve_cell{f,t}]=desarrollo(f, t, Ne(f,t), largo(f,t), nCS(f,t), CS, A1cs, A2cs, Ics, p1cs, p2cs, pIcs, p2aux, Vf, p2, US, A1us, A2us, Ius, p1us, p2us, pIus, V, Lmas, Lmenos);
        Vf=[Vf_cell{f,t}];                        % Las variables cell que aparecen en la salida de la función desarrollo tienen la única función de mostrar cosas en pantalla, salvo Vf
        for i=1:nCS(f,t)
           Vtipo_exp(n(i),f,t)=Vf(i,Ne(f,t)+1); 
           Vtipo_exp(n(i),f,t+1)=Vtipo_exp(n(i),f,t);
        end
    end
    for j=1:nCS(f,t)
       Vtipo_exp(n(j),f+1,1)=Vtipo_exp(n(j),f,t+1);     % por esta instrucción (específicamente por f+1 y t+1 en los últimos valores del loop) es que
    end                                                 % el vector Vtipo_exp da una dimensión más tanto en la coordenada fase como en la coordenada tipo de exp.
end                                                     % Esto se corrige abajo, definiendo una nueva variable que contenga los resultados

for i=1:numero_fases                                        % Rutina para visualizar los resultados correspondientes a cada CS, por fase y por tipo de ensayo
V_fase_tipo{i}=Vtipo_exp(:,i,1:tipos_exp_fase(i));          % visualizar por fase: V_fase_tipo{1,fase}  
end                                                         % si la fase tiene más de un tipo de exp: V_fase_tipo{1,fase}(:,tipo_exp)



















