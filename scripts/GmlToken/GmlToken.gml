function GmlToken(_text, _kind, _line, _column, _start_index, _end_index) constructor {
    text = _text;
    kind = _kind;
    line = _line;
    column = _column;
    start_index = _start_index;
    end_index = _end_index;
}

enum GmlTokenKind {
    SINGLE_LINE_COMMENT,
    MULTI_LINE_COMMENT,
    OPEN_BRACKET,
    LIST_ACCESSOR,
    MAP_ACCESSOR,
    GRID_ACCESSOR,
    ARRAY_ACCESSOR,
    STRUCT_ACCESSOR,
    CLOSE_BRACKET,
    OPEN_PAREN,
    CLOSE_PAREN,
    OPEN_BRACE,
    CLOSE_BRACE,
    SEMI_COLON,
    COMMA,
    ASSIGN,
    COLON,
    DOT,
    PLUS_PLUS,
    MINUS_MINUS,
    PLUS,
    MINUS,
    BIT_NOT,
    NOT,
    MULTIPLY,
    DIVIDE,
    INTEGER_DIVIDE,
    MODULO,
    POWER,
    QUESTION_MARK,
    NULL_COALESCE,
    NULL_COALESCING_ASSIGN,
    RIGHT_SHIFT_ARITHMETIC,
    LEFT_SHIFT_ARITHMETIC,
    LESS_THAN,
    GREATER_THAN,
    LESS_THAN_EQUALS,
    GREATER_THAN_EQUALS,
    EQUALS,
    NOT_EQUALS,
    BIT_AND,
    BIT_XOR,
    BIT_OR,
    AND,
    OR,
    XOR,
    MULTIPLY_ASSIGN,
    DIVIDE_ASSIGN,
    PLUS_ASSIGN,
    MINUS_ASSIGN,
    MODULUS_ASSIGN,
    LEFT_SHIFT_ARITHMETIC_ASSIGN,
    RIGHT_SHIFT_ARITHMETIC_ASSIGN,
    BIT_AND_ASSIGN,
    BIT_XOR_ASSIGN,
    BIT_OR_ASSIGN,
    NUMBER_SIGN,
    DOLLAR_SIGN,
    AT_SIGN,
    IDENTIFIER,
    BOOLEAN_LITERAL,
    INTEGER_LITERAL,
    DECIMAL_LITERAL,
    BINARY_LITERAL,
    HEX_INTEGER_LITERAL,
    STRING_LITERAL,
    VERBATIM_STRING_LITERAL,
    UNDEFINED,
    NOONE,
    BREAK,
    EXIT,
    DO,
    CASE,
    ELSE,
    NEW,
    VAR,
    GLOBAL_VAR,
    CATCH,
    FINALLY,
    RETURN,
    CONTINUE,
    FOR,
    SWITCH,
    WHILE,
    UNTIL,
    REPEAT,
    FUNCTION,
    WITH,
    DEFAULT,
    IF,
    THEN,
    THROW,
    DELETE,
    TRY,
    ENUM,
    CONSTRUCTOR,
    STATIC,
    MACRO,
    DEFINE,
    REGION,
    END_REGION,
    REGION_NAME,
    UNKNOWN_DIRECTIVE,
    BACKSLASH,
    TEMPLATE_START,
    TEMPLATE_MIDDLE,
    TEMPLATE_END,
    SIMPLE_TEMPLATE_STRING,
    LINE_BREAK,
    WHITESPACE,
    EOF,
    UNEXPECTED,
}