#include <bits/stdc++.h>
#include "table.h"

using namespace std;


/**
 * Struct to store variables required for ICG phase
 */ 
struct icg_container_entry {
    int datatype;
    string temp_var;
    
};
typedef struct icg_container_entry icg_container;


int next_instr_count = 0;
int temp_var_count = 0;

// Stores all 3 address code instructions
vector<string> intermediate_code;

/**
 * Push instruction for 3 address code  
 */
void push_3addr_code_instruction(string inst) {
    // construct line 
    string line = to_string(next_instr_count++) + " : " + inst;
    intermediate_code.push_back(line);
}

/**
 * Generate 3 address code for arithematic expression
 */ 
void gen_3addr_code_arithmetic(icg_container *lhs, icg_container *arg1, icg_container *arg2, string op) {
    // get new variable
    lhs->temp_var = "t" + to_string(temp_var_count++);
    // construct instruction
    string inst = lhs->temp_var + " = " + arg1->temp_var + op + arg2->temp_var;
    // push
    push_3addr_code_instruction(inst);
}

/**
 * Generate 3 address code for assignment
 */ 
void gen_3addr_code_assignment(table *lhs, icg_container *arg1) {
    // construct instruction
    string inst = string(lhs->lexeme) + " = " + arg1->temp_var;
    // push
    push_3addr_code_instruction(inst);
}

/**
 * Store intermediate code to file out.code
 */ 
void generate_intermediate_code () {
    ofstream o_file("out.code");
    for (int i = 0; i < intermediate_code.size(); ++i) {
        o_file << intermediate_code[i]<<endl;
    } 
    o_file.close();
}