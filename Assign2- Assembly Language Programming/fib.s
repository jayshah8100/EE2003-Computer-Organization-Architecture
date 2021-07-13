.global fib              # I have implemented the assembly program using mostly psuedo-instructions & ABI naming convention

fib:                     # a0 contains the input, and finally a0 also contains the output
    li a1, 1             # This reg contains the (n-2) no.
    li a2, 1             # This reg contains the (n-1) no.
    li a3, 0             # This reg contains the nth no. 
    li a4, 2             # A dummy reg for comparison with a0
    
    ble a0, a4, end      # To check(branch) if a0 <= 2 
         

main:                    # This block (loop) implements the Fibonacci Series
    add a3, a1, a2       # nth no. = (n-2) no. + (n-1) no.
    mv a1, a2            # new (n-2) no. <-- original (n-1) no.
    mv a2, a3            # new (n-1) no. <-- original (n)th no.
    addi a0, a0, -1      # decrementing a0
    bgt a0, a4, main     # if a0 > 2 it repeats again 

end:
    mv a0 , a2           # a2 defaults to 1 if a0<=2, else a2 contains the nth no. 
    jr ra                # Jumps to the return address that was stored by original call
