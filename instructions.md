    The commands will be described as follows

     U
    L.R
     D

U|D|L|R|instruction
:-:|:-:|:-:|:-:|:-
0|`n`|0|0|push `n`
0|`n`|0|1|push ASCII codes for number `n`
0|0|0|2|input one byte
0|0|0|3|input one number
0|0|0|4|input one line
0|1|1|0|push stack length
0|0|1|0|swap top two
0|0|1|1|reverse entire stack
0|0|1|`n≥2`|reverse top `n` items
0|0|2|0|swap top two
0|0|2|1|rotate entire stack upwards
0|0|2|`n≥2`|rotate top `n` items upward
0|1|2|0|swap top two
0|1|2|1|rotate entire stack downwards
0|1|2|`n≥2`|rotate top `n` items downward
1|0|0|0|pop; print as ASCII
1|1|0|0|print entire stack as ASCII
1|`c≥2`|0|0|print top `c` items as ASCII
1|0|0|1|pop; print as number
1|1|0|1|print entire stack as numbers
1|`c≥2`|0|1|same as above; `c` times
1|0|0|2|print a newline
1|0|1|0|pop and throw away
1|0|1|`c`|pop and throw away `c` items
1|0|2|0|clear stack
2|0|0|0|duplicate top item
2|0|`c`|`n`|duplicate top `n` items `c` times
2|1|0|0|`==`
2|1|1|1|`!=`
2|1|1|0|`<`
2|1|2|0|`<=`
2|1|0|1|`>`
2|1|0|2|`>=`
2|2|0|0|addition
2|2|0|1|subtraction
2|2|1|0|multiplication
2|2|1|1|division
2|2|2|0|exponentiation
2|2|2|1|logarithm
2|2|`n`|`m`|etc
2|2|0|2|modulo
2|2|1|2|integer division
2|2|2|2|divmod
2|3|0|0|pop n; push `1` if `n == 0` else `0` (not)
3|`n`|0|0|set label `n`
3|`n`|0|1|pop; go to label `n` if nonzero
3|`n`|1|0|pop; go to label `n` if zero
3|`n`|1|1|go to label `n`
