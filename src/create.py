import os

for i in range(300):
    os.system('python render.py shader.glsl --output=example' + str(i) + '.png --size=1920x1080 --rate=24 --time=' + str(i/10))