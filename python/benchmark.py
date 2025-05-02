import sys
import os
import numpy as np
from functions import benchmark, readImage, saveImage
from functions import mean_ndarray, dilation_ndarray, create_cube_es_el, create_cube_sep_es_el
from functions import create_cross_es_el, negate, threshold, copy, dilation_sep_ndarray
#benchmark tries
t = 10

path = os.getcwd()
imgname = path + "\\..\\dataset\\mitosis-5d0%03i.tif"
imgout_mean = path + "\\mitosis_out\\mean\\mitosis-5d0%03i.tif"
imgout_dilate_cube = path + "\\mitosis_out\\dilate_cube\\mitosis-5d0%03i.tif"
imgout_dilate_cross = path + "\\mitosis_out\\dilate_cross\\mitosis-5d0%03i.tif"
imgout_negate = path + "\\mitosis_out\\negate\\mitosis-5d0%03i.tif"
imgout_threshold = path + "\\mitosis_out\\threshold\\mitosis-5d0%03i.tif"
imgout_copy = path + "\\mitosis_out\\copy\\mitosis-5d0%03i.tif"
imgout_dilate_sep = path + "\\mitosis_out\\dilate_sep\\mitosis-5d0%03i.tif"
startImageIndex = 0
endImageIndex = 335


dim = (2, 24, 7)

w = 256
h = 256

args = np.array(sys.argv)[1:].astype(int)
print("shape: %s" % str(tuple(args)))
ndarray = readImage(imgname, startImageIndex, endImageIndex, w, h, dim, tuple(args))
shape = tuple(args)

print("image shape: %s" % str(ndarray.shape))

es_el_cube_mean = create_cube_es_el(3, len(shape), 1/(3**len(shape)))
es_el_cube_one = create_cube_es_el(3, len(shape), 1)
es_el_cross = create_cross_es_el(3, len(shape), 1)
es_el_cube_sep = create_cube_sep_es_el(len(shape))

params_cube = {"ndarray": ndarray, "es_el_nd": es_el_cube_one}
params_mean = {"ndarray": ndarray, "es_el_nd": es_el_cube_mean}
params_cross = {"ndarray": ndarray, "es_el_nd": es_el_cross}
params_negate = {"ndarray": ndarray}
params_thresh = {"ndarray": ndarray, "thresh": 128}
params_copy = {"ndarray": ndarray}
params_sep_dilation = {"ndarray": ndarray, "list_es_el_nd": es_el_cube_sep}

benchmark(t, imgout_mean, mean_ndarray, params_mean, w, h, endImageIndex+1)
benchmark(t, imgout_dilate_cross, dilation_ndarray, params_cross, w, h, endImageIndex+1)
benchmark(t, imgout_dilate_sep, dilation_sep_ndarray, params_sep_dilation, w, h, endImageIndex+1)
benchmark(t, imgout_dilate_cube, dilation_ndarray, params_cube, w, h, endImageIndex+1)

benchmark(t, imgout_copy, copy, params_copy, w, h, endImageIndex+1)
benchmark(t, imgout_negate, negate, params_negate, w, h, endImageIndex+1)
benchmark(t, imgout_threshold, threshold, params_thresh, w, h, endImageIndex+1)
