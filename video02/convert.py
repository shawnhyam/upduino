# very primitive little bit of code to convert color codes from RGB888 to RGB555
with open('palette.mem', 'r') as reader:
    for line in reader.readlines():
        v = int(line, 16)
        blue = v%256
        green = (v/256)%256
        red = (v/2**16)%256
        c16 = (blue/8) + (green/8)*32 + (red/8)*1024
        print("%04x" % c16)