from os import listdir, rename
from os.path import isfile, join
pth = "../public/api/"
files = [f for f in listdir(pth) if isfile(join(pth, f))]

for metadata in files:
    num = int(metadata.split(".")[0])
    rename(pth + metadata, pth + "{0:0{1}x}.json".format(num, 64))
