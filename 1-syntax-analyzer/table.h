#include <string.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

struct table_entry {
    char * lexeme;
    int token_type;
    struct table_entry * next;
};

typedef struct table_entry table;
#define HASH_TABLE_SIZE 100

table ** create_table (void) {
    table ** header = NULL;
    header = (table **) malloc(sizeof(table *) * HASH_TABLE_SIZE);
    for( int i = 0; i < HASH_TABLE_SIZE; ++i) {
        header[i] = NULL;
    }
    return header;
}

unsigned int hash( char *lexeme ) {
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

int search (table ** header,char * lexeme) {
    unsigned int hashed = hash(lexeme);
    table * look = header[hashed];
    while(look!=NULL && strcmp(look->lexeme, lexeme) != 0) {
        look = look->next;
    }
    if(look == NULL) {
        return 0;
    }
    return 1;
}

table * insert (table ** header, char * lexeme, int token_type) {
    if(search(header, lexeme))
        return NULL;
    
    table * new_entry = NULL;
    unsigned int hashed = hash(lexeme);
    new_entry = (table *) malloc(sizeof(table));
    new_entry->lexeme = (char *) malloc(sizeof(lexeme));
    strcpy(new_entry->lexeme, lexeme);
    new_entry->token_type = token_type;
    new_entry->next = header[hashed];
    header[hashed] = new_entry;
    return header[hashed];
}

void display (table ** header) {
	printf("\n\nSymbol Table \n\n");
    for(int i = 0; i < HASH_TABLE_SIZE; ++i) {
        table * ptr = header[i];
        while(ptr!=NULL) {
            printf("%s %d\n",ptr->lexeme, ptr->token_type);
            ptr = ptr->next;
        }
    }
}