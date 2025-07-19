import matplotlib.pyplot as plt
import numpy as np
# import csv

fps = []
population = []
num_tiles = []
num_tiere_rendered = []
num_tiles_rendered = []

with open('../logs/performance.txt', newline='\n') as file:
    for row in file:
        split = row.split(";")
        fps.append(float(split[0]))
        population.append(int(split[1]))
        num_tiles.append(int(split[2]))
        num_tiere_rendered.append(int(split[3]))
        num_tiles_rendered.append(int(split[4]))

# sorting = np.array(fps).argsort()
num_rendered = np.array(num_tiles_rendered) + np.array(num_tiere_rendered)
np_fps = np.array(fps)
other = np.array(num_tiere_rendered)
sorting = np.asarray(other.argsort(), int)
# sorted_fps = np.array(fps)[sorting]
# sorted_fps = np.array(fps)[sorting]
# fig, ax = plt.subplots(1, 2)

# plt.scatter(population, fps, marker=".")
# plt.plot(num_tiles, fps, marker=".")
# plt.xlabel("worldsize")
plt.scatter(other[sorting], np_fps[sorting], c=np.array(num_tiere_rendered)[sorting], marker=".")
plt.xlabel("num_tiere_rendered")

# plt.scatter(np.array(num_tiles_rendered)[sorting], np.array(fps)[sorting], marker=".")
# plt.xlabel("num_tiles_rendered")

plt.tick_params(axis='x', labelrotation=90)
# other_range = np.arange(0, len(other), step=(np.ceil(len(other)/10.0)))
# # plt.xticks(other_range, other[sorting][other_range])
# plt.xticks(other_range)
# fps_range = np.arange(0, len(fps), step=(np.ceil(len(fps)/10.0)))
# plt.yticks(fps_range)
# plt.xticks([0])
# plt.yticks([0])
plt.ylabel("fps")
plt.show()