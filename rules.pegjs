{
    const validTypes = [
        "INTEGER",
        "VARCHAR",
        "DATE",
        "TIMESTAMP",
        "FLOAT",
        "TEXT"
    ];
}

start
    = create_table_stmt

create_table_stmt
    = _ "create"i _ "table"i _ name:identifier_name _ "(" _ x:column_definition xs:(_ "," _ column_definition)* _ ")" _ ";" 
    { return { op: "create", object: "table", columns: [x, ...(xs.map(col => col[3]))] }; }

column_definition
    = _ name:identifier_name _ type:data_type { return { name, type }; }
    
data_type
    = chars:[a-zA-Z]+ {
        const enteredType = chars.join("");
        if (validTypes.includes(enteredType.toUpperCase())) {
            return enteredType;
        } else {
            throw new Error("Unsupported type");
        }
    }

identifier_name
    = chars:[a-zA-Z]+ { return chars.join(""); }

_ 
    = [ \t\n\r]*
