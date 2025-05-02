function es_el_nd = create_3xcross_es_el(n)
    %cabecario montagem
    aux = zeros(n);
    aux = aux(1:n);
    aux(:) = 3;
    es_el_nd = zeros(aux);
    %%%%%%%%%%%%%%%%%%%%%%
    coord = ones(n);
    coord(1) = 1;

    if n == 1
        es_el_nd = [1, 1, 1];
    else
        for d = 1:n
            coord(d) = 2;
        end
        index = indexFromCoord(es_el_nd, coord);
        es_el_nd(index) = 1;
    
        for d = 1:n
            coord(d) = 1;
            index = indexFromCoord(es_el_nd, coord);
            es_el_nd(index) = 1;
        
            coord(d) = 3;
            index = indexFromCoord(es_el_nd, coord);
            es_el_nd(index) = 1;
        
            coord(d) = 2;
        end
    end
end