#!/usr/bin/env python
from PIL import Image
import argparse
import numpy as np

# Todo:
# get closest colours before generating .mif file since that might reduce the number of colours


def hex_to_rgb(colour_hex):
    r=int(colour_hex[0:2], 16)
    g=int(colour_hex[2:4], 16)
    b=int(colour_hex[4:6], 16)

    return[r,g,b]


def rgb_to_hex(colour_rgb):
    return "{:02x}{:02x}{:02x}".format(colour_rgb[0],colour_rgb[1],colour_rgb[2])


def c_6b_24b(colour_6b):
    c=str(colour_6b)
    newWord="";
    for i in range(3):
        byte=c[2*i:2*i+2]
        if byte == "11":
            newWord+="ff"  #255
        elif  byte == "10":
            newWord+="aa"  #170
        elif byte == "01":
            newWord+="55"  #85
        elif byte == "00":
            newWord+="00" #0

    return(newWord)

def c_25b_6b(colour_hex):
    newWord="";
    for i in range(3):
        byte=colour_hex[2*i:2*i+2]
        if byte == "ff":
            newWord+="11"  #255
        elif  byte == "aa":
            newWord+="10"  #170
        elif byte == "55":
            newWord+="01"  #85
        elif byte == "00":
            newWord+="00" #0

    return(newWord)



def closest(colors,color):
    colors = np.array(colors)
    color = np.array(color)
    distances = np.sqrt(np.sum((colors-color)**2,axis=1))
    index_of_smallest = np.where(distances==np.amin(distances))
    smallest_distance = colors[index_of_smallest]
    return smallest_distance





parser = argparse.ArgumentParser(description='Convert a png image to a mif file')
parser.add_argument('-f','--filename', help='Name of PNG file', default="jumpbox.png", required=False)
parser.add_argument('-s','--show', help='Show picture after colour adjustment', action='store_true', required=False)

args = parser.parse_args()




img = Image.open(args.filename)
rgb_im = img.convert('RGB')

width, height = img.size


colours = rgb_im.convert("RGB").getcolors() #this converts the mode to RGB
new_colours = [colours[i][1] for i in range(len(colours))]

# find closest colours what's in the image, remove duplicates to create a closest colour list.

allowed_colours = ['{0:06b}'.format(i) for i in range(64)]
allowed_colours_hex=[]
allowed_colours_rgb=[]

for c in allowed_colours:
    #print(c_6b_24b(c))
    c_hex = c_6b_24b(c)
    c_rgb = hex_to_rgb(c_hex)


    allowed_colours_hex.append(c_hex)
    allowed_colours_rgb.append(c_rgb)




closestColours = []
for colour in new_colours:

    rgb = list(colour)
    closest_colour = closest(allowed_colours_rgb, rgb)
    print(closest_colour[0])
    #closest_colour_hex = rgb_to_hex(closest_colour[0])

    #colours = [rgb_to_hex(rgb), closest_colour_hex, c_25b_6b(closest_colour_hex)]
    closestColours.append(tuple(closest_colour[0]))



print(closestColours)

indexData = [["" for i in range(width)] for j in range(height)]


for i in range(width):
    for j in range(height):
        if rgb_im.getpixel((i,j)) in new_colours:
            indexData[j][i] = new_colours.index(rgb_im.getpixel((i,j)))





outfilename = args.filename.rsplit( ".", 1 )[ 0 ]+".mif"

nColours=len(new_colours)

binary = bin(len(new_colours)-1)[2:]

colourWidth="{0:0"+str(len(binary))+"b}"


data=""
for i in range(height):
    for j in range(width):
        data+=colourWidth.format(indexData[i][j])[::-1]
    data+="\n"
f=open(outfilename, 'w')
f.write(data)
f.close()



allowed_colours = ['{0:06b}'.format(i) for i in range(64)]
allowed_colours_hex=[]
allowed_colours_rgb=[]

for c in allowed_colours:
    #print(c_6b_24b(c))
    c_hex = c_6b_24b(c)
    c_rgb = hex_to_rgb(c_hex)


    allowed_colours_hex.append(c_hex)
    allowed_colours_rgb.append(c_rgb)




new_colours2 = [list(colours[i][1]) for i in range(len(colours))]



closestColours = []
for colour in new_colours:

    rgb = list(colour)
    closest_colour = closest(allowed_colours_rgb, rgb)
    closest_colour_hex = rgb_to_hex(closest_colour[0])

    colours = [rgb_to_hex(rgb), closest_colour_hex, c_25b_6b(closest_colour_hex)]
    closestColours.append(colours)


if args.show:

    im = Image.new(mode="RGB", size=(width, height))

    for i in range(width):
        for j in range(height):

            colourIndex=indexData[j][i]
            colour = closestColours[colourIndex][1]


            im.putpixel((i, j), tuple(hex_to_rgb(colour)))


    im.show()




# need to swap these colours due to a quirk in how the mif file is read
#if len(closestColours) == 2:
#    closestColours.append(["FFFFFF", "FFFFFF", "111111"])

#closestColours[1], closestColours[2] = closestColours[2], closestColours[1]

print("Colours:")

def rreplace(s, old, new, occurrence):
    li = s.rsplit(old, occurrence)
    return new.join(li)

vhdlline = "constant "+args.filename.rsplit( ".", 1 )[ 0 ]+"Palette : t_slv_v(0 to "+str(len(closestColours)-1)+")(5 downto 0) := (";
whitespace=len(vhdlline)
for i in range(len(closestColours)):
    vhdlline+="\""+closestColours[i][2]+"\", --"+closestColours[i][1]+"\n"+" "*whitespace


vhdlline = rreplace(vhdlline, ", ", ");",1)
print(vhdlline)
