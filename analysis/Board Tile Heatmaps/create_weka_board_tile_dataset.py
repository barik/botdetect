
dataFile = open("board_tile_mouse_click_heatmap.csv", "r")
data = dataFile.readlines()

submitFile = open("submit_click_heatmap.csv", "r")
submit = submitFile.readlines()

output = open("weka_board_tile_dataset.csv", "w")
output1 = open("weka_submit_dataset.csv", "w")

for i in range(len(data)):
	data[i] = data[i].rstrip("\n")
	data[i] = data[i].split(",")

for i in range(len(submit)):
	submit[i] = submit[i].rstrip("\n")
	submit[i] = submit[i].split(",")

output.write("x,y,value\n")

totalClicks = 0
for i in range(len(data)):
	for j in range(len(data[i])):
		output.write(str(j)+","+str(i)+","+str(data[i][j])+"\n")
		totalClicks += int(data[i][j])

print totalClicks

output1.write("x,y,value\n")
for i in range(len(submit)):
	for j in range(len(submit[i])):
		output1.write(str(j)+","+str(i)+","+str(submit[i][j])+"\n")