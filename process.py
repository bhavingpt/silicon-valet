import os, glob, subprocess
import shutil

def get_locations():
    locations = dict()

    locations[0] = (140, 709, 310, 104)
    locations[1] = (103, 623, 298, 109)
    locations[2] = (171, 570, 259, 90)
    locations[3] = (219, 522, 204, 65)
    locations[4] = (263, 482, 152, 51)

    locations[5] = (438, 670, 395, 147)
    locations[6] = (422, 540, 325, 142)
    locations[7] = (415, 504, 269, 80)
    locations[8] = (405, 457, 213, 90)
    locations[9] = (399, 423, 210, 83)

    locations[10] = (1273, 489, 173, 174)
    locations[11] = (1138, 461, 222, 111)
    locations[12] = (1053, 432, 172, 84)
    locations[13] = (951, 417, 146, 83)
    locations[14] = (889, 403, 101, 73)
    locations[15] = (837, 398, 89, 49)
    locations[16] = (779, 377, 120, 49)
    locations[17] = (754, 376, 72, 34)
    locations[18] = (740, 362, 67, 29)
    locations[19] = (715, 349, 48, 36)

    locations[20] = (1304, 439, 139, 75)
    locations[21] = (1209, 415, 146, 75)
    locations[22] = (1100, 385, 155, 67)
    locations[23] = (1024, 385, 122, 55)
    locations[24] = (968, 365, 114, 50)
    locations[25] = (933, 366, 75, 38)
    locations[26] = (900, 354, 61, 34)
    locations[27] = (840, 342, 39, 29)
    locations[28] = (841, 344, 39, 30)
    locations[29] = (802, 330, 60, 27)

    locations[30] = (1374, 343, 68, 68)
    locations[31] = (1300, 331, 70, 58)
    locations[32] = (1226, 328, 88, 53)
    locations[33] = (1167, 327, 69, 46)
    locations[34] = (1118, 318, 66, 43)
    locations[35] = (1063, 317, 59, 39)
    locations[36] = (1027, 318, 44, 33)
    locations[37] = (979, 306, 71, 36)
    locations[38] = (915, 302, 60, 32)
    locations[39] = (895, 303, 61, 26)

    return locations

def create_img(f, index):
    locations = get_locations()
    (a, b, c, d) = locations[index]
    os.system("~/Downloads/NConvert/nconvert -quiet -crop " + str(a) + " " + str(b) + " " + str(c) + " " + str(d) + " -o \"temp.png\" -i \"" + f + "\"")

def main():
    locations = get_locations()
    os.chdir("full")
    shutil.rmtree('../cropped/empty')
    shutil.rmtree('../cropped/full')
    os.mkdir('../cropped/empty')
    os.mkdir('../cropped/full')

    counter = 0

    for f in glob.glob("*.png"):
        internal_counter = 0

        with open(f[:-4] + ".txt") as second:
            empty = [int(x.strip()) for x in second.readlines()]

        for i, (k, (a, b, c, d)) in enumerate(locations.items()):
            outloc = "../cropped/empty/" if i in empty else "../cropped/full/"
            os.system("~/Downloads/NConvert/nconvert -crop " + str(a) + " " + str(b) + " " + str(c) + " " + str(d) + " -o \"" + outloc + str(counter) + ".png\" -i \"" + f + "\"")
            counter += 1

if __name__ == "__main__":
    main()

