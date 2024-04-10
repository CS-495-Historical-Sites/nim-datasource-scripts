import std/strutils
import std/parsecsv
from std/streams import newFileStream

import category


let filename = "nri-national-register-listed-20240115-2.csv"
var s = newFileStream(filename, fmRead)
if s == nil:
  quit("cannot open the file" & filename)

var x: CsvParser
open(x, s, filename)
readHeaderRow(x)
var rowsread = 0
while readRow(x):
    rowsread += 1
    var signicance = x.rowEntry("Area of Significance")
    signicance = strip(signicance)
    var categories = signicance.split(";")
    echo rowsread
    for c in categories:
        let newc = strip(c)
        if newc.len == 0: continue
        echo newC.toCategory()
        
            


close(x)