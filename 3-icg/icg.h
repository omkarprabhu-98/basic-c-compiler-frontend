#include <bits/stdc++.h>
#include "table.h"

using namespace std;


/**
 * Struct to store variables required for ICG phase
 */ 
struct icg_container_entry {
    int datatype;
    string temp_var;
    string child_instructions;
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
void push_3addr_code_params(string inst)
{
    
    //pop from back all params and push this and pop that
    if ((intermediate_code.back().find("param"))==string::npos)
    {
        // construct line 
        string line = to_string(next_instr_count++) + " : " + inst;
        intermediate_code.push_back(line);
    }
    else
    {
        vector<string> temp;
        int count = 0;
        while((intermediate_code.back().find("param"))!=string::npos)
        {
            string temp0 = intermediate_code.back().substr(0,intermediate_code.back().find(":")-1);
            int no = stoi(temp0);
            string temp1 = intermediate_code.back().substr(intermediate_code.back().find(":"),intermediate_code.back().size());
            temp.push_back(to_string(no+1)+" "+temp1);
            intermediate_code.pop_back();
            count+=1;
        }
        string line = to_string(next_instr_count-count) + " : " + inst;
        next_instr_count++;
        intermediate_code.push_back(line);
        while(temp.size()>0)
        {
            intermediate_code.push_back(temp.back());
            temp.pop_back();
        }
    }
       
}

/**
 * Generate 3 address code for arithematic expression
 */ 
void gen_3addr_code_arithmetic(icg_container *lhs, icg_container *arg1, icg_container *arg2, string op, int isFor) {
    // get new variable
    lhs->temp_var = "t" + to_string(temp_var_count++);
    // construct instruction
    string inst = lhs->temp_var + " = " + arg1->temp_var + op + arg2->temp_var;
    
	lhs->child_instructions = arg1->child_instructions + arg2->child_instructions + inst + "$";

	if (isFor == 0) {
		// push
    	push_3addr_code_instruction(inst);
	}
}

/**
 * Generate 3 address code for assignment
 */ 
void gen_3addr_code_assignment(icg_container *lhs, icg_container *arg1, int isFor) {
    // construct instruction
    string inst = string(lhs->temp_var) + " = " + arg1->temp_var;

	lhs->child_instructions = arg1->child_instructions + inst + "$";

	if (isFor == 0) {
		// push
    	push_3addr_code_instruction(inst);
	}
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

/**
 * Fills the instruction number in goto slots
 */  
void backpatch(int index, int next_instr) {
	intermediate_code[index].replace(intermediate_code[index].find("_"), 1, to_string(next_instr));
}

/**
 * Fills the FOR increment instructions at the end of FOR body
 */
void backpatch_for_increment(string instr) {
	string delimiter = "$";

	size_t pos = 0;
	string token;
	while ((pos = instr.find(delimiter)) != string::npos) {
		token = instr.substr(0, pos);
		// std::cout << token << std::endl;
		push_3addr_code_instruction(token);
		instr.erase(0, pos + delimiter.length());
	}
}