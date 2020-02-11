#!/usr/bin/python
import sys

# How many tshirts to order? This uses a bell curve distribution of
# sizes, which works fairly well in Europe. Might want to skew larger
# for US events.

shirts = int(input("How many shirts? "))

print ("For a total of " + str(shirts) + " shirts, order:\n" )

s   = shirts * 5 / 50 
m   = shirts * 12 / 50
l   = shirts * 16 / 50
xl  = shirts * 12 / 50
xxl = shirts * 5 / 50

# For APAC ...
# s   = shirts * 7 / 50
# m   = shirts * 17 / 50
# l   = shirts * 16 / 50
# xl  = shirts * 7 / 50
# xxl = shirts * 3 / 50

print( str(s) + " small")
print( str(m) + " medium")
print( str(l) + " large")
print( str(xl) + " xl")
print( str(xxl) + " 2xl")

