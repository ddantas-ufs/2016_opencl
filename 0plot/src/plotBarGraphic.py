import numpy as np
import matplotlib.pyplot as plt

fig = plt.figure(figsize=(8, 5))
ax = fig.add_subplot(111)

N = 5
VisionGL = (0.007051, 0.007807, 0.006898, 0.029078, 0.028499)
Python = (1.5738225, 0.6727864, 0.6937119, 0, 0)
Matlab = (0.065601, 0.26969, 0, 0, 0)
emptySpace = (1, 1, 1, 1, 1)

ind = np.arange(N)  # the x locations for the groups
width = 0.25      # the width of the bars

rectVisionGL = ax.bar(ind + width, VisionGL, width, color='b')
rectPython = ax.bar(ind + width*2, Python, width, color='g')
rectMatlab = ax.bar(ind + width*3, Matlab, width, color='r')
#rectEmpySpace = ax.bar(ind + width*3, emptySpace, width, color='w')

# add some text for labels, title and axes ticks
#ax.set_xlim(-width, len(ind)+width)
ax.set_ylabel('Time(s)')
plt.title('Other operations', weight='bold')
ax.set_xticks(ind + width*2.5)
ax.set_yscale('log')
xtickNames = ax.set_xticklabels(('Negation', 'Threshold', 'Copy CPU->CPU', 'Copy CPU->GPU', 'Copy GPU->CPU'))
plt.setp(xtickNames, rotation=10, fontsize=12)
legend = ax.legend((rectVisionGL[0], rectPython[0], rectMatlab[0]), ('VisionGL', 'Python', 'Matlab'))

#ax.legend((rectVisionGL[0], rectPython[0]), ('VisionGL', 'Python'))


def autolabel(rects):
    # attach some text labels
    for rect in rects:
        height = rect.get_height()
        ax.text(rect.get_x() + rect.get_width()/2., 1.05*height,
                '%0.4f' % float(height),
                ha='center', va='bottom', rotation=90)

autolabel(rectVisionGL)
autolabel(rectPython)
autolabel(rectMatlab)


plt.show()
