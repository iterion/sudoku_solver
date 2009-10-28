# puzzle_stats.py - calculate various statistics on puzzle
import numpy

def num_unknowns(n):
    return 9*9-len(n.nonzero()[0])

# Count the number of known values in each row, col, square
def row_count(n):
    return numpy.array([len(y.nonzero()[0]) for y in [x for x in n]])
def col_count(n):
    return numpy.array([len(y.nonzero()[0]) for y in [x for x in n.transpose()]])
def sqr_count(n):
    a = numpy.array(n.flatten().nonzero())
    a = get_box(a)
    return numpy.bincount(a.flatten())[1:]

# Return the sets of row, column, and square known values
def row_set(n,row):
    return numpy.array(n[row,n[row].nonzero()]).flatten()
def col_set(n,col):
    return numpy.array(n[n.transpose()[col].nonzero(),col]).flatten()
def box_set(n,box):
    idx = numpy.array(n.flatten().nonzero()).flatten()
    boxes = get_box(idx)
    flat_idx = numpy.array(numpy.nonzero(boxes==box)).flatten()
    return n.flatten()[idx[flat_idx]]

# Return set of impossibilities for cell
def get_used(n,row,col):
    rc_set = numpy.union1d(row_set(n,row),col_set(n,col))
    print rc_set
    return numpy.union1d(rc_set, box_set(n,get_box(coord2flat(row,col))))

def get_unused(n,row,col):
    return numpy.setdiff1d(numpy.arange(1,10),get_used(n,row,col))


# Convert flat index to box number
#|1|2|3|
#|4|5|6|
#|7|8|9|
def get_box(idx):
    return (3*(idx/27)+1)+((idx/3)%3)

def coord2flat(row,col):
    return 9*(row)+col
def flat2coord(idx):
    return (idx/9,idx%9)
