function es_el_nd = create_3xcube_mean_es_el(n)
    aux = zeros(n);
    aux = aux(1:n);
    aux(:) = 3;
    es_el_nd = ones(aux);
    if (n == 1)
        es_el_nd = ones(1, aux);
    end
    es_el_nd(:) = 1/(3^n);
end
