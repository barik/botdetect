
for(i in 0:14)
{
	for(j in 0:14)
	{
		clickHeatMap = read.csv(paste("tile_",i,"_",j,"heatmap.csv", sep=""))
		clickHeatMapMatrix = as.matrix(clickHeatMap)
		png(file = paste(i,"_",j,"heatmap.png",sep=""))
		heatmap(clickHeatMapMatrix, symm = TRUE, Rowv = NA)
		dev.off()
	}
}