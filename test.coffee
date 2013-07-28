class Matrix

	constructor: (rows, cols) ->
		@rows = if Number(rows) > 0 then Number(rows) else 0
		@cols = if Number(cols) > 0 then Number(cols) else 0

		@grids = (0 for i in [0...rows * cols])

	print: ->
		result = ""
		for row in [0...@rows]
			for col in [0...@cols]
				result += "#{@getValue row, col}\t"

			result += "\n"

		console.log result;

	isValidIndex: (row, col) ->
		(0 <= row < @rows) and (0 <= col < @cols)

	convertIndex: (row, col) ->
		if @isValidIndex(row, col) then row * @cols + col else 0

	getValue: (row, col) ->
		if @isValidIndex(row, col) then @grids[@convertIndex(row, col)] else Matrix.InvalidValue

	setValue: (value, row, col) ->
		@grids[@convertIndex(row, col)] = value if @isValidIndex row, col

	growAtIndex: (row, col) ->
		if @isValidIndex row, col
			# @setValue 1, row, col
			growIndexes = [{row: row, col: col}]
			# console.log growIndexes
			for step in [1...@rows * @cols] when growIndexes.length > 0
				# console.log growIndexes
				newGrowIndexes = []
				for index in growIndexes
					@setValue step, index.row, index.col
					(newGrowIndexes.push aroundIndex for aroundIndex in @getAroundIndexes(index.row, index.col) when @getValue(aroundIndex.row, aroundIndex.col) is 0)
				growIndexes = newGrowIndexes
		
		# console.log "grow done!"


	getAroundIndexes: (row, col) ->
		indexes = []
		for indexOffset in [{row: -1, col: 0}, {row: 1, col: 0}, {row: 0, col: -1}, {row: 0, col: 1}]
			aroundIndex = {row: row + indexOffset.row, col: col + indexOffset.col}
			indexes.push aroundIndex if @isValidIndex aroundIndex.row, aroundIndex.col
		
		indexes

	createBlocks: (blockPercent) ->
		for row in [0...@rows]
			for col in [0...@cols]
				@setValue Matrix.InvalidValue, row, col if 0 < Math.random() < blockPercent
	
	printPath: ->
		result = ""
		for row in [0...@rows]
			for col in [0...@cols]
				if @getValue(row, col) > 0
					result += "O "
				else if @getValue(row, col) is 0
					result += "@ "
				else
					result += "# "
			result += "\n"

		console.log result; 

Matrix.InvalidValue = -1
	
matrix = new Matrix(10, 10)

matrix.createBlocks 0.5

path = -1
for row in [0...matrix.rows]
	for col in [0...matrix.cols]
		if matrix.getValue(row, col) is 0
			matrix.growAtIndex row, col 
			path--
			for rowPath in [0...matrix.rows]
				for colPath in [0...matrix.cols]
					matrix.setValue(path, rowPath, colPath) if matrix.getValue(rowPath, colPath) > 0

		

# matrix.growAtIndex 4, 5
matrix.print()
# matrix.printPath()
