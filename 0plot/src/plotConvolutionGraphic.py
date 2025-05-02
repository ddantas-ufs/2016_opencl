import matplotlib.pyplot as plot

fig = plot.figure(1, figsize=(8, 5))

#convolution
VisionGL = (0.046503, 0.209319, 0.8506290, 3.281631, 12.1460)
Python = (2.3015361, 3.15853, 6.40382, 15.965327, 46.253846)
Matlab = (2.71732, 1.529566, 2.077619, 7.289856, 18.087113)

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

plot.title('Convolution', weight='bold')
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
