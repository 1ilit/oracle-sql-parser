start
    = create_table_stmt

create_table_stmt
    = _ "create"i _ "table"i _ name:identifier_name _ "(" _ x:column_definition xs:(_ "," _ column_definition)* _ ")" _ ";" 
    { return { op: "create", object: "table", columns: [x, ...(xs.map(col => col[3]))] }; }

column_definition
    = _ name:identifier_name _ type:data_type { return { name, type }; }

data_type
    = oracle_built_in_data_type
//    / ansi_supported_data_type
//    / user_defined_type
//    / oracle_supplied_type

oracle_built_in_data_type
    = character_data_type
//    / number_data_type
//    / long_and_raw_data_type
//    / datetime_data_type
//    / large_object_data_type
//    / rowid_data_type

character_data_type 
    = character_data_type_with_semantics
    / character_data_type_without_semantics

character_data_type_with_semantics
    = type:character_data_type_type_with_semantics _ "(" _ size:character_data_type_size_with_semantics _ ")" { return { type, size }; }

character_data_type_size_with_semantics
    = size:integer _ "byte"i { return { size, character_semantics: "byte" } }
    / size:integer _ "char"i { return { size, character_semantics: "char" } }

character_data_type_type_with_semantics
    = "char"i { return "char"; }
    / "varchar2"i { return "varchar2"; }

character_data_type_without_semantics
    = type:character_data_type_type_without_semantics _ "(" _ size:character_data_type_size_without_semantics _ ")" { return { type, size }; }

character_data_type_size_without_semantics
    = size:integer { return { size, character_semantics: null } }

character_data_type_type_without_semantics
    = "nchar"i { return "nchar"; }
    / "nvarchar2"i { return "nvarchar2"; }

integer
    = digits: [0-9]+ { return digits.join("");}

identifier_name
    = chars:[a-zA-Z]+ { return chars.join(""); }

_ 
    = [ \t\n\r]*
