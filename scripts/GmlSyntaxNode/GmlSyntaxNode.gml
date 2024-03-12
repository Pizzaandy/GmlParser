// Modify these to suit your needs

function GmlSyntaxNode(_start, _end) constructor {
    kind = "unknown";
    start_index = _start;
    end_index = _end;
    //parent = undefined;
    
    if (argument_count > 2) {
        for (var i = 2; i < argument_count; i++) {
            add_child(argument[i]);
        }
    }
    
    static add_child = function(_node) {
        
        //if (is_undefined(_node)) {
        //    return undefined;   
        //}
        
        //if (is_array(_node)) {
        //    array_foreach(_node, function(n) {n.parent = self;})
        //} else {
        //    _node.parent = self;
        //}
        
        return _node;
    }
}

function Document(_start, _end, _statements): GmlSyntaxNode(_start, _end) constructor {
    kind = "document";
    statements = _statements;
}

function Block(_start, _end, _statements): GmlSyntaxNode(_start, _end) constructor {
    kind = "block";
    statements = _statements;
}

function FunctionDeclaration(_start, _end, _identifier, _parameters, _body, _constructor_clause): GmlSyntaxNode(_start, _end) constructor {
    kind = "function";
    identifier = _identifier;
    parameters = _parameters;
    body = _body;
    parent = _constructor_clause;
}

function ConstructorClause(_start, _end, _identifier, _arguments) {
    kind = "constructor_clause"
    identifier = _identifier;
    arguments = _arguments;
}

function VariableDeclarationList(_start, _end, _declarations, _modifier): GmlSyntaxNode(_start, _end) constructor {
    kind = "variable_declaration_list"
    declarations = _declarations;
    modifier = _modifier;
}

function VariableDeclaration(_start, _end, _name, _initializer): GmlSyntaxNode(_start, _end) constructor {
    kind = "assignment";
    name = _name;
    initializer = _initializer;
}

function AssignmentExpression(_start, _end, _operator, _lhs, _rhs): GmlSyntaxNode(_start, _end) constructor {
    kind = "assignment";
    operator = _operator;
    left = _lhs;
    right = _rhs;
}

function IfStatement(_start, _end, _condition, _statement, _alternate): GmlSyntaxNode(_start, _end) constructor {
    kind = "if";
    condition = _condition;
    statement = _statement;
    alternate = _alternate;
}

function ForStatement(_start, _end, _init, _test, _update, _body): GmlSyntaxNode(_start, _end) constructor {
    kind = "for";
    init = _init;
    test = _test;
    update = _update;
    body = _body;
}

function SwitchStatement(_start, _end, _expression, _cases): GmlSyntaxNode(_start, _end) constructor {
    kind = "switch";
    expression = _expression;
    cases = _cases;
}

function SwitchCase(_start, _end, _test, _statements): GmlSyntaxNode(_start, _end) constructor {
    kind = "switch_case";
    test = _test;
    statements = _statements;
}

function DoStatement(_start, _end, _body, _test): GmlSyntaxNode(_start, _end) constructor {
    kind = "do";
    body = _body;
    test = _test;
}

function WhileStatement(_start, _end, _body, _test): GmlSyntaxNode(_start, _end) constructor {
    kind = "while";
    body = _body;
    test = _test;
}

function RepeatStatement(_start, _end, _body, _expression): GmlSyntaxNode(_start, _end) constructor {
    kind = "repeat";
    body = _body;
    expression = _expression;
}

function WithStatement(_start, _end, _body, _expression): GmlSyntaxNode(_start, _end) constructor {
    kind = "with";
    body = _body;
    expression = _expression;
}

function ContinueStatement(_start, _end): GmlSyntaxNode(_start, _end) constructor {
    kind = "continue";
}

function BreakStatement(_start, _end): GmlSyntaxNode(_start, _end) constructor {
    kind = "break";
}

function ExitStatement(_start, _end): GmlSyntaxNode(_start, _end) constructor {
    kind = "exit";
}

function ReturnStatement(_start, _end, _expression): GmlSyntaxNode(_start, _end) constructor {
    kind = "return";
    expression = _expression;
}

function ThrowStatement(_start, _end, _expression): GmlSyntaxNode(_start, _end) constructor {
    kind = "throw";
    expression = _expression;
}

function DeleteStatement(_start, _end, _expression): GmlSyntaxNode(_start, _end) constructor {
    kind = "delete";
    expression = _expression;
}

function RegionStatement(_start, _end, _name, _is_end_region): GmlSyntaxNode(_start, _end) constructor {
    kind = _is_end_region ? "endregion" : "region";
    name = _name;
}

function UnaryExpression(_start, _end, _operator, _expression, _is_prefix): GmlSyntaxNode(_start, _end) constructor {
    kind = "unary_expression";
    operator = _operator;
    expression = _expression;
    is_prefix = _is_prefix;
}

function MemberIndexExpression(_start, _end, _object, _properties, _accessor): GmlSyntaxNode(_start, _end) constructor {
    kind = "member_index";
    object = _object;
    properties = _properties;
    accessor = _accessor;
}

function MemberDotExpression(_start, _end, _object, _identifier): GmlSyntaxNode(_start, _end) constructor {
    kind = "member_dot";
    object = _object;
    property = _identifier;
}

function NewExpression(_start, _end, _argument): GmlSyntaxNode(_start, _end) constructor {
    kind = "new_expression";
    expression = _argument;
}

//function ParenthesizedExpression(_start, _end, _argument): GmlSyntaxNode(_start, _end) constructor {
//    kind = "parenthesized_expression";
//    expression = _argument;
//}

function ConditionalExpression(_start, _end, _when_true, _when_false): GmlSyntaxNode(_start, _end) constructor {
    kind = "conditional_expression";
    when_true = _when_true;
    when_false = _when_false;
}

function BinaryExpression(_start, _end, _operator, _lhs, _rhs): GmlSyntaxNode(_start, _end) constructor {
    kind = "binary_expression";
    operator = _operator;
    left = _lhs;
    right = _rhs;
}

function CallExpression(_start, _end, _object, _arguments): GmlSyntaxNode(_start, _end) constructor {
    kind = "call_expression";
    object = _object;
    arguments = _arguments;
}

function TryStatement(_start, _end, _try, _catch, _finally): GmlSyntaxNode(_start, _end) constructor {
    kind = "try";
    try_block = _try;
    catch_clause = _catch;
    finally_block = _finally;
}

function CatchClause(_start, _end, _variable, _block): GmlSyntaxNode(_start, _end) constructor {
    kind = "catch_clause";
    variable = _variable;
    body = _block;
}

function Identifier(_start, _end, _name): GmlSyntaxNode(_start, _end) constructor {
    kind = "identifier";
    name = _name;
}

function ArrayLiteral(_start, _end, _values): GmlSyntaxNode(_start, _end) constructor {
    kind = "array";
    values = _values;
}

function StructLiteral(_start, _end, _props): GmlSyntaxNode(_start, _end) constructor {
    kind = "array";
    properties = _props;
}

function StructProperty(_start, _end, _name, _initializer): GmlSyntaxNode(_start, _end) constructor {
    kind = "property_assignment";
    name = _name;
    initializer = _initializer;
}

function UndefinedLiteral(_start, _end): GmlSyntaxNode(_start, _end) constructor {
    kind = "undefined";
}

function NoOneLiteral(_start, _end): GmlSyntaxNode(_start, _end) constructor {
    kind = "noone";
}

function IntegerLiteral(_start, _end, _value): GmlSyntaxNode(_start, _end) constructor {
    kind = "integer";
    value = _value;
}

function BooleanLiteral(_start, _end, _value): GmlSyntaxNode(_start, _end) constructor {
    kind = "boolean";
    value = _value;
}

function BinaryLiteral(_start, _end, _value): GmlSyntaxNode(_start, _end) constructor {
    kind = "binary_literal";
    value = _value;
}

function DecimalLiteral(_start, _end, _value): GmlSyntaxNode(_start, _end) constructor {
    kind = "decimal";
    value = _value;
}

function StringLiteral(_start, _end, _value): GmlSyntaxNode(_start, _end) constructor {
    kind = "string";
    value = _value;
}

function VerbatimStringLiteral(_start, _end, _value): GmlSyntaxNode(_start, _end) constructor {
    kind = "string";
    value = _value;
}

function TemplateStringLiteral(_start, _end, _atoms): GmlSyntaxNode(_start, _end) constructor {
    kind = "template_string";
    atoms = _atoms;
}
