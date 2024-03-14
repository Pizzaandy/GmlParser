// Modify these to suit your needs

function GmlSyntaxNode(_span) constructor {
	kind = "unknown";
	span = _span;
	// parent = undefined;

	if (argument_count > 1) {
		for (var i = 1; i < argument_count; i++) {
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

function GmlDocument(_span, _statements) : GmlSyntaxNode(_span) constructor {
	kind = "document";
	statements = _statements;
}

function GmlBlock(_span, _statements) : GmlSyntaxNode(_span) constructor {
	kind = "block";
	statements = _statements;
}

function GmlFunctionDeclaration(
	_span,
	_identifier,
	_parameters,
	_body,
	_constructor_clause
) : GmlSyntaxNode(_span) constructor {
	kind = "function";
	identifier = _identifier;
	parameters = _parameters;
	body = _body;
	parent = _constructor_clause;
}

function GmlConstructorClause(_span, _identifier, _arguments) : GmlSyntaxNode(
	_span
) constructor {
	kind = "constructor_clause";
	identifier = _identifier;
	arguments = _arguments;
}

function GmlVariableDeclarationList(_span, _declarations, _modifier) : GmlSyntaxNode(
	_span
) constructor {
	kind = "variable_declaration_list";
	declarations = _declarations;
	modifier = _modifier;
}

function GmlVariableDeclaration(_span, _name, _initializer) : GmlSyntaxNode(
	_span
) constructor {
	kind = "assignment";
	name = _name;
	initializer = _initializer;
}

function GmlAssignmentExpression(_span, _operator, _lhs, _rhs) : GmlSyntaxNode(
	_span
) constructor {
	kind = "assignment";
	operator = _operator;
	left = _lhs;
	right = _rhs;
}

function GmlIfStatement(_span, _condition, _statement, _alternate) : GmlSyntaxNode(
	_span
) constructor {
	kind = "if";
	condition = _condition;
	statement = _statement;
	alternate = _alternate;
}

function GmlForStatement(_span, _init, _test, _update, _body) : GmlSyntaxNode(
	_span
) constructor {
	kind = "for";
	init = _init;
	test = _test;
	update = _update;
	body = _body;
}

function GmlSwitchStatement(_span, _expression, _cases) : GmlSyntaxNode(
	_span
) constructor {
	kind = "switch";
	expression = _expression;
	cases = _cases;
}

function GmlSwitchCase(_span, _test, _statements) : GmlSyntaxNode(_span) constructor {
	kind = "switch_case";
	test = _test;
	statements = _statements;
}

function GmlDoStatement(_span, _body, _test) : GmlSyntaxNode(_span) constructor {
	kind = "do";
	body = _body;
	test = _test;
}

function GmlWhileStatement(_span, _body, _test) : GmlSyntaxNode(_span) constructor {
	kind = "while";
	body = _body;
	test = _test;
}

function GmlRepeatStatement(_span, _body, _expression) : GmlSyntaxNode(
	_span
) constructor {
	kind = "repeat";
	body = _body;
	expression = _expression;
}

function GmlWithStatement(_span, _body, _expression) : GmlSyntaxNode(_span) constructor {
	kind = "with";
	body = _body;
	expression = _expression;
}

function GmlContinueStatement(_span) : GmlSyntaxNode(_span) constructor {
	kind = "continue";
}

function GmlBreakStatement(_span) : GmlSyntaxNode(_span) constructor {
	kind = "break";
}

function GmlExitStatement(_span) : GmlSyntaxNode(_span) constructor {
	kind = "exit";
}

function GmlReturnStatement(_span, _expression) : GmlSyntaxNode(_span) constructor {
	kind = "return";
	expression = _expression;
}

function GmlThrowStatement(_span, _expression) : GmlSyntaxNode(_span) constructor {
	kind = "throw";
	expression = _expression;
}

function GmlDeleteStatement(_span, _expression) : GmlSyntaxNode(_span) constructor {
	kind = "delete";
	expression = _expression;
}

function GmlRegionStatement(_span, _name, _is_end_region) : GmlSyntaxNode(
	_span
) constructor {
	kind = _is_end_region ? "endregion" : "region";
	name = _name;
}

function GmlUnaryExpression(_span, _operator, _expression, _is_prefix) : GmlSyntaxNode(
	_span
) constructor {
	kind = "unary_expression";
	operator = _operator;
	expression = _expression;
	is_prefix = _is_prefix;
}

function GmlMemberIndexExpression(_span, _object, _properties, _accessor) : GmlSyntaxNode(
	_span
) constructor {
	kind = "member_index";
	object = _object;
	properties = _properties;
	accessor = _accessor;
}

function GmlMemberDotExpression(_span, _object, _identifier) : GmlSyntaxNode(
	_span
) constructor {
	kind = "member_dot";
	object = _object;
	property = _identifier;
}

function GmlNewExpression(_span, _argument) : GmlSyntaxNode(_span) constructor {
	kind = "new_expression";
	expression = _argument;
}

// function ParenthesizedExpression(_start, _end, _argument): GmlSyntaxNode(_start, _end) constructor {
//    kind = "parenthesized_expression";
//    expression = _argument;
// }

function GmlConditionalExpression(_span, _when_true, _when_false) : GmlSyntaxNode(
	_span
) constructor {
	kind = "conditional_expression";
	when_true = _when_true;
	when_false = _when_false;
}

function GmlBinaryExpression(_span, _operator, _lhs, _rhs) : GmlSyntaxNode(
	_span
) constructor {
	kind = "binary_expression";
	operator = _operator;
	left = _lhs;
	right = _rhs;
}

function GmlCallExpression(_span, _object, _arguments) : GmlSyntaxNode(
	_span
) constructor {
	kind = "call_expression";
	object = _object;
	arguments = _arguments;
}

function GmlTryStatement(_span, _try, _catch, _finally) : GmlSyntaxNode(
	_span
) constructor {
	kind = "try";
	try_block = _try;
	catch_clause = _catch;
	finally_block = _finally;
}

function GmlCatchClause(_span, _variable, _block) : GmlSyntaxNode(_span) constructor {
	kind = "catch_clause";
	variable = _variable;
	body = _block;
}

function GmlEnumDeclaration(_span, _members) : GmlSyntaxNode(_span) constructor {
	kind = "enum";
	members = _members;
}

function GmlEnumMember(_span, _name, _initializer) : GmlSyntaxNode(_span) constructor {
	kind = "enum_member";
	name = _name;
	initializer = _initializer;
}

function GmlIdentifier(_span, _name) : GmlSyntaxNode(_span) constructor {
	kind = "identifier";
	name = _name;
}

function GmlArrayLiteral(_span, _values) : GmlSyntaxNode(_span) constructor {
	kind = "array";
	values = _values;
}

function GmlStructLiteral(_span, _props) : GmlSyntaxNode(_span) constructor {
	kind = "array";
	properties = _props;
}

function GmlStructProperty(_span, _name, _initializer) : GmlSyntaxNode(
	_span
) constructor {
	kind = "property_assignment";
	name = _name;
	initializer = _initializer;
}

function GmlUndefinedLiteral(_span) : GmlSyntaxNode(_span) constructor {
	kind = "undefined";
}

function GmlNoOneLiteral(_span) : GmlSyntaxNode(_span) constructor {
	kind = "noone";
}

function GmlIntegerLiteral(_span, _value) : GmlSyntaxNode(_span) constructor {
	kind = "integer";
	value = _value;
}

function GmlBooleanLiteral(_span, _value) : GmlSyntaxNode(_span) constructor {
	kind = "boolean";
	value = _value;
}

function GmlBinaryLiteral(_span, _value) : GmlSyntaxNode(_span) constructor {
	kind = "binary_literal";
	value = _value;
}

function GmlDecimalLiteral(_span, _value) : GmlSyntaxNode(_span) constructor {
	kind = "decimal";
	value = _value;
}

function GmlStringLiteral(_span, _value) : GmlSyntaxNode(_span) constructor {
	kind = "string";
	value = _value;
}

function GmlVerbatimStringLiteral(_span, _value) : GmlSyntaxNode(_span) constructor {
	kind = "string";
	value = _value;
}

function GmlTemplateStringLiteral(_span, _parts) : GmlSyntaxNode(_span) constructor {
	kind = "template_string";
	parts = _parts;
}
