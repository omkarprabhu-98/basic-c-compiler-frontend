#include <string.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

#define HASH_TABLE_SIZE 100
#define SCOPE_TABLE_SIZE 32

struct table_entry {
    char * lexeme;
    int token_type;
    int data_type;
    struct table_entry * next;
};
typedef struct table_entry table;

struct  scope_table_entry {
    table ** header;
    int parent;
};
typedef struct scope_table_entry scope;

int scope_table_index = 0;
int current_scope_ptr = 0;



scope scope_table[SCOPE_TABLE_SIZE];

/**
 * INIT scope table  
 */
void init() {
    for (int i = 0; i < SCOPE_TABLE_SIZE; ++i) {
        scope_table[i].header = NULL;
        scope_table[i].parent = -1;
    }
}


table ** create_table (void) {
    table ** header = NULL;
    header = (table **) malloc(sizeof(table *) * HASH_TABLE_SIZE);
    for( int i = 0; i < HASH_TABLE_SIZE; ++i) {
        header[i] = NULL;
    }
    return header;
}

int create_scope() {
    ++scope_table_index;
    scope_table[scope_table_index].header = create_table();
    scope_table[scope_table_index].parent = current_scope_ptr;

    return scope_table_index;      
}

int exit_scope() {
    return scope_table[current_scope_ptr].parent;
}

/**
 * Hash function
 */
unsigned int hash( char *lexeme) {
    unsigned int i;
    unsigned int hash;

	/* Apply jenkin's hash function
	* https://en.wikipedia.org/wiki/Jenkins_hash_function#one-at-a-time
	*/

	for ( hash = i = 0; i < strlen(lexeme); ++i ) {
        hash += lexeme[i];
        hash += ( hash << 10 );
        hash ^= ( hash >> 6 );
    }
	hash += ( hash << 3 );
	hash ^= ( hash >> 11 );
    hash += ( hash << 15 );

	return hash % HASH_TABLE_SIZE;
}

/**
 * Search in the current table whether entry exists 
 */
table* search (table ** header,char * lexeme) {
    unsigned int hashed = hash(lexeme);
    table * look = header[hashed];
    while(look!=NULL) {
        if (strcmp(look->lexeme, lexeme) == 0) {
            return look;
        }
        look = look->next;
    }
    return NULL;
}

/**
 * Insert into symbol table for current scope 
 */
table * insert (table ** header, char * lexeme, int token_type, int data_type) {
    table * new_entry = search(header, lexeme); 
    if(new_entry != NULL)
        return NULL;
    
    unsigned int hashed = hash(lexeme);
    new_entry = (table *) malloc(sizeof(table));
    new_entry->lexeme = (char *) malloc(sizeof(lexeme));
    strcpy(new_entry->lexeme, lexeme);
    new_entry->token_type = token_type;
    new_entry->data_type = data_type;
    new_entry->next = header[hashed];
    header[hashed] = new_entry;
    return header[hashed];
}

/**
 * Dislpay the SYMBOL table 
 */
void display_sym_table (table ** header) {
	printf("%-20s\t%-30s\t%-20s\n", "LEXEME", "Id", "DATATYPE");
    printf("%-20s\t%-30s\t%-20s\n", "------", "--", "-------");
    
	for(int i = 0; i < HASH_TABLE_SIZE; ++i) {
		table * ptr = header[i];
		while(ptr!=NULL) {
            printf("%-20s\t%-30d\t%-30d\n",ptr->lexeme, ptr->token_type,ptr->data_type);
            ptr = ptr->next;
        }
    }
}

/**
 * Dislpay the SYMBOL table 
 */
void display_const_table (table ** header) {
	printf("\n\n======================== CONSTANT TABLE ======================\n");

	printf("%-20s\t%-30s\n", "LEXEME", "Id");
    printf("%-20s\t%-30s\n", "------", "--");
    
	for(int i = 0; i < HASH_TABLE_SIZE; ++i) {
		table * ptr = header[i];
		while(ptr!=NULL) {
            printf("%-20s\t%-30d\n",ptr->lexeme, ptr->token_type);
            ptr = ptr->next;
        }
    }
}

/**
 * Display all the symbol tables for all scopes 
 */
void display_scope_table() {
    printf("\n======================== SYMBOL TABLE ======================\n");
    for(int i = 0; i < SCOPE_TABLE_SIZE; ++i) {
        if (scope_table[i].header == NULL) 
            return;
        printf("===============> LEVEL %d <===============\n", i);
		display_sym_table(scope_table[i].header);
    }
}