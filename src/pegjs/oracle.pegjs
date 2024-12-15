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
    / number_data_type
    / long_and_raw_data_type
    / datetime_data_type
    / large_object_data_type
    / rowid_data_type

// CHARACTER DATATYPE
character_data_type
    = character_data_type_with_size
    / character_data_type_with_size_and_semantics

character_data_type_with_size
    = type:character_data_type_name _ 
      size:("(" _ size:integer _ ")" { return size; })?
      {
        return { type, size };
      }

character_data_type_with_size_and_semantics
    = type:character_data_type_name_with_semantics _ 
      size_and_semantics:character_data_type_size_and_semantics? 
      { 
        return { 
            type, 
            size: size_and_semantics?.size || null, 
            semantics: size_and_semantics?.semantics || null 
        }; 
      }

character_data_type_size_and_semantics
    = "(" _ size:integer _ semantics:("byte"i / "char"i)? _ ")" 
    { return { size, semantics: semantics }; }

character_data_type_name
    = "nchar"i { return "nchar"; }
    / "nvarchar2"i { return "nvarchar2"; }

character_data_type_name_with_semantics
    = "char"i { return "char"; }
    / "varchar2"i { return "varchar2"; }

// NUMBER DATA TYPE
number_data_type
    = "binary_float"i { return { type: "binary_float" }; }
    / "binary_double"i { return { type: "binary_double" }; }
    / "float"i _ precision:("(" _ p:integer _ ")" { return p })? {
            return { type: "float", precision }; 
        }
    / "number"i _ precision:("(" _ p:integer _ s:(","_ s:integer { return s })? _")" { return { p, s } })? {
            return { type: "number", precision: precision?.p, scale: precision?.s  }; 
        }

long_and_raw_data_type
    = "long raw"i { return { type: "long raw" }; }
    / "long"i { return { type: "long" }; }
    / "raw"i _ "(" _ size:integer _ ")" { return { type: "raw", size }; }

large_object_data_type
    = type:("blob"i / "clob"i / "nclob"i / "bfile"i) { return { type }; }

rowid_data_type
    = "rowid"i { return { type: "rowid" }; }
    / "urowid"i _ size:("(" _ size:integer _ ")" { return size } )? { return { type: "urowid", size }; }

datetime_data_type
    = "date"i { return { type: "date" }; }
    / date_time_type_timestamp

date_time_type_timestamp
    = ""

integer
    = digits:[0-9]+ { return digits.join("");}

identifier_name
    = chars:[a-zA-Z]+ { return chars.join(""); }

_ 
    = [ \t\n\r]*
