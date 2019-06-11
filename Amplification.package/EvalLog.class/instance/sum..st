math functions
sum: anIdx
   ^ (self loggers at: anIdx) collect: [ :x | x sum ]