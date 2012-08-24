GPerlTokenInfo decl_tokens[] = {
	{Return, "Return", "return"},
	{Add, "Add", "+"},
	{Sub, "Sub", "-"},
	{Mul, "Mul", "*"},
	{Div, "Div", "/"},
	{Greater, "Greater", ">"},
	{Less, "Less", "<"},
	{AddEqual, "AddEqual", "+="},
	{SubEqual, "SubEqual", "-="},
	{MulEqual, "MulEqual", "*="},
	{DivEqual, "DivEqual", "/="},
	{StringAdd, "StringAdd", ".="},
	{GreaterEqual, "GreaterEqual", ">="},
	{LessEqual, "LessEqual", "<="},
	{EqualEqual, "EqualEqual", "=="},
	{NotEqual, "NotEqual", "!="},
	{Inc, "Inc", "++"},
	{Dec, "Dec", "--"},
	{LeftShift, "LeftShift", "<<"},
	{RightShift, "RightShift", ">>"},
	{VarDecl, "VarDecl", "my"},
	{FunctionDecl, "FunctionDecl", "sub"},
	{Assign, "Assign", "="},
	{Is, "Is", ""},
	{IsNot, "IsNot", "!"},
	{BuiltinFunc, "BuiltinFunc", "print"},
	{BuiltinFunc, "BuiltinFunc", "push"},
	{BuiltinFunc, "BuiltinFunc", "ref"},
	{BuiltinFunc, "BuiltinFunc", "undef"},
	{IfStmt, "IfStmt", "if"},
	{ElseStmt, "ElseStmt", "else"},
	{ElsifStmt, "ElsifStmt", "elsif"},
	{UnlessStmt, "UnlessStmt", "unless"},
	{Comma, "Comma", ","},
	{SemiColon, "SemiColon", ";"},
	{LeftParenthesis, "LeftParenthesis", "("},
	{RightParenthesis, "RightParenthesis", ")"},
	{LeftBrace, "LeftBrace", "{"},
	{RightBrace, "RightBrace", "}"},
	{LeftBracket, "LeftBracket", "["},
	{RightBracket, "RightBracket", "]"},
	{ArrayDereference, "ArrayDereference", "@{"},
	{Shift, "Shift", "shift"},
	{CallDecl, "CallDecl", "&"},
	{WhileStmt, "WhileStmt", "while"},
	{ForStmt, "ForStmt", "for"},
	{ForeachStmt, "ForeachStmt", "foreach"},
	{ArgumentArray, "ArgumentArray", "@_"},
	{SpecificValue, "SpecificValue", "$_"},
	{ProgramArgument, "ProgramArgument", "@ARGV"},
	{FieldDecl, "FieldDecl", ""},
	{TypeRef, "TypeRef", ""},
	{LabelRef, "LabelRef", ""},
	{LocalVarDecl, "LocalVarDecl", ""},
	{GlobalVarDecl, "GlobalVarDecl", ""},
	{MultiLocalVarDecl, "MultiLocalVarDecl", ""},
	{MultiGlobalVarDecl, "MultiGlobalVarDecl", ""},
	{Var, "Var", ""},
	{ArrayVar, "ArrayVar", ""},
	{Int, "Int", ""},
	{Double, "Double", ""},
	{String, "String", ""},
	{Object, "Object", ""},
	{Array, "Array", ""},
	{Operator, "Operator", ""},
	{LocalVar, "LocalVar", ""},
	{LocalArrayVar, "LocalArrayVar", ""},
	{GlobalVar, "GlobalVar", ""},
	{GlobalArrayVar, "GlobalArrayVar", ""},
	{ArrayRef, "ArrayRef", ""},
	{ArrayAt, "ArrayAt", ""},
	{Function, "Function", ""},
	{Call, "Call", ""},
	{Argument, "Argument", ""},
	{List, "List", ""},
	{Default, "Default", "undef"},
	{Undefined, "Undefined", ""},
};

