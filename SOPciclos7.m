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

%////////////////////////////////////////////////////////////////////////////////////////////////////////////////

% DEFINO CANTIDAD DE CICLOS POR FASE, Y SU LARGO
for f=1:numero_fases
    fprintf('\n Ingrese la cantidad de ciclos que tendrá la fase %d: \n ',f);
    n_ciclos(f)=input('');    % esta variable guarda la cantidad de ciclos que tendrá la fase "f"
    fprintf('\n ¿De largo fijo o variable? (fijo=0/variable=1) \n');
    fijo_o_var(f)=input(''); 
    if fijo_o_var(f)==0
        fprintf('\n Defina el largo: \n');
        largo_const(f)=input('');
        for c=1:n_ciclos(f)
            largo_ciclo(f,c)=largo_const(f);
        end
    elseif fijo_o_var(f)==1
        for c=1:n_ciclos(f)
           fprintf('\n Ingrese el largo que tendrá el ciclo %d de la fase %d: \n ',c,f);
           largo_ciclo(f,c)=input('');
        end
    end
end

%////////////////////////////// DESARROLLO DEL PROGRAMA ////////////////////////////////////////////////////////////////////

for p=1:nCSexp
    Vtipo_exp(p,1,1,1)=0;    % Vtipo_exp(cs, fase, ciclo, tipo_ensayo)
end

for f=1:numero_fases   %fase
    for c=1:n_ciclos(f)   %ciclo
        if fijo_o_var(f)==0
            fprintf('\n Defina el orden en que desea disponer los tipos de ensayos dentro del ciclo %d de la fase %d: \n',c,f);
            for l=1:largo_const(f)
                fprintf('\n Tipo de ensayo %d: ',l);
                C(l)=input('');
            end
        elseif fijo_o_var(f)==1   
            C=randperm(tipos_exp_fase(f), largo_ciclo(f,c));
        end
        for t=1:largo_ciclo(f,c) %tipo de ensayo del ciclo c
            CS=[CS_cell{f,C(t)}];    
            A1cs=[A1cs_cell{f,C(t)}];
            A2cs=[A2cs_cell{f,C(t)}];
            Ics=[Ics_cell{f,C(t)}];
            p1cs=[p1cs_cell{f,C(t)}];
            p2cs=[p2cs_cell{f,C(t)}];
            pIcs=[pIcs_cell{f,C(t)}];
            p2aux=[p2aux_cell{f,C(t)}];
            p2=[p2_cell{f,C(t)}];
            US=[US_cell{f,C(t)}];
            A1us=[A1us_cell{f,C(t)}];
            A2us=[A2us_cell{f,C(t)}];
            Ius=[Ius_cell{f,C(t)}];
            n=[n_cell{f,C(t)}];
            for p=1:nCS(f,C(t))             % nCS: número de CS a utilizar en el presente tipo de ensayo
                Vmas(p,1,1)=0;              % (CS, ensayo, tiempo) 
                Vmenos(p,1,1)=0;
                V(p,1,1)=0; 
            end
            if (f==1) && (c==1) && (t==1)
                for p=1:nCSexp
                    Vf(p,1)=0;
                end
            end
            [Vf_cell{f,c,t}, V_cell{f,c,t}, Ve_cell{f,c,t}]=desarrollo(f, C(t), Ne(f,C(t)), largo(f,C(t)), nCS(f,C(t)), CS, A1cs, A2cs, Ics, p1cs, p2cs, pIcs, p2aux, Vf, p2, US, A1us, A2us, Ius, p1us, p2us, pIus, V, Lmas, Lmenos,n);
            Vf=[Vf_cell{f,c,t}];          % Las variables cell que aparecen en la salida de la función desarrollo tienen la única función de mostrar cosas en pantalla, salvo Vf
            for l=1:nCSexp
                V0_aux(l)=Vf(l,1);        % Valor auxiliar para que no se pierda el valor acumulado del CS que no varía 
            end
            for i=1:nCS(f,C(t))                
                Vtipo_exp(n(i),f,c,t)=Vf(n(i),Ne(f,C(t))+1); 
                Vtipo_exp(n(i),f,c,t+1)=Vtipo_exp(n(i),f,c,t);
            end   
            clearvars Vf;
            for p=1:nCSexp
                Vf(p,1)=V0_aux(p);
            end
            for p=1:nCS(f,C(t))
                Vf(n(p),1)=Vtipo_exp(n(p),f,c,t);
            end
            Nensayo{f,c,t}=Ne(f,C(t));         % Esto lo pido, pues lo uso en la parte de resultados, no acá.
            Largo_res{f,c,t}=largo(f,C(t));    % Esto lo pido, pues lo uso en la parte de resultados, no acá.
            Numero_cs{f,c,t}=nCS(f,C(t));      % Esto lo pido, pues lo uso en la parte de resultados, no acá.
            N_cs{f,c,t}=n;                     % Esto lo pido, pues lo uso en la parte de resultados, no acá.
        end
        for j=1:nCS(f,C(t))
            Vtipo_exp(n(j),f,c+1,1)=Vtipo_exp(n(j),f,c,t+1);     
        end                                                      
    end
    for j=1:nCS(f,C(t))
        Vtipo_exp(n(j),f+1,1,1)=Vtipo_exp(n(j),f,c+1,1);     
    end  
end

%///////////////////////////////////////// RESULTADOS ////////////////////////////////////////////////////////////////////

% V PARA CADA CS, EN CADA FASE
for f=1:numero_fases
    V_cs_fase(:,f)=Vtipo_exp(:,f,n_ciclos(f),largo_ciclo(f,n_ciclos(f)));
end

% GRÁFICO DE V POR CADA CS, EN CADA FASE
for p=1:nCSexp
    est(p)=p;
    estimulo{p}=char(est(p)-1+'A');
end
for f=1:numero_fases
    fase{f}=['fase' num2str(f)];
end
bar(V_cs_fase,'group'),title('Resultados por fase')
set(gca,'Xticklabel',estimulo);
legend(fase)
ylabel('Fuerza asociativa')
xlabel('Estímulo')

%%%%%%%%%%%%%%%%%%%%%%% CREACIÓN DE UNA CARPETA DE RESULTADOS %%%%%%%%%%%%%%%%%%%%

%Obtener el Path de la carpeta Actual
[stat,struc] = fileattrib;
PathCurrent = struc.Name;
 
%PREGUNTO SI LA CARPETA DE RESULTADOS YA ESTÁ CREADA
tf = isdir([PathCurrent '/RESULTADOS']);
if tf==1
    rmdir([PathCurrent '/RESULTADOS'],'s');
end

for f=1:numero_fases
    for c=1:n_ciclos(f)
        for t=1:largo_ciclo(f,c)
            FolderName=['Fase ' num2str(f) ' Ciclo ' num2str(c) ' Tipo de ensayo ' num2str(t)];
            PathFolder=[PathCurrent '/RESULTADOS/' FolderName];   
            Nameexcel1=[PathFolder '/resultados1.xls'];
            Nameexcel2=[PathFolder '/resultados2.xls'];
            % crear las carpetas para guardar los resultados
             mkdir([PathCurrent '/RESULTADOS'], FolderName);   
             for i=1:nCSexp
                CANT_CS{i}=['CS ' num2str(i)];
             end
             for j=1:Nensayo{f,c,t}+1               % Este es para los V en cada ensayo
                 Ens1{j}=['Ensayo ' num2str(j)];
             end
             
             for i=1:Largo_res{f,c,t}+1
                Time{i}=['t= ' num2str(i)];
             end
             
             for j=1:Nensayo{f,c,t}                 % Este es para los V en cada ensayo y cada tiempo
                 Ens2{j}=['Ensayo ' num2str(j)];
             end
             warning('off', 'all')
             xlswrite(Nameexcel1,'V','Fuerzas asociativas','A1');
             xlswrite(Nameexcel1,CANT_CS','Fuerzas asociativas','A2');
             xlswrite(Nameexcel1,Ens1,'Fuerzas asociativas','B1');
             xlswrite(Nameexcel1,Vf_cell{f,c,t},'Fuerzas asociativas','B2');
             for l=1:Numero_cs{f,c,t}
                 xlswrite(Nameexcel2,'V',['CS ' num2str(N_cs{f,c,t}(l))],'A1');
                 xlswrite(Nameexcel2,Ens2',['CS ' num2str(N_cs{f,c,t}(l))],'A2');
                 xlswrite(Nameexcel2,Time,['CS ' num2str(N_cs{f,c,t}(l))],'B1');
                 MAT_AUX(:,:)=V_cell{f,c,t}(N_cs{f,c,t}(l),:,:);
                 xlswrite(Nameexcel2,MAT_AUX,['CS ' num2str(N_cs{f,c,t}(l))],'B2');
                 clearvars MAT_AUX;
             end
             clearvars Ens1 Ens2 Time;
        end
    end
end
