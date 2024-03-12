var code = buffer_read(buffer_load("test.txt"), buffer_text);

var parser = new GmlParser(code);

var ast = parser.get_ast();

show_debug_message(ast);
clipboard_set_text(ast);