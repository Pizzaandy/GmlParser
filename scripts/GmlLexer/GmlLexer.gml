function GmlLexer(_source_text, _tab_width = 4) constructor {
	enum GmlLexerMode {
		DEFAULT,
		REGION_NAME,
		TEMPLATE_STRING,
	}

	source_text = _source_text;
	tab_width = _tab_width;

	index = 0;
	start_index = 0;
	line_number = 0;
	column_number = 0;
	character = -1;
	current_token = "";

	source_length = string_length(source_text);
	hit_eof = false;
	mode = GmlLexerMode.DEFAULT;

	static whitespaces = ["\u000B", "\u000C", "\u0020", "\u00A0", "\t"];

	static next_token = function() {
		start_index = index;
		advance();

		if (mode == GmlLexerMode.REGION_NAME) {
			while (peek() != "\r" && peek() != "\n" && !hit_eof) {
				advance();
			}
			mode = GmlLexerMode.DEFAULT;
			return token(GmlTokenKind.REGION_NAME);
		} else if (mode == GmlLexerMode.TEMPLATE_STRING) {
			if (character == "\"") {
				return token(GmlTokenKind.TEMPLATE_END);
			}
			if (character == "{") {
				return token(GmlTokenKind.TEMPLATE_MIDDLE);
			}

			while (is_template_string_character(peek()) && !hit_eof) {
				advance();
			}

			if (match("{")) {
				return token(GmlTokenKind.TEMPLATE_MIDDLE);
			}
			if (match("\"")) {
				return token(GmlTokenKind.TEMPLATE_END);
			}

			return unexpected_token();
		}

		switch (character) {
			case -1:
				return token(GmlTokenKind.EOF);
			case "\u000B":
			case "\u000C":
			case "\u0020":
			case "\u00A0":
			case "\t":
				while (true) {
					if (array_contains(whitespaces, peek())) {
						advance();
					} else {
						break;
					}
				}
				return token(GmlTokenKind.WHITESPACE);
			case "\n":
				return token(GmlTokenKind.LINE_BREAK);
			case "\r":
				if (match("\n")) {
					return token(GmlTokenKind.LINE_BREAK);
				}
				break;
			case "/":
				if (match("/")) {
					while (peek() != "\r" && peek() != "\n" && !hit_eof) {
						advance();
					}
					return token(GmlTokenKind.SINGLE_LINE_COMMENT);
				}
				if (match("*")) {
					while (true) {
						while (peek() != "*" && !hit_eof) {
							advance();
						}

						if (!match("*")) {
							return unexpected_token();
						}

						if (match("/")) {
							return token(GmlTokenKind.MULTI_LINE_COMMENT);
						}
					}
				}
				if (match("=")) {
					return token(GmlTokenKind.DIVIDE_ASSIGN);
				}
				return token(GmlTokenKind.DIVIDE);
			case "(":
				return token(GmlTokenKind.OPEN_PAREN);
			case ")":
				return token(GmlTokenKind.CLOSE_PAREN);
			case "{":
				return token(GmlTokenKind.OPEN_BRACE);
			case "}":
				return token(GmlTokenKind.CLOSE_BRACE);
			case ";":
				return token(GmlTokenKind.SEMI_COLON);
			case ",":
				return token(GmlTokenKind.COMMA);
			case ".":
				if (is_digit(peek())) {
					while (is_digit(peek()) && !hit_eof) {
						advance();
					}
					return token(GmlTokenKind.DECIMAL_LITERAL);
				}
				return token(GmlTokenKind.DOT);
			case "\\":
				return token(GmlTokenKind.BACKSLASH);
			case "=":
				if (match("=")) {
					return token(GmlTokenKind.EQUALS);
				}
				return token(GmlTokenKind.ASSIGN);
			case ":":
				if (match("=")) {
					return token(GmlTokenKind.ASSIGN);
				}
				return token(GmlTokenKind.COLON);
			case "+":
				if (match("+")) {
					return token(GmlTokenKind.PLUS_PLUS);
				}
				if (match("=")) {
					return token(GmlTokenKind.PLUS_ASSIGN);
				}
				return token(GmlTokenKind.PLUS);
			case "-":
				if (match("-")) {
					return token(GmlTokenKind.MINUS_MINUS);
				}
				if (match("=")) {
					return token(GmlTokenKind.MINUS_ASSIGN);
				}
				return token(GmlTokenKind.MINUS);
			case "*":
				if (match("=")) {
					return token(GmlTokenKind.MULTIPLY_ASSIGN);
				}
				if (match("*")) {
					return token(GmlTokenKind.POWER);
				}
				return token(GmlTokenKind.MULTIPLY);
			case "%":
				if (match("=")) {
					return token(GmlTokenKind.MODULUS_ASSIGN);
				}
				return token(GmlTokenKind.MODULO);
			case "~":
				return token(GmlTokenKind.BIT_NOT);
			case "?":
				if (match("?")) {
					if (match("=")) {
						return token(GmlTokenKind.NULL_COALESCING_ASSIGN);
					}
					return token(GmlTokenKind.NULL_COALESCE);
				}
				return token(GmlTokenKind.QUESTION_MARK);
			case "!":
				if (match("=")) {
					return token(GmlTokenKind.NOT_EQUALS);
				}
				return token(GmlTokenKind.NOT);
			case "[":
				if (match("|")) {
					return token(GmlTokenKind.LIST_ACCESSOR);
				} else if (match("?")) {
					return token(GmlTokenKind.MAP_ACCESSOR);
				} else if (match("#")) {
					return token(GmlTokenKind.GRID_ACCESSOR);
				} else if (match("@")) {
					return token(GmlTokenKind.ARRAY_ACCESSOR);
				} else if (match("$")) {
					return token(GmlTokenKind.STRUCT_ACCESSOR);
				}
				return token(GmlTokenKind.OPEN_BRACKET);
			case "]":
				return token(GmlTokenKind.CLOSE_BRACKET);
			case "<":
				if (match("<")) {
					if (match("=")) {
						return token(GmlTokenKind.LEFT_SHIFT_ARITHMETIC_ASSIGN);
					}
					return token(GmlTokenKind.LEFT_SHIFT_ARITHMETIC);
				}
				if (match(">")) {
					return token(GmlTokenKind.NOT_EQUALS);
				}
				if (match("=")) {
					return token(GmlTokenKind.LESS_THAN_EQUALS);
				}
				return token(GmlTokenKind.LESS_THAN);
			case ">":
				if (match(">")) {
					if (match("=")) {
						return token(GmlTokenKind.RIGHT_SHIFT_ARITHMETIC_ASSIGN);
					}
					return token(GmlTokenKind.RIGHT_SHIFT_ARITHMETIC);
				}
				if (match("=")) {
					return token(GmlTokenKind.GREATER_THAN_EQUALS);
				}
				return token(GmlTokenKind.GREATER_THAN);
			case "|":
				if (match("|")) {
					return token(GmlTokenKind.OR);
				}
				if (match("=")) {
					return token(GmlTokenKind.BIT_OR_ASSIGN);
				}
				return token(GmlTokenKind.BIT_OR);
			case "&":
				if (match("&")) {
					return token(GmlTokenKind.AND);
				}
				if (match("=")) {
					return token(GmlTokenKind.BIT_AND_ASSIGN);
				}
				return token(GmlTokenKind.BIT_AND);
			case "^":
				if (match("^")) {
					return token(GmlTokenKind.XOR);
				}
				if (match("=")) {
					return token(GmlTokenKind.BIT_XOR_ASSIGN);
				}
				return token(GmlTokenKind.BIT_XOR);
			case "#":
				while (is_alpha(peek()) || is_hex_digit(peek())) {
					advance();
				}
				var kind = get_directive_or_hex_literal_kind(current_token);
				if (
					array_contains(
						[
							GmlTokenKind.DEFINE,
							GmlTokenKind.REGION,
							GmlTokenKind.END_REGION
						],
						kind
					)
					&& peek() != "\r"
					&& peek() != "\n"
				) {
					mode = GmlLexerMode.REGION_NAME;
				}

				return token(kind);
			case "@":
				if (peek() != "\"" && peek() != "'") {
					return unexpected_token();
				}

				var quote = peek();
				advance();

				while (!hit_eof) {
					if (peek() == quote) {
						if (peek(2) == quote) {
							advance();
						} else {
							break;
						}
					}
					advance();
				}

				if (match(quote)) {
					return token(GmlTokenKind.VERBATIM_STRING_LITERAL);
				}

				return unexpected_token("Unterminated string literal");
			case "$":
				if (match("\"")) {
					while (is_template_string_character(peek()) && !hit_eof) {
						advance();
					}
					if (match("{")) {
						return token(GmlTokenKind.TEMPLATE_START);
					}
					if (match("\"")) {
						return token(GmlTokenKind.SIMPLE_TEMPLATE_STRING);
					}

					return unexpected_token();
				} else if (is_hex_digit(peek())) {
					advance();
					while (is_hex_digit(peek())) {
						advance();
					}
					return token(GmlTokenKind.HEX_INTEGER_LITERAL);
				}

				return unexpected_token();
			case "\"":
				match_string_characters();
				if (!match("\"")) {
					return unexpected_token("Unterminated string literal");
				}
				return token(GmlTokenKind.STRING_LITERAL);
			default:
				if (is_digit(character)) {
					if (character == "0" && peek(1) == "b" && is_binary_digit(peek(2))) {
						advance();
						while (peek() == "0" || peek() == "1" || peek() == "_") {
							advance();
						}
						return token(GmlTokenKind.BINARY_LITERAL);
					}

					if (character == "0" && peek(1) == "x" && is_hex_digit(peek(2))) {
						advance();
						while (is_hex_digit(peek())) {
							advance();
						}
						return token(GmlTokenKind.HEX_INTEGER_LITERAL);
					}

					while (is_digit(peek()) || peek() == "_") {
						advance();
					}

					if (peek() == ".") {
						advance();
						while (is_digit(peek()) && !hit_eof) {
							advance();
						}
						return token(GmlTokenKind.DECIMAL_LITERAL);
					} else {
						return token(GmlTokenKind.INTEGER_LITERAL);
					}
				}
				if (is_alpha(character)) {
					while (is_alpha(peek()) || is_digit(peek())) {
						advance();
					}
					return token(get_keyword_or_identifier_kind(current_token));
				}
				break;
		}

		return unexpected_token();
	};

	static match_string_characters = function() {
		while (!hit_eof) {
			if (peek() == "\\") {
				advance();
				advance();
				continue;
			}

			if (peek() == "\"") {
				break;
			}

			advance();
		}
	};

	static get_keyword_or_identifier_kind = function(_token) {
		switch (_token) {
			case "and":
				return GmlTokenKind.AND;
			case "or":
				return GmlTokenKind.OR;
			case "xor":
				return GmlTokenKind.XOR;
			case "not":
				return GmlTokenKind.NOT;
			case "mod":
				return GmlTokenKind.MODULO;
			case "div":
				return GmlTokenKind.INTEGER_DIVIDE;
			case "begin":
				return GmlTokenKind.OPEN_BRACE;
			case "end":
				return GmlTokenKind.CLOSE_BRACE;
			case "true":
			case "false":
				return GmlTokenKind.BOOLEAN_LITERAL;
			case "break":
				return GmlTokenKind.BREAK;
			case "exit":
				return GmlTokenKind.EXIT;
			case "do":
				return GmlTokenKind.DO;
			case "until":
				return GmlTokenKind.UNTIL;
			case "case":
				return GmlTokenKind.CASE;
			case "else":
				return GmlTokenKind.ELSE;
			case "new":
				return GmlTokenKind.NEW;
			case "var":
				return GmlTokenKind.VAR;
			case "globalvar":
				return GmlTokenKind.GLOBAL_VAR;
			case "try":
				return GmlTokenKind.TRY;
			case "catch":
				return GmlTokenKind.CATCH;
			case "finally":
				return GmlTokenKind.FINALLY;
			case "return":
				return GmlTokenKind.RETURN;
			case "continue":
				return GmlTokenKind.CONTINUE;
			case "for":
				return GmlTokenKind.FOR;
			case "switch":
				return GmlTokenKind.SWITCH;
			case "while":
				return GmlTokenKind.WHILE;
			case "repeat":
				return GmlTokenKind.REPEAT;
			case "function":
				return GmlTokenKind.FUNCTION;
			case "with":
				return GmlTokenKind.WITH;
			case "default":
				return GmlTokenKind.DEFAULT;
			case "if":
				return GmlTokenKind.IF;
			case "then":
				return GmlTokenKind.THEN;
			case "throw":
				return GmlTokenKind.THROW;
			case "delete":
				return GmlTokenKind.DELETE;
			case "enum":
				return GmlTokenKind.ENUM;
			case "constructor":
				return GmlTokenKind.CONSTRUCTOR;
			case "static":
				return GmlTokenKind.STATIC;
			case "undefined":
				return GmlTokenKind.UNDEFINED;
			case "noone":
				return GmlTokenKind.NOONE;
			default:
				return GmlTokenKind.IDENTIFIER;
		}
	};

	static get_directive_or_hex_literal_kind = function(_token) {
		switch (_token) {
			case "#macro":
				return GmlTokenKind.MACRO;
			case "#region":
				return GmlTokenKind.REGION;
			case "#endregion":
				return GmlTokenKind.END_REGION;
			case "#define":
				return GmlTokenKind.DEFINE;
		}

		for (var i = 1; i < string_length(current_token); i++) {
			var _char = string_char_at(current_token, i + 1);
			if (!is_hex_digit(_char)) {
				return GmlTokenKind.UNEXPECTED;
			}
		}

		return GmlTokenKind.HEX_INTEGER_LITERAL;
	};

	static advance = function() {
		if (index >= self.source_length) {
			hit_eof = true;
			character = -1;
			return;
		}

		character = get_char_zero_indexed(index);
		index++;
		current_token += character;

		switch (character) {
			case "\n":
				line_number += 1;
				column_number = 0;
				break;
			case "\t":
				column_number += tab_width;
				break;
			default:
				column_number += 1;
				break;
		}
	};

	static peek = function(_amount = 1) {
		var target_index = index + _amount - 1;
		if (target_index >= source_length) {
			return -1;
		}
		return get_char_zero_indexed(target_index);
	};

	static match = function(expected) {
		if (peek() == expected) {
			advance();
			return true;
		} else {
			return false;
		}
	};

	static token = function(_token_kind) {
		var token = new GmlToken(
			current_token,
			_token_kind,
			line_number,
			column_number,
			start_index,
			index
		);

		current_token = "";

		return token;
	};

	static get_char_zero_indexed = function(_index) {
		return string_char_at(source_text, _index + 1);
	};

	static unexpected_token = function(_error_message) {
		return token(GmlTokenKind.UNEXPECTED);
	};

	static is_digit = function(_char) {
		static zero = ord("0");
		static nine = ord("9");
		var c = ord(_char);
		return c >= zero && c <= nine;
	};

	static is_alpha = function(_char) {
		static capital_a = ord("A");
		static capital_z = ord("Z");
		static lower_a = ord("a");
		static lower_z = ord("z");
		var c = ord(_char);
		return (c >= capital_a && c <= capital_z)
			|| (c >= lower_a && c <= lower_z)
			|| _char == "_";
	};

	static is_hex_digit = function(_char) {
		static capital_a = ord("A");
		static capital_f = ord("F");
		static lower_a = ord("a");
		static lower_f = ord("f");
		var c = ord(_char);
		return is_digit(_char)
			|| (c >= capital_a && c <= capital_f)
			|| (c >= lower_a && c <= lower_f)
			|| _char == "_";
	};

	static is_binary_digit = function(_char) {
		return _char == "0" || _char == "1";
	};

	static is_template_string_character = function(_c) {
		return _c != "\"" && _c != "{" && _c != "\r" && _c != "\n";
	};
}
