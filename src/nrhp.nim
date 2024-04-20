import std/strutils
import std/parsecsv
import std/tables

from std/streams import newFileStream

import category

proc buildCategoryTable*() : Table[string, seq[category.Category]] =
  let filename = "nri-national-register-listed-20240115-2.csv"
  var s = newFileStream(filename, fmRead)
  if s == nil:
    quit("cannot open the file" & filename)

  var x: CsvParser
  open(x, s, filename)
  readHeaderRow(x)
  var rowsread = 0

  # table mapping id -> categories
  var idToCategories: Table[string, seq[category.Category]] = initTable[string, seq[category.Category]]()

  while readRow(x):
      rowsread += 1
      let id = x.rowEntry("Ref#")
      var signicance = x.rowEntry("Area of Significance")
      signicance = strip(signicance)
      var categories = signicance.split(";")
      var actualcategories: seq[category.Category] = @[]
      for c in categories:
          let newc = strip(c)
          if newc.len == 0: continue
          let newActualC = newC.toCategory()
          actualcategories.add(newActualC)
      
      idToCategories[id] = actualcategories

  close(x)
  return idToCategories

