import math

f = open("sines.mif", 'w')
for i in range(360):
    sine = int(math.sin(math.radians(i))*127+127)
    f.write("{0:08b}".format(sine)+"\n")

f.close()
