import matplotlib.pyplot as plot

fig = plot.figure(1, figsize=(8, 5))

#convolution
VisionGL = (0.047305, 0.17199, 0.371911, 0.648212, 1.0053)
Python = (2.9858048, 6.8876359, 10.65868, 13.884626, 17.821185)
Matlab = (2.787961, 0.457109, 2.464107, 3.26919, 4.400162)

dimensions = (1, 2, 3, 4, 5)
dimensions_label = ('1D', '2D', '3D', '4D', '5D')

plot.xticks(dimensions, dimensions_label)

line1 = plot.plot(dimensions, VisionGL, 'bo-')
line2 = plot.plot(dimensions, Python, 'gd-')
line3 = plot.plot(dimensions, Matlab, 'rs-')

plot.subplot(111)
plot.yscale('log')
plot.xlabel("Image Dimension", fontsize="large")
plot.ylabel("Time(s)", fontsize="large")

plot.title('Dilation by separated cube', weight='bold')
plot.grid(True, axis='both')

legend = plot.legend((line1[0], line2[0], line3[0]),
                     ("VisionGL", "Python", "Matlab"),
                     bbox_to_anchor=[1, 0.3],
                     shadow=False)

frame = legend.get_frame()
frame.set_facecolor('1.0')
for t in legend.get_texts():
    t.set_fontsize('large')

plot.show()
