actualHeatMap = open("board_tile_mouse_click_heatmap.csv", "r")
randomheatMap = open("random_board_tile_mouse_click_heatmap.csv", "r")

output = open("anova_xCoords.csv", "w")
output1 = open("anova_yCoords.csv", "w")

actual = actualHeatMap.readlines()
random = randomheatMap.readlines()


for i in range(len(actual)):
	actual[i] = actual[i].rstrip("\n")
	actual[i] = actual[i].split(",")

for i in range(len(random)):
	random[i] = random[i].rstrip("\n")
	random[i] = random[i].split(",")

xCoords = []
yCoords = []

randXCoords = []
randYCoords = []

for i in range(len(actual)):
	for j in range(len(actual[i])):
		for k in range(int(actual[i][j])):
			xCoords.append(j)
			yCoords.append(i)

for i in range(len(random)):
	for j in range(len(random[i])):
		for k in range(int(random[i][j])):
			randXCoords.append(j)
			randYCoords.append(i)

output.write("Actual,Random\n")
output1.write("Actual, Random\n")
print len(randXCoords)
for i in range(len(randXCoords)):
	output.write(str(xCoords[i])+","+str(randXCoords[i])+"\n")

for i in range(len(randYCoords)):
	output1.write(str(yCoords[i])+","+str(randYCoords[i])+"\n")
