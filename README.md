# basic c compiler frontend

Analysis Phase (Frontend) for a basic C compiler

## Features
- Handles many features of the C language 
- Error are presented when caught
- Sample test-cases are written

## General Usage Instrutions
```
$ ./run.sh <input_file> 
```

eg.
```
$ ./run.sh test-cases/test_case_0.c 
```


## Folder Structure

This project was build in increments, thus each component is shown as separate folders  modifying code in the previous component to incorporate the current component's functionalities.

- `0-lexical-analyzer`: Lexical Analysis (Lexemes and tokens)
- `1-syntax-analyzer`:	+ Syntax Analysis (Syntax structure checked)
- `2-semantic-analyzer`: + Semantic Analysis (Semantic rules checked)
- `3-icg`: Intermediate Code Generation (Three Address Code)

