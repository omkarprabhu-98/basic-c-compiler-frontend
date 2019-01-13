struct table {
    char    *lexeme;
    char    *type;
    int     id;
    struct table *next;
};

struct table *head = NULL;

void insert_table (char *lexeme, char *type, int id) {
    if(head == NULL) {
        
        // First Entry
        struct table *newNode = (struct table *) malloc(sizeof(struct table));
        newNode->next = NULL;
        head = newNode;
        newNode->lexeme = (char *) malloc(sizeof(char)*strlen(lexeme));
        newNode->type = (char *) malloc(sizeof(char)*strlen(type));
        strcpy(newNode->lexeme,lexeme);
        strcpy(newNode->type,type);
    }
    else{
        struct table* current = head;
        // Check for existing values
        while(1) {
            if(strcmp(current->lexeme,lexeme) == 0) return;
            // Value exists
            if(current->next == NULL) break;
            current = current->next;
        }
        struct table *newNode = (struct table *) malloc(sizeof(struct table));
        newNode->next = NULL;
        newNode->lexeme = (char *) malloc(sizeof(char)*strlen(lexeme));
        newNode->type = (char *) malloc(sizeof(char)*strlen(type));
        strcpy(newNode->lexeme,lexeme);
        strcpy(newNode->type,type);
        current->next = newNode;
    }
}

void print_table () {
    struct table *current = head;
    while(current != NULL) {    
        printf("%s\t%s\t%d\n", current->lexeme, current->type, current->id);
        current = current->next;
    }
}