from PIL import Image
import os

NO_MATERIALS = 5
items = ['helmet', 'armor', 'shoes', 'weapon']

directory_name = "res"
if not os.path.isdir(directory_name):
  os.mkdir(directory_name)

for i in range(NO_MATERIALS):
  for j in range(NO_MATERIALS):
    for k in range(NO_MATERIALS):
      for l in range(NO_MATERIALS):
        index = [i, j, k, l]
        finalImage = Image.open(f'img/{items[0]}_{index[0]}.png')
        for m in range(1, len(items)):
          if l == 0 and items[m] == 'weapon': 
            continue
          layer = Image.open(f'img/{items[m]}_{index[m]}.png')
          finalImage.paste(layer, (0, 0), layer)

        finalImage.save(f'res/{i}_{j}_{k}_{l}.png')