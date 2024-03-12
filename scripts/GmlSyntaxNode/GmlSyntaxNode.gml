// Modify these to suit your needs

function GmlSyntaxNode(_start, _end) constructor {
	kind = "unknown";
	start_index = _start;
	end_index = _end;
	// parent = undefined;

	if (argument_count > 2) {
		for (var i = 2; i < argument_count; i++) {
			add_child(argument[i]);
		}
	}

	static add_child = function(_node) {
		// if (is_undefined(_node)) {
		//    return undefined;
		// }

		// if (is_array(_node)) {
		//    array_foreach(_node, function(n) {n.parent = self;})
		// } else {
		//    _node.parent = self;
		// }

		return _node;
	};
}

function GmlDocument(_start, _end, _statements) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "document";
	statements = _statements;
}

function GmlBlock(_start, _end, _statements) : GmlSyntaxNode(_start, _end) constructor {
	kind = "block";
	statements = _statements;
}

function GmlFunctionDeclaration(
	_start,
	_end,
	_identifier,
	_parameters,
	_body,
	_constructor_clause
) : GmlSyntaxNode(_start, _end) constructor {
	kind = "function";
	identifier = _identifier;
	parameters = _parameters;
	body = _body;
	parent = _constructor_clause;
}

function GmlConstructorClause(_start, _end, _identifier, _arguments) {
	kind = "constructor_clause";
	identifier = _identifier;
	arguments = _arguments;
}

function GmlVariableDeclarationList(
	_start,
	_end,
	_declarations,
	_modifier
) : GmlSyntaxNode(_start, _end) constructor {
	kind = "variable_declaration_list";
	declarations = _declarations;
	modifier = _modifier;
}

function GmlVariableDeclaration(_start, _end, _name, _initializer) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "assignment";
	name = _name;
	initializer = _initializer;
}

function GmlAssignmentExpression(_start, _end, _operator, _lhs, _rhs) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "assignment";
	operator = _operator;
	left = _lhs;
	right = _rhs;
}

function GmlIfStatement(_start, _end, _condition, _statement, _alternate) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "if";
	condition = _condition;
	statement = _statement;
	alternate = _alternate;
}

function GmlForStatement(_start, _end, _init, _test, _update, _body) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "for";
	init = _init;
	test = _test;
	update = _update;
	body = _body;
}

function GmlSwitchStatement(_start, _end, _expression, _cases) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "switch";
	expression = _expression;
	cases = _cases;
}

function GmlSwitchCase(_start, _end, _test, _statements) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "switch_case";
	test = _test;
	statements = _statements;
}

function GmlDoStatement(_start, _end, _body, _test) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "do";
	body = _body;
	test = _test;
}

function GmlWhileStatement(_start, _end, _body, _test) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "while";
	body = _body;
	test = _test;
}

function GmlRepeatStatement(_start, _end, _body, _expression) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "repeat";
	body = _body;
	expression = _expression;
}

function GmlWithStatement(_start, _end, _body, _expression) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "with";
	body = _body;
	expression = _expression;
}

function GmlContinueStatement(_start, _end) : GmlSyntaxNode(_start, _end) constructor {
	kind = "continue";
}

function GmlBreakStatement(_start, _end) : GmlSyntaxNode(_start, _end) constructor {
	kind = "break";
}

function GmlExitStatement(_start, _end) : GmlSyntaxNode(_start, _end) constructor {
	kind = "exit";
}

function GmlReturnStatement(_start, _end, _expression) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "return";
	expression = _expression;
}

function GmlThrowStatement(_start, _end, _expression) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "throw";
	expression = _expression;
}

function GmlDeleteStatement(_start, _end, _expression) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "delete";
	expression = _expression;
}

function GmlRegionStatement(_start, _end, _name, _is_end_region) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = _is_end_region ? "endregion" : "region";
	name = _name;
}

function GmlUnaryExpression(
	_start,
	_end,
	_operator,
	_expression,
	_is_prefix
) : GmlSyntaxNode(_start, _end) constructor {
	kind = "unary_expression";
	operator = _operator;
	expression = _expression;
	is_prefix = _is_prefix;
}

function GmlMemberIndexExpression(
	_start,
	_end,
	_object,
	_properties,
	_accessor
) : GmlSyntaxNode(_start, _end) constructor {
	kind = "member_index";
	object = _object;
	properties = _properties;
	accessor = _accessor;
}

function GmlMemberDotExpression(_start, _end, _object, _identifier) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "member_dot";
	object = _object;
	property = _identifier;
}

function GmlNewExpression(_start, _end, _argument) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "new_expression";
	expression = _argument;
}

// function ParenthesizedExpression(_start, _end, _argument): GmlSyntaxNode(_start, _end) constructor {
//    kind = "parenthesized_expression";
//    expression = _argument;
// }

function GmlConditionalExpression(_start, _end, _when_true, _when_false) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "conditional_expression";
	when_true = _when_true;
	when_false = _when_false;
}

function GmlBinaryExpression(_start, _end, _operator, _lhs, _rhs) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "binary_expression";
	operator = _operator;
	left = _lhs;
	right = _rhs;
}

function GmlCallExpression(_start, _end, _object, _arguments) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "call_expression";
	object = _object;
	arguments = _arguments;
}

function GmlTryStatement(_start, _end, _try, _catch, _finally) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "try";
	try_block = _try;
	catch_clause = _catch;
	finally_block = _finally;
}

function GmlCatchClause(_start, _end, _variable, _block) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "catch_clause";
	variable = _variable;
	body = _block;
}

function GmlIdentifier(_start, _end, _name) : GmlSyntaxNode(_start, _end) constructor {
	kind = "identifier";
	name = _name;
}

function GmlArrayLiteral(_start, _end, _values) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "array";
	values = _values;
}

function GmlStructLiteral(_start, _end, _props) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "array";
	properties = _props;
}

function GmlStructProperty(_start, _end, _name, _initializer) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "property_assignment";
	name = _name;
	initializer = _initializer;
}

function GmlUndefinedLiteral(_start, _end) : GmlSyntaxNode(_start, _end) constructor {
	kind = "undefined";
}

function GmlNoOneLiteral(_start, _end) : GmlSyntaxNode(_start, _end) constructor {
	kind = "noone";
}

function GmlIntegerLiteral(_start, _end, _value) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "integer";
	value = _value;
}

function GmlBooleanLiteral(_start, _end, _value) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "boolean";
	value = _value;
}

function GmlBinaryLiteral(_start, _end, _value) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "binary_literal";
	value = _value;
}

function GmlDecimalLiteral(_start, _end, _value) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "decimal";
	value = _value;
}

function GmlStringLiteral(_start, _end, _value) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "string";
	value = _value;
}

function GmlVerbatimStringLiteral(_start, _end, _value) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "string";
	value = _value;
}

function GmlTemplateStringLiteral(_start, _end, _atoms) : GmlSyntaxNode(
	_start,
	_end
) constructor {
	kind = "template_string";
	atoms = _atoms;
}
