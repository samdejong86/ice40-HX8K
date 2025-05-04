from PIL import Image
import numpy as np
import argparse

def hex_to_rgb(colour_hex):
    r=int(colour_hex[0:2], 16)
    g=int(colour_hex[2:4], 16)
    b=int(colour_hex[4:6], 16)

    return[r,g,b]


parser = argparse.ArgumentParser(description='Convert a png image to a mif file')
parser.add_argument('-f','--filename', help='Name of PNG file', default="jumpbox.mif", required=False)
#arser.add_argument('-n','--ncolours', help='Number of colours in image', default=4, required=True)
parser.add_argument('-c','--colours', help='comma seperated list of colours', default="", required=True)

args = parser.parse_args()

colours=args.colours.split(",")

ncolours=len(colours)

colourWidth = len(bin(int(ncolours)-1)[2:])


indexData = []#[["" for i in range(width)] for j in range(height)]

with open(args.filename, 'r') as file:
    for line in file:
        #print(line.strip())

        lineData=[int(line.strip()[i:i+colourWidth][::-1],2) for i in range(0, len(line.strip()), colourWidth)]
        indexData.append(lineData)


height=len(indexData)
width=len(indexData[0])

im = Image.new(mode="RGB", size=(width, height))
for i in range(width):
    for j in range(height):
        colourIndex=indexData[j][i]
        rgb=hex_to_rgb(colours[colourIndex])
        im.putpixel((i, j), tuple(rgb))


im.show()
