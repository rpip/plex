let factorial = fn n -> if n < 2 then 1 else n * factorial (n - 1)

factorial 10
