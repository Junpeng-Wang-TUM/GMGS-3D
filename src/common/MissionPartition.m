function blockIndex = MissionPartition(totalSize, blockSize)
	numBlocks = ceil(totalSize/blockSize);		
	blockIndex = ones(numBlocks,2);
	blockIndex(1:numBlocks-1,2) = (1:1:numBlocks-1)' * blockSize;
	blockIndex(2:numBlocks,1) = blockIndex(2:numBlocks,1) + blockIndex(1:numBlocks-1,2);
	blockIndex(numBlocks,2) = totalSize;	
end