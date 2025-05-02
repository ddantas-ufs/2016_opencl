import time
import numpy as np
import math
from scipy.ndimage import median_filter, convolve, grey_dilation
from scipy.misc import imread, imsave
from functools import reduce

def saveImage(path, ndarray, w, h, number):
    d = number
    ndarray = np.reshape(ndarray, (w, h, d), 'C')
    for index in range(0, d):
        imsave(path % index, ndarray[:,:,index])

def readImage(path, startIndex, endIndex, w, h, dim, reshape):
    d = produtoria(dim)

    ndarray = np.ndarray((w, h, d))

    for index in range(startIndex, endIndex+1):
        ndarray[:, :, index] = imread(path % index)

    ndarray = np.reshape(ndarray, reshape, 'C')

    return ndarray

def mean_ndarray(ndarray, es_el_nd):
    return convolve(ndarray, es_el_nd, mode='nearest')

def dilation_ndarray(ndarray, es_el_nd):
    return grey_dilation(ndarray, structure=es_el_nd, mode='nearest')

def dilation_sep_ndarray(ndarray, list_es_el_nd):
    n = len(ndarray.shape)
    tmp = grey_dilation(ndarray, structure=list_es_el_nd[0], mode='nearest')
    for i in range(1, n):
        if (i % 2 == 1):
            result = grey_dilation(tmp, structure=list_es_el_nd[i], mode='nearest')
        else:
            tmp = grey_dilation(result, structure=list_es_el_nd[i], mode='nearest')

    if (n % 2 == 1):
        result = tmp

    return result

def negate(ndarray):
    negate = np.array(ndarray)
    negate[:] = 255
    negate = negate - ndarray
    return negate

def copy(ndarray):
    return ndarray.copy()

def threshold(ndarray, thresh):
    #ndarray[np.where(ndarray < thresh)] = 0
    #ndarray[np.where(ndarray >= thresh)] = 255
    return np.where(ndarray > thresh, 1, 0)

def benchmark(t, path, func, args, w, h, dim):
    print("Benchmarking %s, %s times executions of  3x^5 on ndarray" % (func.__name__, str(t)))
    total_time = 0
    out = 0
    for i in range(0, t):
        start_time = time.time()
        out = func(**args)
        total_time += time.time() - start_time
    print("Total time: %s" % str(total_time))
    saveImage(path, out, w, h, dim)

def create_cube_sep_es_el(ndim):
    strel_dim = np.ones(ndim)
    list_str_el_sep = []
    for i in range(ndim):
        strel_dim[i] = 3
        str_el_sep = np.ones(strel_dim)
        list_str_el_sep.append(str_el_sep)
        strel_dim[i] = 1

    return list_str_el_sep

def create_cube_es_el(size, ndim, value):
    es_el_nd = np.ndarray([size]*ndim)
    es_el_nd[:] = value
    return es_el_nd


def create_cross_es_el(size, ndim, value):
    aux = np.array([size]*ndim)
    es_el_nd = np.zeros(aux)
    aux[:] = math.floor(size/2)
    for i in range(ndim):
        for j in range(size):
            aux[i] = j
            es_el_nd[tuple(aux)] = value
        aux[i] = math.floor(size/2)
    return es_el_nd


def produtoria(dim):
    return reduce(lambda x, y: x * y, dim)
