function [Vf_d, V_d, Ve_d]=desarrollo(l,k,Ne_d,largo_d,nCS_d,CS_d,A1cs_d,A2cs_d,Ics_d,p1cs_d,p2cs_d,pIcs_d,p2aux_d,Vf_d,p2_d,US_d,A1us_d,A2us_d,Ius_d,p1us_d,p2us_d,pIus_d,V_d,Lma,Lme,n_d)

for i=1:Ne_d
       sum=0;       % VARIABLE FICTICIA QUE SE UTILIZA PARA ACUMULAR LAS FUERZAS ASOCIATIVAS "ENTRE" ENSAYOS
       sumV=0;      % VARIABLE FICTICIA QUE SE UTILIZA PARA ACUMULAR LAS FUERZAS ASOCIATIVAS "DENTRO" DE UN ENSAYO
       for t=1:largo_d 
                   sumap2=0;
                   for p=1:nCS_d
                       if   CS_d(p,t)==1                
                            [A1cs_d(p,i,t+1), A2cs_d(p,i,t+1), Ics_d(p,i,t+1)]=dinamica(A1cs_d(p,i,t), A2cs_d(p,i,t), Ics_d(p,i,t), p1cs_d(p), p2cs_d(p), pIcs_d(p), 0);  % cs activo  BIEN
                             p2aux_d(p,i,t+1)=Vf_d(n_d(p),i)*A1cs_d(p,i,t+1); % p2 instantáneo para el CS p, ensayo i y tiempo t+1
                       else 
                            [A1cs_d(p,i,t+1), A2cs_d(p,i,t+1), Ics_d(p,i,t+1)]=dinamica(A1cs_d(p,i,t), A2cs_d(p,i,t), Ics_d(p,i,t), p1cs_d(p), p2cs_d(p), 0, 0);  % cs inactivo  BIEN
                             p2aux_d(p,i,t+1)=Vf_d(n_d(p),i)*A1cs_d(p,i,t+1);  % p2 instantáneo para el CS p, ensayo i y tiempo t+1
                       end
                   end
                       
                   for p=1:nCS_d                 % suma los p2 instantáneos (en el momento t+1 del ensayo i) de cada CS
                       auxp2=p2aux_d(p,i,t+1);
                       sumap2=sumap2+auxp2;
                   end
                   
                   p2_d(i,t+1)=sumap2;      % p2 instantáneo (en momento t+1 del ensayo i) 
                   
                   if  p2_d(i,t+1)<0          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                       p2_d(i,t+1)=0;         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   elseif p2_d(i,t+1)>1       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                       p2_d(i,t+1)=1;         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   end                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   
                   if  US_d(t)==1      
                            [A1us_d(i,t+1), A2us_d(i,t+1), Ius_d(i,t+1)]=dinamica(A1us_d(i,t), A2us_d(i,t), Ius_d(i,t), p1us_d, p2us_d, pIus_d, p2_d(i,t+1)); % us activo (sólo un momento)                          
                   else    
                            [A1us_d(i,t+1), A2us_d(i,t+1), Ius_d(i,t+1)]=dinamica(A1us_d(i,t), A2us_d(i,t), Ius_d(i,t), p1us_d, p2us_d, 0, p2_d(i,t+1)); % us inactivo
                   end
               
                   for p=1:nCS_d
                   V_d(n_d(p),i,t+1)=Vinstantaneo(Lma, Lme, A1cs_d(p,i,t+1), A1us_d(i,t+1), A2us_d(i,t+1));  % V(p, i, t+1) es la fuerza asociativa generada por el p-ésimo estímulo en el instante t+1 del ensayo i
                   end
                      
       end
       
       for p=1:nCS_d
            Ve_d(n_d(p),i)=Vensayo(largo_d, sumV, V_d(n_d(p),i,:));             % Ve(p,i) es la fuerza asociativa obtenida para el p-ésimo CS, en el ensayo i    
            Vf_d(n_d(p),i+1)=Vfinal(i, sum, Ve_d(n_d(p),:))+Vf_d(n_d(p),1);          % Vf(p,i+1) es la fuerza acumulada para el p-ésimo CS HASTA el ensayo i, a utilizar en el ensayo i+1
       end
       
end
    
    
       
       
       
       