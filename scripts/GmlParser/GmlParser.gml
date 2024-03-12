function GmlParser(_code, _tab_width = 4) constructor {
	lexer = new GmlLexer(_code, _tab_width);
	hit_eof = false;
	accepted = -1;
	token = -1;
	column_number = 0;
	line_number = 1;
	next_token();

	static __assignment_operators = [
		GmlTokenKind.ASSIGN,
		GmlTokenKind.MULTIPLY_ASSIGN,
		GmlTokenKind.DIVIDE_ASSIGN,
		GmlTokenKind.PLUS_ASSIGN,
		GmlTokenKind.MINUS_ASSIGN,
		GmlTokenKind.MODULUS_ASSIGN,
		GmlTokenKind.LEFT_SHIFT_ARITHMETIC_ASSIGN,
		GmlTokenKind.RIGHT_SHIFT_ARITHMETIC_ASSIGN,
		GmlTokenKind.BIT_AND_ASSIGN,
		GmlTokenKind.BIT_XOR_ASSIGN,
		GmlTokenKind.BIT_OR_ASSIGN,
		GmlTokenKind.NULL_COALESCING_ASSIGN
	];

	static __prefix_operators = [
		GmlTokenKind.PLUS,
		GmlTokenKind.MINUS,
		GmlTokenKind.NOT,
		GmlTokenKind.BIT_NOT,
		GmlTokenKind.PLUS_PLUS,
		GmlTokenKind.MINUS_MINUS
	];

	static __accessors = [
		GmlTokenKind.OPEN_BRACKET,
		GmlTokenKind.ARRAY_ACCESSOR,
		GmlTokenKind.LIST_ACCESSOR,
		GmlTokenKind.MAP_ACCESSOR,
		GmlTokenKind.GRID_ACCESSOR,
		GmlTokenKind.ARRAY_ACCESSOR,
		GmlTokenKind.STRUCT_ACCESSOR
	];

	static __equality_operators = [
		GmlTokenKind.EQUALS,
		GmlTokenKind.ASSIGN,
		GmlTokenKind.NOT_EQUALS
	];

	static __relational_operators = [
		GmlTokenKind.LESS_THAN,
		GmlTokenKind.GREATER_THAN,
		GmlTokenKind.LESS_THAN_EQUALS,
		GmlTokenKind.GREATER_THAN_EQUALS
	];

	static __shift_operators = [
		GmlTokenKind.LEFT_SHIFT_ARITHMETIC,
		GmlTokenKind.RIGHT_SHIFT_ARITHMETIC
	];

	static __multiplicative_operators = [
		GmlTokenKind.MULTIPLY,
		GmlTokenKind.DIVIDE,
		GmlTokenKind.MODULO,
		GmlTokenKind.INTEGER_DIVIDE
	];

	static __additive_operators = [GmlTokenKind.PLUS, GmlTokenKind.MINUS];

	static throw_syntax_error = function(_message) {
		throw _message;
	};

	static get_ast = function(pretty = true) {
		return json_stringify(parse(), pretty);
	};

	static parse = function() {
		return document();
	};

	static next_token = function() {
		token = lexer.next_token();
		line_number = token.line;
		column_number = token.column;
		process_token(token);
		hit_eof = token.kind == GmlTokenKind.EOF;
	};

	static accept = function(_kind, _skip_hidden_tokens = true) {
		if (_skip_hidden_tokens) {
			while (!hit_eof && is_hidden_token(token)) {
				next_token();
			}
		}

		if (token.kind == _kind) {
			accepted = token;
			next_token();
			return true;
		}

		return false;
	};

	static accept_any = function(_kind_array) {
		for (var i = 0; i < array_length(_kind_array); i++) {
			if (accept(_kind_array[i])) {
				return true;
			}
		}
		return false;
	};

	static expect = function(_kind, _skip_hidden_tokens = true) {
		if (!accept(_kind, _skip_hidden_tokens)) {
			throw_expected(_kind);
		}
	};

	static expect_defined = function(_node) {
		if (is_undefined(_node)) {
			throw_default_syntax_error();
		}
		return _node;
	};

	static is_hidden_token = function(_token) {
		return _token.kind == GmlTokenKind.WHITESPACE
			|| _token.kind == GmlTokenKind.LINE_BREAK
			|| _token.kind == GmlTokenKind.SINGLE_LINE_COMMENT
			|| _token.kind == GmlTokenKind.MULTI_LINE_COMMENT
			|| _token.kind == GmlTokenKind.REGION
			|| _token.kind == GmlTokenKind.END_REGION
			|| _token.kind == GmlTokenKind.REGION_NAME;
	};

	static throw_default_syntax_error = function(_token) {
		_token ??= token;
		var symbol_text = _token.kind == GmlTokenKind.EOF
			? "end of file"
			: $"'{_token.text}'";
		throw_syntax_error($"unexpected {symbol_text}");
	};

	static throw_expected = function(_expected) {
		var initial_text = token.kind == GmlTokenKind.EOF
			? "reached end of file"
			: $"got '{token.text}'";
		throw_syntax_error(initial_text + $"expected {_expected}");
	};

	static process_token = function(_token) {};

	static document = function() {
		var _start = token;
		var statements = statement_list();
		if (!hit_eof) {
			throw_default_syntax_error();
		}
		return new GmlDocument(_start.start_index, accepted.end_index, statements);
	};

	static statement_list = function() {
		var statements = [];

		while (!hit_eof) {
			if (accept(GmlTokenKind.SEMI_COLON)) {
				continue;
			}
			var _statement = statement(false);
			if (!is_undefined(_statement)) {
				array_push(statements, _statement);
			} else {
				break;
			}
		}

		return statements;
	};

	static statement = function(_accept_semicolons = true) {
		var _matched_statement = undefined;
		var _statement_functions = [
			block,
			if_statement,
			function_declaration,
			do_statement,
			while_statement,
			with_statement,
			repeat_statement,
			for_statement,
			throw_statement,
			continue_statement,
			break_statement,
			exit_statement,
			return_statement,
			switch_statement,
			try_statement,
			delete_statement,
			assignment_or_expression_statement
		];

		for (var i = 0; i < array_length(_statement_functions); i++) {
			_matched_statement = _statement_functions[i]();
			if (!is_undefined(_matched_statement)) {
				break;
			}
		}

		if (!is_undefined(_matched_statement)) {
			if (_accept_semicolons) {
				while (!hit_eof) {
					if (!accept(GmlTokenKind.SEMI_COLON)) {
						break;
					}
				}
			}
			return _matched_statement;
		}

		return undefined;
	};

	static block = function() {
		var _start = token;
		if (!accept(GmlTokenKind.OPEN_BRACE)) {
			return undefined;
		}
		var _statements = statement_list();
		expect(GmlTokenKind.CLOSE_BRACE);
		return new GmlBlock(_start.start_index, accepted.end_index, _statements);
	};

	static function_declaration = function() {
		var _start = token;
		if (!accept(GmlTokenKind.FUNCTION)) {
			return undefined;
		}
		var _identifier = identifier();
		var _parameter_list = expect_defined(parameter_list());
		var _constructor_clause = undefined;

		if (accept(GmlTokenKind.COLON)) {
			expect(GmlTokenKind.IDENTIFIER);
			var _parent_name = new GmlIdentifier(
				accepted.start_index,
				accepted.end_index,
				accepted.text
			);
			var _parent_args = expect_defined(argument_list());
			expect(GmlTokenKind.CONSTRUCTOR);
			_constructor_clause = new GmlConstructorClause(
				_start.start_index,
				accepted.end_index,
				_parent_name,
				_parent_args
			);
		} else if (accept(GmlTokenKind.CONSTRUCTOR)) {
			_constructor_clause = new GmlConstructorClause(
				_start.start_index,
				accepted.end_index,
				undefined,
				undefined
			);
		}

		var _body = expect_defined(statement());

		return new GmlFunctionDeclaration(
			_start.start_index,
			accepted.end_index,
			_identifier,
			_parameter_list,
			_body,
			_constructor_clause
		);
	};

	static assignment_or_expression_statement = function() {
		var _start = token;
		if (
			accept(GmlTokenKind.VAR)
			|| accept(GmlTokenKind.STATIC)
			|| accept(GmlTokenKind.GLOBAL_VAR)
		) {
			var _modifier = accepted.text;
			while (accept(GmlTokenKind.VAR)) {
				continue;
			}
			var _first_declaration = expect_defined(variable_declaration());
			var _declarations = [_first_declaration];

			while (!hit_eof) {
				if (accept(GmlTokenKind.COMMA)) {
					var _declaration = expect_defined(variable_declaration());
					array_push(_declarations, _declaration);
				} else {
					break;
				}
			}
			return new GmlVariableDeclarationList(
				_start.start_index,
				accepted.end_index,
				_declarations,
				_modifier
			);
		} else {
			var _lhs = unary_expression();
			if (is_undefined(_lhs)) {
				return undefined;
			}

			// check for expression statement
			if (
				(
					is_instanceof(_lhs, GmlUnaryExpression)
						&& (_lhs.operator == "++" || _lhs.operator == "--")
				) || is_instanceof(_lhs, GmlCallExpression)
			) {
				return _lhs;
			}

			if (!accept_any(__assignment_operators)) {
				throw_default_syntax_error();
			}

			var _assignment_operator = accepted.text;
			var _rhs = expect_defined(expression());

			return new GmlAssignmentExpression(
				_start.start_index,
				accepted.end_index,
				_assignment_operator,
				_lhs,
				_rhs
			);
		}
	};

	static variable_declaration = function() {
		var _start = token;
		var _name = identifier();
		if (is_undefined(_name)) {
			return undefined;
		}
		var _expression;
		if (accept(GmlTokenKind.ASSIGN)) {
			_expression = expect_defined(expression());
		}

		return new GmlVariableDeclaration(
			_start.start_index,
			accepted.end_index,
			_name,
			_expression
		);
	};

	static if_statement = function() {
		var _start = token;
		if (!accept(GmlTokenKind.IF)) {
			return undefined;
		}

		var _condition = expect_defined(expression());
		accept(GmlTokenKind.THEN);
		var _statement = expect_defined(statement());

		var _alternate = undefined;
		if (accept(GmlTokenKind.ELSE)) {
			_alternate = expect_defined(statement());
		}

		return new GmlIfStatement(
			_start.start_index,
			accepted.end_index,
			_condition,
			_statement,
			_alternate
		);
	};

	static do_statement = function() {
		var _start = token;
		if (!accept(GmlTokenKind.DO)) {
			return undefined;
		}

		var _body = expect_defined(statement());
		expect(GmlTokenKind.UNTIL);
		var _test = expect_defined(expression());

		return new GmlDoStatement(_start.start_index, accepted.end_index, _body, _test);
	};

	static while_statement = function() {
		var _start = token;
		if (!accept(GmlTokenKind.WHILE)) {
			return undefined;
		}

		var _test = expect_defined(expression());
		var _body = expect_defined(statement());

		return new GmlWhileStatement(
			_start.start_index,
			accepted.end_index,
			_body,
			_test
		);
	};

	static with_statement = function() {
		var _start = token;
		if (!accept(GmlTokenKind.WITH)) {
			return undefined;
		}

		var _expression = expect_defined(expression());
		var _body = expect_defined(statement());

		return new GmlWithStatement(
			_start.start_index,
			accepted.end_index,
			_body,
			_expression
		);
	};

	static repeat_statement = function() {
		var _start = token;
		if (!accept(GmlTokenKind.REPEAT)) {
			return undefined;
		}

		var _expression = expect_defined(expression());
		var _body = expect_defined(statement());

		return new GmlRepeatStatement(
			_start.start_index,
			accepted.end_index,
			_body,
			_expression
		);
	};

	static for_statement = function() {
		var _start = token;
		if (!accept(GmlTokenKind.FOR)) {
			return undefined;
		}

		expect(GmlTokenKind.OPEN_PAREN);
		var _init = statement(false);
		expect(GmlTokenKind.SEMI_COLON);
		var _test = expression();
		expect(GmlTokenKind.SEMI_COLON);
		var _update = statement(false);
		expect(GmlTokenKind.CLOSE_PAREN);
		var _body = expect_defined(statement());

		return new GmlForStatement(
			_start.start_index,
			accepted.end_index,
			_init,
			_test,
			_update,
			_body
		);
	};

	static switch_statement = function() {
		var _start = token;
		if (!accept(GmlTokenKind.SWITCH)) {
			return undefined;
		}

		var _expression = expect_defined(expression());
		var _block_start = token;
		expect(GmlTokenKind.OPEN_BRACE);

		var _cases = [];
		while (!hit_eof) {
			var _case = switch_case();
			if (!is_undefined(_case)) {
				array_push(_cases, _case);
				continue;
			}

			// var _region_statement = region_statement();
			// if (!is_undefined(_region_statement)) {
			//    continue;
			// }

			break;
		}

		expect(GmlTokenKind.CLOSE_BRACE);

		return new GmlSwitchStatement(
			_start.start_index,
			accepted.end_index,
			_expression,
			_cases
		);
	};

	static switch_case = function() {
		if (accept(GmlTokenKind.CASE)) {
			var _start = accepted;
			var _test = expect_defined(expression());
			expect(GmlTokenKind.COLON);
			var _statements = statement_list();
			return new GmlSwitchCase(
				_start.start_index,
				accepted.end_index,
				_test,
				_statements
			);
		} else if (accept(GmlTokenKind.DEFAULT)) {
			var _start = accepted;
			expect(GmlTokenKind.COLON);
			var _statements = statement_list();
			return new GmlSwitchCase(
				_start.start_index,
				accepted.end_index,
				undefined,
				_statements
			);
		} else {
			return undefined;
		}
	};

	static try_statement = function() {
		var _start = token;
		if (!accept(GmlTokenKind.TRY)) {
			return undefined;
		}

		var _catch;
		var _finally;

		var _try_body = expect_defined(statement());

		if (accept(GmlTokenKind.CATCH)) {
			var _identifier;
			if (accept(GmlTokenKind.OPEN_PAREN)) {
				_identifier = expect_defined(identifier());
				expect(GmlTokenKind.CLOSE_PAREN);
			}
			var _body = expect_defined(statement());
			_catch = new GmlCatchClause(
				_start.start_index,
				accepted.end_index,
				_identifier,
				_body
			);
		}

		if (accept(GmlTokenKind.FINALLY)) {
			_finally = expect_defined(statement());
		}

		return new GmlTryStatement(
			_start.start_index,
			accepted.end_index,
			_try_body,
			_catch,
			_finally
		);
	};

	static continue_statement = function() {
		if (!accept(GmlTokenKind.CONTINUE)) {
			return undefined;
		}
		return new GmlContinueStatement(accepted.start_index, accepted.end_index);
	};

	static break_statement = function() {
		if (!accept(GmlTokenKind.BREAK)) {
			return undefined;
		}
		return new GmlBreakStatement(accepted.start_index, accepted.end_index);
	};

	static exit_statement = function() {
		if (!accept(GmlTokenKind.EXIT)) {
			return undefined;
		}
		return new GmlExitStatement(accepted.start_index, accepted.end_index);
	};

	static return_statement = function() {
		var _start = token;
		if (!accept(GmlTokenKind.RETURN)) {
			return undefined;
		}
		var _expression = expression();
		return new GmlReturnStatement(
			_start.start_index,
			accepted.end_index,
			_expression
		);
	};

	static throw_statement = function() {
		var _start = token;
		if (!accept(GmlTokenKind.THROW)) {
			return undefined;
		}
		var _expression = expression();
		return new GmlThrowStatement(_start.start_index, accepted.end_index, _expression);
	};

	static delete_statement = function() {
		var _start = token;
		if (!accept(GmlTokenKind.DELETE)) {
			return undefined;
		}
		var _expression = expression();
		return new GmlDeleteStatement(
			_start.start_index,
			accepted.end_index,
			_expression
		);
	};

	// static region_statement = function() {
	//    var _start = token;
	//    if (!(accept(GmlTokenKind.REGION) || accept(GmlTokenKind.END_REGION))) {
	//        return undefined;
	//    }

	//    var _is_end_region = accepted.kind == "endregion";

	//    var _name = "";
	//    if (accept(GmlTokenKind.REGION_NAME)) {
	//        _name = accepted.text;
	//    }

	//    return new RegionStatement(_start.start_index, accepted.end_index, _name, _is_end_region);
	// }

	static expression = function() {
		var _func = function_declaration();
		if (!is_undefined(_func)) {
			return _func;
		}
		return conditional_expression();
	};

	static conditional_expression = function() {
		var _start = token;
		var _bit_xor = bit_xor_expression();
		if (is_undefined(_bit_xor)) {
			return undefined;
		}

		if (accept(GmlTokenKind.QUESTION_MARK)) {
			var _when_true = expect_defined(expression());
			expect(GmlTokenKind.COLON);
			var _when_false = expect_defined(expression());
			return new GmlConditionalExpression(
				_start.start_index,
				accepted.end_index,
				_when_true,
				_when_false
			);
		}

		return _bit_xor;
	};

	static __handle_binary_expression = function(_token_kind_array, _next_func) {
		var _start = token;
		var _result = _next_func();
		if (is_undefined(_result)) {
			return undefined;
		}

		while (accept_any(_token_kind_array)) {
			var _operator = accepted.text;
			var _right_expr = expect_defined(_next_func());
			_result = new GmlBinaryExpression(
				_start.start_index,
				accepted.end_index,
				_operator,
				_result,
				_right_expr
			);
		}

		return _result;
	};

	static bit_xor_expression = function() {
		return __handle_binary_expression([GmlTokenKind.BIT_XOR], bit_or_expression);
	};

	static bit_or_expression = function() {
		return __handle_binary_expression([GmlTokenKind.BIT_OR], bit_and_expression);
	};

	static bit_and_expression = function() {
		return __handle_binary_expression(
			[GmlTokenKind.BIT_AND],
			null_coalescing_expression
		);
	};

	static null_coalescing_expression = function() {
		return __handle_binary_expression([GmlTokenKind.NULL_COALESCE], xor_expression);
	};

	static xor_expression = function() {
		return __handle_binary_expression([GmlTokenKind.XOR], and_expression);
	};

	static and_expression = function() {
		return __handle_binary_expression([GmlTokenKind.AND], or_expression);
	};

	static or_expression = function() {
		return __handle_binary_expression([GmlTokenKind.OR], equality_expression);
	};

	static equality_expression = function() {
		return __handle_binary_expression(__equality_operators, relational_expression);
	};

	static relational_expression = function() {
		return __handle_binary_expression(__relational_operators, shift_expression);
	};

	static shift_expression = function() {
		return __handle_binary_expression(__shift_operators, additive_expression);
	};

	static additive_expression = function() {
		return __handle_binary_expression(
			__additive_operators,
			multiplicative_expression
		);
	};

	static multiplicative_expression = function() {
		return __handle_binary_expression(__multiplicative_operators, unary_expression);
	};

	static unary_expression = function() {
		var _start = token;
		if (accept_any(__prefix_operators)) {
			var _operator = accepted.text;
			var _primary_expression = expect_defined(primary_expression());
			return new GmlUnaryExpression(
				_start.start_index,
				accepted.end_index,
				_operator,
				_primary_expression,
				true
			);
		}
		return primary_expression();
	};

	static primary_expression = function(_accept_unary_operators = true) {
		var _start = token;
		var _start_expression = primary_expression_start();
		if (is_undefined(_start_expression)) {
			return undefined;
		}

		var _object = _start_expression;

		while (!hit_eof) {
			if (
				token.kind == GmlTokenKind.WHITESPACE
				|| token.kind == GmlTokenKind.SINGLE_LINE_COMMENT
				|| token.kind == GmlTokenKind.MULTI_LINE_COMMENT
			) {
				next_token();
			}

			if (
				_accept_unary_operators
				&& (
					accept(GmlTokenKind.PLUS_PLUS, false)
						|| accept(GmlTokenKind.MINUS_MINUS, false)
				)
			) {
				var _operator = accepted.text;
				_object = new GmlUnaryExpression(
					_start.start_index,
					accepted.end_index,
					_operator,
					_object,
					false
				);
				break;
			} else if (accept_any(__accessors)) {
				var _accessor = accepted.text;
				var _first_expression = expect_defined(expression());
				var _properties = [_first_expression];

				while (!hit_eof) {
					if (accept(GmlTokenKind.COMMA)) {
						var _expression = expect_defined(expression());
						array_push(_properties, _expression);
					} else if (accept(GmlTokenKind.CLOSE_BRACKET)) {
						break;
					} else {
						throw_default_syntax_error();
					}
				}

				_object = new MemberIndexExpression(
					_start.start_index,
					accepted.end_index,
					_object,
					_properties,
					_accessor
				);
			} else if (accept(GmlTokenKind.DOT)) {
				var _identifier = expect_defined(identifier());
				return new GmlMemberDotExpression(
					_start.start_index,
					accepted.end_index,
					_object,
					_identifier
				);
			} else {
				var _arguments = argument_list();
				if (!is_undefined(_arguments)) {
					_object = new GmlCallExpression(
						_start.start_index,
						accepted.end_index,
						_object,
						_arguments
					);
				} else {
					break;
				}
			}
		}

		return _object;
	};

	static primary_expression_start = function() {
		var _start = token;

		var _literal = literal();
		if (!is_undefined(_literal)) {
			return _literal;
		}

		var _identifier = identifier();
		if (!is_undefined(_identifier)) {
			return _identifier;
		}

		if (accept(GmlTokenKind.NEW)) {
			var _newable_expression = expect_defined(primary_expression(false));
			return new GmlNewExpression(
				_start.start_index,
				accepted.end_index,
				_newable_expression
			);
		}

		if (accept(GmlTokenKind.OPEN_PAREN)) {
			var _expression = expect_defined(expression());
			expect(GmlTokenKind.CLOSE_PAREN);
			// return new ParenthesizedExpression(_start.start_index, accepted.end_index, _expression);
			_expression.start_index = _start.start_index;
			_expression.end_index = accepted.end_index;
			return _expression;
		}

		return undefined;
	};

	static argument_list = function() {
		var _start = token;
		if (!accept(GmlTokenKind.OPEN_PAREN)) {
			return undefined;
		}

		if (accept(GmlTokenKind.CLOSE_PAREN)) {
			return [];
		}

		var _arguments = [];
		var _previous_child_was_punctuator = true;
		var _ended_on_closing_delimiter = false;

		while (!hit_eof) {
			var _expression = expression();
			if (!is_undefined(_expression)) {
				if (!_previous_child_was_punctuator) {
					throw_expected(",");
					return undefined;
				}
				_previous_child_was_punctuator = false;
				array_push(_arguments, _expression);
			}

			if (accept(GmlTokenKind.COMMA)) {
				if (_previous_child_was_punctuator) {
					array_push(
						_arguments,
						new UndefinedLiteral(_start.start_index, accepted.end_index)
					);
				}
				_previous_child_was_punctuator = true;
			} else if (accept(GmlTokenKind.CLOSE_PAREN)) {
				if (_previous_child_was_punctuator && array_length(_arguments) > 0) {
					array_push(
						_arguments,
						new GmlUndefinedLiteral(_start.start_index, accepted.end_index)
					);
				}
				_ended_on_closing_delimiter = true;
				break;
			} else {
				throw_default_syntax_error();
				return undefined;
			}
		}

		if (!_ended_on_closing_delimiter) {
			throw_expected(")");
		}

		return _arguments;
	};

	static literal = function() {
		var _start = token;

		if (accept(GmlTokenKind.UNDEFINED)) {
			return new GmlUndefinedLiteral(_start.start_index, accepted.end_index);
		} else if (accept(GmlTokenKind.INTEGER_LITERAL)) {
			return new GmlIntegerLiteral(
				_start.start_index,
				accepted.end_index,
				real(accepted.text)
			);
		} else if (accept(GmlTokenKind.DECIMAL_LITERAL)) {
			return new GmlDecimalLiteral(
				_start.start_index,
				accepted.end_index,
				real(accepted.text)
			);
		} else if (accept(GmlTokenKind.STRING_LITERAL)) {
			return new GmlStringLiteral(
				_start.start_index,
				accepted.end_index,
				accepted.text
			);
		} else if (accept(GmlTokenKind.VERBATIM_STRING_LITERAL)) {
			return new GmlGmlVerbatimStringLiteral(
				_start.start_index,
				accepted.end_index,
				accepted.text
			);
		} else if (accept(GmlTokenKind.SIMPLE_TEMPLATE_STRING)) {
			var _text = string_copy(
				accepted.text,
				_start.start_index + 1,
				string_length(accepted.text) - 1
			);
			var _string_literal = new StringLiteral(
				_start.start_index + 2,
				accepted.end_index - 1,
				_text
			);
			return GmlTemplateStringLiteral(_start.start_index, accepted.end_index, []);
		} else if (
			accept(GmlTokenKind.HEX_INTEGER_LITERAL)
			|| accept(GmlTokenKind.BINARY_LITERAL)
		) {
			return new GmlBinaryLiteral(
				_start.start_index,
				accepted.end_index,
				real(accepted.text)
			);
		} else if (accept(GmlTokenKind.BOOLEAN_LITERAL)) {
			return new GmlBooleanLiteral(
				_start.start_index,
				accepted.end_index,
				bool(accepted.text)
			);
		} else if (accept(GmlTokenKind.NOONE)) {
			return new GmlNoOneLiteral(_start.start_index, accepted.end_index);
		}

		var _array = array_literal();
		if (!is_undefined(_array)) {
			return _array;
		}

		var _struct = struct_literal();
		if (!is_undefined(_struct)) {
			return _struct;
		}

		var _template_str = template_string_literal();
		if (!is_undefined(_template_str)) {
			return _template_str;
		}

		return undefined;
	};

	static array_literal = function() {
		var _start = token;
		if (!accept(GmlTokenKind.OPEN_BRACKET)) {
			return undefined;
		}

		if (accept(GmlTokenKind.CLOSE_BRACKET)) {
			return new GmlArrayLiteral(_start.start_index, accepted.end_index, []);
		}

		var _elements = [];
		var _expect_delimiter = true;
		var _ended_on_closing_delimiter = false;

		while (!hit_eof) {
			if (_expect_delimiter) {
				expect(GmlTokenKind.COMMA);
			} else {
				var _expression = expect_defined(expression());
				array_push(_elements, _expression);
			}
			_expect_delimiter = !_expect_delimiter;

			if (accept(GmlTokenKind.CLOSE_BRACKET)) {
				_ended_on_closing_delimiter = true;
				break;
			}
		}

		if (!_ended_on_closing_delimiter) {
			throw_expected("]");
		}

		return new GmlArrayLiteral(_start.start_index, accepted.end_index, _elements);
	};

	static struct_literal = function() {
		var _start = token;
		if (!accept(GmlTokenKind.OPEN_BRACE)) {
			return undefined;
		}

		if (accept(GmlTokenKind.CLOSE_BRACE)) {
			return new GmlStructLiteral(_start.start_index, accepted.end_index, []);
		}

		var _properties = [];
		var _expect_delimiter = true;
		var _ended_on_closing_delimiter = false;

		while (!hit_eof) {
			if (_expect_delimiter) {
				expect(GmlTokenKind.COMMA);
			} else {
				var _expression = expect_defined(property_assignment());
				array_push(_properties, _expression);
			}
			_expect_delimiter = !_expect_delimiter;

			if (accept(GmlTokenKind.CLOSE_BRACE)) {
				_ended_on_closing_delimiter = true;
				break;
			}
		}

		if (!_ended_on_closing_delimiter) {
			throw_expected("}");
		}

		return new GmlStructLiteral(_start.start_index, accepted.end_index, _properties);
	};

	static property_assignment = function() {
		var _start = token;
		var _name;
		var _initializer;

		if (
			accept(GmlTokenKind.IDENTIFIER)
			|| accept(GmlTokenKind.CONSTRUCTOR)
			|| accept(GmlTokenKind.NOONE)
		) {
			_name = new GmlIdentifier(
				_start.start_index,
				accepted.end_index,
				accepted.text
			);
		} else if (accept(GmlTokenKind.STRING_LITERAL)) {
			_name = new GmlStringLiteral(
				_start.start_index,
				accepted.end_index,
				accepted.text
			);
		} else {
			return undefined;
		}

		if (accept(GmlTokenKind.COLON)) {
			_initializer = expect_defined(expression());
		}

		return new StructProperty(
			_start.start_index,
			accepted.end_index,
			_name,
			_initializer
		);
	};

	static template_string_literal = function() {
		// TODO: do later lmao
		return undefined;
	};

	static identifier = function() {
		if (accept(GmlTokenKind.IDENTIFIER) || accept(GmlTokenKind.CONSTRUCTOR)) {
			return new GmlIdentifier(
				accepted.start_index,
				accepted.end_index,
				accepted.text
			);
		}
		return undefined;
	};
}
