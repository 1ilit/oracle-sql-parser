{
    const reservedKeywords = {
        ACCESS: true,
        ADD: true,
        ALL: true,
        ALTER: true,
        AND: true,
        ANY: true,
        AS: true,
        ASC: true,
        AUDIT: true,
        BETWEEN: true,
        BY: true,
        CHAR: true,
        CHECK: true,
        CLUSTER: true,
        COLUMN: true,
        COLUMN_VALUE: true,
        COMMENT: true,
        COMPRESSL: true,
        CONNECT: true,
        CREATE: true,
        CURRENT: true,
        DATE: true,
        DECIMAL: true,
        DEFAULT: true,
        DELETE: true,
        DESC: true,
        DISTINCT: true,
        DROP: true,
        ELSE: true,
        EXCLUSIVE: true,
        EXISTS: true,
        FILE: true,
        FLOAT: true,
        FOR: true,
        FROM: true,
        GRANT: true,
        GROUP: true,
        HAVING: true,
        IDENTIFIED: true,
        IMMEDIATE: true,
        IN: true,
        INCREMENT: true,
        INDEX: true,
        INITIAL: true,
        INSERT: true,
        INTEGER: true,
        INTERSECT: true,
        INTO: true,
        IS: true,
        LEVEL: true,
        LIKE: true,
        LOCK: true,
        LONG: true,
        MAXEXTENTS: true,
        MINUS: true,
        MLSLABEL: true,
        MODE: true,
        MODIFY: true,
        NESTED_TABLE_ID: true,
        NOAUDIT: true,
        NOCOMPRESS: true,
        NOT: true,
        NOWAIT: true,
        NULL: true,
        NUMBER: true,
        OF: true,
        OFFLINE: true,
        ON: true,
        ONLINE: true,
        OPTION: true,
        OR: true,
        ORDER: true,
        PCTFREE: true,
        PRIOR: true,
        PUBLIC: true,
        RAW: true,
        RENAME: true,
        RESOURCE: true,
        REVOKE: true,
        ROW: true,
        ROWID: true,
        ROWNUM: true,
        ROWS: true,
        SELECT: true,
        SESSION: true,
        SET: true,
        SHARE: true,
        SIZEL: true,
        SMALLINT: true,
        START: true,
        SUCCESSFUL: true,
        SYNONYM: true,
        SYSDATE: true,
        TABLE: true,
        THEN: true,
        TO: true,
        TRIGGER: true,
        UID: true,
        UNION: true,
        UNIQUE: true,
        UPDATE: true,
        USER: true,
        VALIDATE: true,
        VALUES: true,
        VARCHAR: true,
        VARCHAR2: true,
        VIEW: true,
        WHENEVER: true,
        WHERE: true,
        WITH: true,
    };
}

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
    / rowid_data_type
    / long_and_raw_data_type
    / datetime_data_type
    / large_object_data_type

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

// LONG AND RAW DATA TYPE
long_and_raw_data_type
    = "long raw"i { return { type: "long raw" }; }
    / "long"i { return { type: "long" }; }
    / "raw"i _ "(" _ size:integer _ ")" { return { type: "raw", size }; }

// LARGET OBJECT DATE TYPE
large_object_data_type
    = type:("blob"i / "clob"i / "nclob"i / "bfile"i) { return { type }; }

// ROWID DATA TYPE
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
    = name:ident_name !{ return reservedKeywords[name.toUpperCase()] === true; } {
      return name;
    }

ident_name
    = start:ident_start rest:ident_part* { return start + rest.join("") }

ident_start = [a-zA-Z_]

ident_part = [a-zA-Z0-9_]
_ 
    = [ \t\n\r]*
