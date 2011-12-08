xCoordsFile = open("randomX.txt", "r")
yCoordsFile = open("randomY.txt", "r")

output = open("random_board_tile_mouse_click_heatmap.csv", "w")

xCoords = xCoordsFile.readlines()
yCoords = yCoordsFile.readlines()

coordsArray = []
for i in range(len(xCoords)):
	xCoords[i] = xCoords[i].rstrip("\n")
	yCoords[i] = yCoords[i].rstrip("\n")
	temp = []
	temp.append(int(xCoords[i]))
	temp.append(int(yCoords[i]))
	coordsArray.append(temp)

heatmap = []

for i in range(35):
	temp = []
	for j in range(35):
		temp.append(0)
	heatmap.append(temp)

for i in range(len(coordsArray)):
	if coordsArray[i][0] >= 0 and coordsArray[i][0] <=34 and coordsArray[i][1] >= 0 and coordsArray[i][1] <= 34:
		heatmap[coordsArray[i][1]][coordsArray[i][0]] += 1

for i in range(len(heatmap)):
	for j in range(len(heatmap[i])):
		output.write(str(heatmap[i][j]))
		if j == len(heatmap[i])-1:
			output.write("\n")
		else:
			output.write(",")