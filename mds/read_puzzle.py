# read_puzzle.py - reads a sudoku puzzle file
#
# Matthew Sunderland
# October 23, 2009
#
try:
    numpy
except NameError:
    import numpy

def read_puzzle( filename ):
    l = open( filename, 'r').readlines()
    l = map(str.rstrip,l)
    n = numpy.zeros((9,9))
    for i in range(9):
	n[i] = numpy.array([x for x in l[i]])

    return n


