# Architecture-and-Assembly
Programs using low-level Assemble x86 language

Run and Text using Visual Studio.

## Program 01
### Objectives:
1. Introduction to MASM assembly language.
2. Defining variables (integer and string).
3. Using library procedures for I/O.
4. Integer arithmetic.

### Description:
Write and test a MASM program to perform the following tasks:
1. Display your name and program title on the output screen.
2. Display instructions for the user.
3. Prompt the user to enter two numbers.
4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
5. Display a terminating message.

## Program 02
### Objectives:
1. Getting string input
2. Designing and implementing a counted loop
3. Designing and implementing a post-test loop
4. Keeping track of a previous value
5. Implementing data validation

###  Description:
Write a program to calculate Fibonacci numbers.
1. Display the program title and programmer’s name. Then get the user’s name, and greet the user.
2. Prompt the user to enter the number of Fibonacci terms to be displayed. Advise the user to enter an integer in the range [1 .. 46].
3. Get and validate the user input (n).
4. Calculate and display all of the Fibonacci numbers up to and including the nth term. The results should be displayed 5 terms per line with at least 5 spaces between terms.
5. Display a parting message that includes the user’s name, and terminate the program.

## Program 03
### Objectives:
More practice with:
1. Implementing data validation
2. Implementing an accumulator
3. Integer arithmetic
4. Defining variables (integer and string)
5. Using library procedures for I/O
6. Implementing control structures (decision, loop, procedure)

### Description:
Write and test a MASM program to perform the following tasks:
1. Display the program title and programmer’s name.
2. Get the user’s name, and greet the user.
3. Display instructions for the user.
4. Repeatedly prompt the user to enter a number.  Validate the user input to be in [-100, -1] (inclusive). Count and accumulate the valid user numbers until a non-negative number is entered.  (The non-negative number is discarded.)
5. Calculate the (rounded integer) average of the negative numbers.
6. Display: 
  i. The number of negative numbers entered  (Note: if no negative numbers were entered, display a special message and skip to iv.)
  ii. The sum of negative numbers entered
  iii. The average, rounded to the nearest integer (e.g. -20.5 rounds to -20)
  iv. A parting message (with the user’s name)

## Program 04
### Objectives:
1. Designing and implementing procedures
2. Designing and implementing loops
3. Writing nested loops
4. Understanding data validation

### Definition:
Write a program to calculate composite numbers: First, the user is instructed to enter the number of composites to be displayed, and is prompted to enter an integer in the range [1 .. 400]. The user enters a number, n, and the program verifies that 1 ≤ n ≤ 400.  If n is out of range, the user is re-prompted until s/he enters a value in the specified range. The program then calculates and displays all of the composite numbers up to and including the nth composite. The results should be displayed 10 composites per line with at least 3 spaces between the numbers.

## Program 05
### Objectives:
1. Using indirect addressing
2. Passing parameters
3. Generating “random” numbers
4. Working with arrays

### Description:
Write and test a MASM program to perform the following tasks:
1. Introduce the program.
2. Get a user request in the range [min = 10 .. max = 200].
3. Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive elements of an array.
4. Display the list of integers before sorting, 10 numbers per line.
5. Sort the list in descending order (i.e., largest first).
6. Calculate and display the median value, rounded to the nearest integer.
7. Display the sorted list, 10 numbers per line.

## Program 06A
### Objectives:
1) Designing, implementing, and calling  low-level I/O procedures
2) Implementing and using a macro

###  Definition:
1. Implement and test your own ReadVal and WriteVal procedures for unsigned integers.
2. Implement macros getString and displayString. The macros may use Irvine’s ReadString to get input from the user, and WriteString to display output.
  i. getString should display a prompt, then get the user’s keyboard input into a memory location
  ii. displayString should the string stored in a specified memory location.
  iii. readVal should invoke the getString macro to get the user’s string of digits. It should then convert the digit string to numeric, while validating the user’s input.
  iv. writeVal should convert a numeric value to a string of digits, and invoke the displayString macro to produce the output.
3. Write a small test program that gets 10 valid integers from the user and stores the numeric values in an array.  The program then displays the integers, their sum, and their average.
