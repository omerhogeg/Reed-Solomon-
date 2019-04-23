import numpy as np
import math
import random
import sympy as sp
from sympy import abc
import sys

##################### ENCODER #####################

def get_random_int(max):
    return (random.randint(0,max)+1)

print("Enter K,N values when N>K!")

k = int(input("Enter K Value:"))
minOfN = 4*(k**2)+1
#print(minOfN)
n = random.randint(minOfN,2*minOfN)

def next_prime(n):
    x = n+1
    for prime in range(x,x*2):
        isPrime = True
        for num in range(2,prime):
            if prime % num == 0:
                isPrime = False
                break
        if isPrime:
            return prime

q = next_prime(n)
print 'K:' ,k
print 'N:' ,n
print 'Q:' ,q

numberOfErrors = int(n - math.floor(2*k*math.sqrt(n)))
print 'Number of Errors: ', numberOfErrors, "\n"

listOfPol = []
for i in range(0, k):
    listOfPol.insert(i, get_random_int(k-1))

#print(listOfPol)

temp = listOfPol
print 'Polynomial representation: ', temp, "\n"

temp.reverse()
sumForY = temp[0]
temp.reverse()
listOfPoints = []
firstPoint = []
firstPoint= [0, sumForY]
listOfPoints.append(firstPoint)
counter = temp.__len__() - 1
sumForY = 0

for i in range(1, n):
    for j in range(temp.__len__()-1, -1, -1):
        calcY = (temp[0] * ((i) ** j ))
        temp = temp[1:]
        sumForY = (sumForY + calcY)
        counter = counter - 1
        if (j == 0):
            subList = []
            temp = listOfPol
            sumForY = sumForY % q
            subList = [i, sumForY]
            listOfPoints.append(subList)
            sumForY = 0
            counter = listOfPol.__len__()-1

def makeNoise(numberOfErrors,n):
    for i in range(0, numberOfErrors):
        listOfPoints.reverse()
        makeError = [n-1, i]
        listOfPoints[i] = makeError
        listOfPoints.reverse()
        n = n - 1
    return listOfPoints

if(numberOfErrors < 1):
    print("the number of errors is bad!") ; sys.exit(1)
else:
    #print 'List of Points: ', listOfPoints, "\n"
    listOfPoints = makeNoise(numberOfErrors, n)

#print('List of Points after noise: ') ; listOfPoints


##################### ENCODER-END #####################



##################### DECODER #####################

mod = q

def buildEquations(points, n):
    equations = []
    for point in points:
        equations.append(buildEquation(point, n))
    return np.array(equations)


def buildEquation(point, n):
    sqrt = math.ceil(math.sqrt(n))
    equation = []
    for i in range(int(sqrt)):
        for j in range(int(sqrt)):
            equation.append(pow(point[0], i) * pow(point[1], j))
    return equation

def buildTwoDimPoly(vector, n):
    R = GF(mod)['x,y']
    x, y = R.gens()
    poly = 0
    sqrt = int(math.ceil(math.sqrt(n)))
    output = []
    for i in range(sqrt):
        for j in range(sqrt):
            output.append(x^i * y^j)
    for k in range (sqrt ^ 2):
        poly = poly + vector[k]*output[k]
    #print(poly)
    return poly

equations = buildEquations(listOfPoints,n)
#print('euqtions:\n', equations, '\n\n')

matrix = Matrix(GF(mod), equations)
#print('Matrix: ') ; matrix

nullSpace = matrix.right_kernel()[1]
#print('nullspace: ') ; nullSpace

twoDimPoly = buildTwoDimPoly(nullSpace, n)
#print('Two Dim Polynomial:\n', twoDimPoly, '\n\n')

factorizedPoly = list(twoDimPoly.factor())
print 'factorized Poly: ' ; factorizedPoly
print "\n", 'factors list length: ', len(factorizedPoly), "\n"

finalList = []

for factor in factorizedPoly:
    R = GF(mod)['x,y']
    x, y = R.gens()
    poly = 0
    poly = poly + factor[0]
    if poly.degree(y) == 1:
        poly = (poly*(-1)) + y
        finalList.append(poly)

print 'Final List: ' ; finalList


##################### DECODER-END #####################










