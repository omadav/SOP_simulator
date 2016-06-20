function V=Vfinal(q, s, Ve)
    for j=1:q                
            aux=Ve(j);
            s=s+aux;
    end
    V=s;       