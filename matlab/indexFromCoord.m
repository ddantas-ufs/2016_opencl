function linear_index = indexFromCoord(array, ndim)
    switch length(size(array))
        case 1
            linear_index = sub2ind(size(array),ndim(1));
        case 2
            linear_index = sub2ind(size(array),ndim(1), ndim(2));
        case 3
            linear_index = sub2ind(size(array),ndim(1), ndim(2), ndim(3));
        case 4
            linear_index = sub2ind(size(array),ndim(1), ndim(2), ndim(3), ndim(4));
        case 5
            linear_index = sub2ind(size(array),ndim(1), ndim(2), ndim(3), ndim(4), ndim(5));
    end
end