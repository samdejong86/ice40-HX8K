import csv
import sys
import os
BaseFreq=12e6

Notes={
    'C':  round(BaseFreq/(2* 261.63)),
    'C#': round(BaseFreq/(2* 277.18)),
    'Df': round(BaseFreq/(2* 277.18)),
    'D':  round(BaseFreq/(2* 293.66)),
    'D#': round(BaseFreq/(2* 311.1)),
    'Ef': round(BaseFreq/(2* 311.1)),
    'E':  round(BaseFreq/(2* 329.63)),
    'F':  round(BaseFreq/(2* 349.23)),
    'F#': round(BaseFreq/(2* 369.9)),
    'Gf': round(BaseFreq/(2* 369.9)),
    'G':  round(BaseFreq/(2* 392)),
    'G#': round(BaseFreq/(2* 415.3)),
    'Af': round(BaseFreq/(2* 415.3)),
    'A':  round(BaseFreq/(2* 440)),
    'A#': round(BaseFreq/(2* 466.16)),
    'Bf': round(BaseFreq/(2* 466.16)),
    'B':  round(BaseFreq/(2* 493.88)),
    'Cf':  round(BaseFreq/(2* 493.88)),
    'r':  0,
}

filename=sys.argv[1]

lines=""
line_count = 0
with open(filename, 'r') as f:
    reader = csv.reader(f, dialect='excel', delimiter='\t')
    for row in reader:
        line_count += 1
        noteTimer=0
        duration=row[2]
        if int(row[1]) > 0:
            noteTimer = Notes[row[0]]>>int(row[1])
        elif int(row[1]) < 0:
            noteTimer = Notes[row[0]]<<abs(int(row[1]))
        else:
            noteTimer = Notes[row[0]]

        lines+="{0:015b}".format(noteTimer)+"{0:05b}".format(int(duration))+"\n"


lines = "{0:020b}".format(line_count)+"\n" + lines

for i in range(line_count-1, 150):
    lines+="0"*20+"\n"

outfilename = filename.rsplit( ".", 1 )[ 0 ]+".mif"

out = open(outfilename, 'w')
out.write(lines)
out.close()
