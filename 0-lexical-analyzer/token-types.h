/**
 * Token types used for lexems identified to be inserted into the Symbol table
*/
enum keywords
{
  INT=100
};

enum identifiers
{
  ID=200
};

enum punctuators
{
  O_BRACES=200,
  C_BRACES,
  O_PARENTHESES,
  C_PARENTHESES,
  O_BRACKETS,
  C_BRACKETS,
  COMMA,
  SEMICOLON
};

enum operators
{
  ADDITION=300,
  SUBTRACTION,
  MULTIPLICATION,
  DIVISION,
  MODULO,
  POWER,
  
  ASSIGN,
  
  EQUALS,
  LESS_THAN,
  GREATER_THAN,
  NOT_EQUAL,
  LESS_THAN_EQUAL_TO,
  GREATER_THAN_EQUAL_TO,

  BITWISE_AND,
  BITWISE_OR,
  LOGICAL_AND,
  LOGICAL_OR,
  LOGICAL_NOT,
  
  LEFT_SHIFT,
  RIGHT_SHIFT

  //CONDITIONAL
};

enum constants
{
  INT_CONST=400,
  STRING_CONST
};

