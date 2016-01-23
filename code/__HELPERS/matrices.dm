/matrix/proc/TurnTo(old_angle, new_angle)
	. = new_angle - old_angle
	Turn(.) //BYOND handles cases such as -270, 360, 540 etc. DOES NOT HANDLE 180 TURNS WELL, THEY TWEEN AND LOOK LIKE SHIT


/atom/proc/SpinAnimation(speed = 10)
	var/matrix/m120 = matrix(transform)
	m120.Turn(120)
	var/matrix/m240 = matrix(transform)
	m240.Turn(240)
	var/matrix/m360 = matrix(transform)
	speed /= 3      //Gives us 3 equal time segments for our three turns.
	                //Why not one turn? Because byond will see that the start and finish are the same place and do nothing
	                //Why not two turns? Because byond will do a flip instead of a turn
	animate(src, transform = m120, time = speed, loop = -1)
	animate(transform = m240, time = speed)
	animate(transform = m360, time = speed)

// Matrices library by Lugia319

/*
Matrices are an incredibly useful mathematical tool, I'm surprised DM doesn't support them innately. I'm creating this
library mainly for me to use in my AI pathing library. However, communist as I am, I must share my information with the
world.

This library comes with the following

Matrix datum
- New() // Creates matrix
- Del() // Deletes matrix
- Fill() // Fills a matrix with 0's
- Display() // Outputs matrix (to world)
- ConstAdd() // Adds a constant to every element of the matrix
- Add() // Adds matrix to another matrix
- Subtract() // Subtracts a matrix from another matrix
- ConsMult() // Multiply a constant through a matrix
- Dot() // Dot product of matrices
- ChangeValue() // Modify a value in matrix
- GetValue() // Retrieve a value in matrix

IMPORTANT NOTES:
- A 1x1 matrix is not a number, it is a list(list())
- If a rownum is not specified or
*/

/*
The Matrix datum. Stores the matrix list which will be used for all matrix calculuations.
*/

proc
	InsertList(var/list/L1, var/list/L2) // Inserts L2 into L1's contents
		L1 += 0
		L1[L1.len] = L2
		return L1

Matrix

	var
		cols = 0
		matrix = list()

	New(var/colnum, var/rownum = 0) // colnum is the number of columns
		cols = colnum
		for(var/i = 1 to colnum)
			InsertList(matrix, list()) // Adds "columns" to matrix
		if(rownum >= 0) src.Fill(rownum)
		return ..()

	Del()
		..()

	proc
		Fill(var/num) // Fills a matrix with 0's- Makes a matrix of cols x num elements. Returns 1 upon success, otherwise returns 0
			if(num <= 0) return 0
			var/list/M = src.matrix
			for(var/i = 1 to src.cols)
				var/list/MI = M[i]
				for(var/j = 1 to num)
					MI += 0
			return 1

		Display() // Displays all elements of a matrix
			var/list/M = src.matrix
			for(var/i = 1 to src.cols)
				var/list/M1 = M[i]
				for(var/j = 1 to M1.len)
					world << "[i]x[j]: [M1[j]]"
			return

		ConstAdd(var/num) // Adds num to every element in matrix
			var/list/M = src.matrix
			for(var/i = 1 to src.cols)
				var/list/M1 = M[i]
				for(var/j = 1 to M1.len)
					M1[j] = M1[j] + num
			return

		Add(var/Matrix/M) // Adds M to src if possible and returns 1. Otherwise return 0
			if(src.cols != M.cols) return 0 // Can't add matrices unless they have the same number of columns and rows
			var/list/ML1 = src.matrix ; var/list/ML2 = M.matrix
			if(ML1.len != ML2.len) return 0

// Now that we've established that they are the same size, we can add them
			for(var/i = 1 to ML1.len) // Since they're both the same size I don't need to worry about which one I pick
				var/list/L = ML1[i]
				var/list/L2Add = ML2[i]
				for(var/j = 1 to L.len)
					L[j] += L2Add[j]

			return 1

		Subtract(var/Matrix/M) // Subtracts M from src if possible and returns 1. Otherwsie return 0
			if(src.cols != M.cols) return 0 // Can't subtract matrices unless they have the same number of columns and rows
			var/list/ML1 = src.matrix ; var/list/ML2 = M.matrix
			if(ML1.len != ML2.len) return 0

// Now that we've established that they are the same size, we can subtract them
			for(var/i = 1 to ML1.len) // Since they're both the same size I don't need to worry about which one I pick
				var/list/L = ML1[i]
				var/list/L2Add = ML2[i]
				for(var/j = 1 to L.len)
					L[j] -= L2Add[j]

			return 1

		ConstMult(var/num) // Multiplies every element in a matrix by num
			var/list/M = src.matrix
			for(var/i = 1 to src.cols)
				var/list/M1 = M[i]
				for(var/j = 1 to M1.len)
					M1[j] = M1[j] * num
			return

		Dot(var/Matrix/M) // Performs dot product of src and M if possible and returns the dot product. Otherwise return null
// I can't return 0 because 0 is an actual dot product

			var/list/M1 = src.matrix ; var/list/L1 = M1[1]
			var/list/M2 = M.matrix ; var/list/L2 = M2[1]
/*
L1 and L2 store number of rows via length.
The dot product is defined as long each matrix has as many rows as the other has columns and vice versa
*/
			if(src.cols != L2.len || L1.len != M.cols) return null // Not defined in this case

			var/Matrix/Dot = new(L1.len, M.cols)
			var/sum = 0
			for(var/row = 1 to M.cols)

				for(var/col = 1 to src.cols)
					L1 = list() // Gotta rewrite the list each time through

/*
What I'm essentially doing here, is creating vectors and dotting them and putting the sum in the proper spot in the final
matrix. The first vector is the row of the first matrix, and the second vector is the column of the second matrix.
*/
					for(var/i = 1 to src.cols)
						L1 += M1[row][i]
					L2 = M2[col]

					sum = 0
					for(var/i = 1 to L1.len)
						sum += L1[i] * L2[i]

					Dot.ChangeValue(col, row, sum)

			return Dot // return the dot product (does not modify either matrix in operation)

		ChangeValue(var/col, var/row, var/value) // Changes a value at [col]x[row] to value. Returns 1 if success, 0 otherwise
			if(col > src.cols) return 0 // Can't change values that don't exist
			var/list/M = src.matrix
			var/list/M2 = M[col] // This is the column we're looking for
			if(row > M2.len) return 0 // Can't change values that don't exist
			M2[row] = value // modify value
			return 1

		GetValue(var/col, var/row) // Retrieve a value in the matrix at [col]x[row]. Returns value on success, returns null otherwise
			if(col > src.cols) return null
			var/list/M = src.matrix
			var/list/M2 = M[col]
			if(row > M2.len) return null
			return M2[row]