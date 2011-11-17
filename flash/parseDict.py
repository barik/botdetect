dictFile = open("f-16.txt", "r")
dict = dictFile.readlines()
output = open("f-16.csv", "w")

for i in range(len(dict)):
	dict[i] = dict[i].rstrip("\n")
	output.write(dict[i])
	output.write(",")
