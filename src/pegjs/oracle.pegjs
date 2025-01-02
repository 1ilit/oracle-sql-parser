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

    const validEncryptionAlgos = {
        AES128: true, 
        AES192: true, 
        AES256: true, 
        ARIA256: true, 
        GOST256: true, 
        SEED128: true,
        '3DES168': true, 
    };

    const validIntegrityAlgos = {
        NOMAC: true,
        'SHA-1': true, 
    };
}

start
    = create_table_stmt

create_table_stmt
    = KW_CREATE _ KW_TABLE _ 
      properties:table_properties? _ 
      schema:(s:identifier_name _ DOT _ { return s; })? name:identifier_name _
      sharing:table_sharing_clause?
      table:(relational_table / object_table / XMLType_table)
      memoptimize_for:table_memoptimize_clauses? _
      parent:table_parent_clause? _ SEMI_COLON { 
        return {
            name,
            table,
            parent,
            schema,
            sharing,
            properties,
            object: 'table', 
            memoptimize_for,
            operation: 'create', 
        }; 
      }

table_properties 
    = scope:(KW_GLOBAL / KW_PRIVATE) _ temporary:KW_TEMPORARY { return { scope, temporary }; }
    / shared:KW_SHARED { return { shared }; }
    / duplicated:KW_DUPLICATED { return { duplicated }; }
    / immutable:KW_IMMUTABLE? _ blockchain:KW_BLOCKCHAIN { return { immutable, blockchain }; }
    / immutable:KW_IMMUTABLE { return { immutable }; }

table_sharing_clause
    = sharing:KW_SHARING _ EQ _ attribute:(KW_METADATA / KW_DATA / KW_NONE / KW_EXTENDED _ KW_DATA) {
        return { 
            sharing, 
            attribute: Array.isArray(attribute) ? 
                       attribute.filter(e => typeof e === 'string').join(' ') : 
                       attribute 
        };
    }

table_memoptimize_clauses
    = clauses:(table_memoptimize_clause _)* {
      let optimize = {};
      clauses.forEach(( [operation] ) => {
        if (operation === 'read') optimize.read = 'read';
        if (operation === 'write') optimize.write = 'write';
      });
      return (optimize.read || optimize.write) ? optimize : null;
    }

table_memoptimize_clause
    = KW_MEMOPTIMIZE _ KW_FOR _ operation:(KW_READ / KW_WRITE) {
      return operation;
    }

table_parent_clause 
    = KW_PARENT _ schema:(s:identifier_name _ DOT _ { return s; })? table:identifier_name {
        return { schema, table };
    }

relational_table 
    = columns:(LPAR _ c:relational_properties _ RPAR { return c; })?
      blockchain_clauses:blockchain_table_clauses?_ 
      immutable_clauses:immutable_table_clauses? _ 
      collation:(KW_DEFAULT _ KW_COLLATION _ name:identifier_name { return { name }; })? _ 
      on_commit_definition:(KW_ON _ KW_COMMIT _ operation:(KW_DROP / KW_PRESERVE) _ KW_DEFINITION { return { operation }; })? _
      on_commit_rows:(KW_ON _ KW_COMMIT _ operation:(KW_DROP / KW_PRESERVE) _ KW_ROWS { return { operation }; })? { 
        return { immutable_clauses, blockchain_clauses, collation, on_commit_definition, on_commit_rows, columns };
      }

immutable_table_clauses 
    = no_drop_clause:immutable_table_no_drop_clause? _ no_delete_clause:immutable_table_no_delete_clause? {
        return { no_drop_clause, no_delete_clause };
    }

immutable_table_no_drop_clause 
    = KW_NO _ KW_DROP until_days_idle:(_ KW_UNTIL _ x:integer _ KW_DAYS _ KW_IDLE { return x; })? {
        return { no_drop: 'no drop', until_days_idle }
    }

immutable_table_no_delete_clause
    = KW_NO _ KW_DELETE _ 
      l:(locked:KW_LOCKED { return { locked }; } 
      / (_ KW_UNTIL _ x:integer _ KW_DAYS _ KW_AFTER _ KW_INSERT _  locked:KW_LOCKED? { return { until_days_after_insert: x, locked }; }))? {
        return { no_delete: 'no delete', ...l }
      }

blockchain_table_clauses
    = drop:blockchain_drop_table_clause _ row_retention:blockchain_row_retention_clause _ hash:blockchain_hash_and_data_format_clause {
        return { drop, row_retention, hash };
    }

blockchain_drop_table_clause 
    = immutable_table_no_drop_clause

blockchain_row_retention_clause
    = immutable_table_no_delete_clause

blockchain_hash_and_data_format_clause
    = hashing:KW_HASHING _ KW_USING _ 'sha2_512' _ KW_VERSION _ 'v1' { 
        return { hashing, encrypt: 'sha2_512', version: 'v1' };
    }

relational_properties 
    = x:column_definition xs:(_ COMMA _ c:column_definition { return c; })* { return [x, ...xs]; }

column_definition
    = name:identifier_name _ 
      type:data_type _ 
      collate:(KW_COLLATE _ n:identifier_name { return n; })? _
      sort:KW_SORT? _ 
      visibility:(KW_VISIBLE / KW_INVISIBLE)? _
      default_or_identity:(column_default_clause / identity_clause)? _
      encrypt:(e:KW_ENCRYPT _ spec:encryption_spec? { return { encrypt: e, spec}; })? _
      constraints:column_constraints? _ { 
        return { name, type, collate, sort, visibility, ...default_or_identity, encrypt, constraints }; 
      }

column_constraints
    = inline_constraints

inline_constraints
    = clauses:(_ c:inline_constraint _ { return c; })* {
      return clauses;
    }

inline_constraint
    = name:(KW_CONSTRAINT _ n:identifier_name { return n; })? _ 
      constraint:(
      (not:KW_NOT? _ KW_NULL { return { not_null: not ? 'not null' : 'null' }; }) /
      (unique:KW_UNIQUE { return { unique }; }) /
      (KW_PRIMARY _ KW_KEY { return { primary_key: 'primary key' }; }) /
      (KW_CHECK _ LPAR _ condition:condition _ RPAR { return { check: condition }; })
    ) {
      return { name, constraint };
    }

encryption_spec 
    = algorithm:(KW_USING _ x:single_quoted_str {
        if (!validEncryptionAlgos[x.toUpperCase()]) throw new Error(`Invalid encryption algorithm: ${x}`);
        return x;
      })? _
      identified_by_password:(KW_IDENTIFIED _ KW_BY _ password:ident_name { return password; })? _ 
      integrity_algorith:(x:single_quoted_str {
        if (!validIntegrityAlgos[x.toUpperCase()]) throw new Error(`Invalid integrity algorithm: ${x}`);
        return x;
      })? _ 
      salt:(no:KW_NO? _ KW_SALT { return `${no ? 'no ' : ''}salt`; })? {
        return { algorithm, identified_by_password, integrity_algorith, salt };
      }

column_default_clause
    = KW_DEFAULT _ on_null:(KW_ON _ KW_NULL { return 'on null'; })? _ expr:expr {
        return { default: { on_null, expr } };
    }

identity_clause
    = generated:KW_GENERATED _ 
      when:(KW_ALWAYS { return { always }; } 
           / KW_BY _ def:KW_DEFAULT on_null:(KW_ON _ KW_NULL { return 'on null'; })? { return { 'default': def, on_null }; })? _ 
      KW_AS _ KW_IDENTITY _
      options:identity_options? {
        return { identity: { generated, ...when, options } };
      }

identity_options
    = LPAR _ clauses:(
      order_clause /
      cycle_clause /
      cache_clause /
      minvalue_clause /
      maxvalue_clause /
      increment_clause /
      start_clause
    )+ _ RPAR {
      return clauses.reduce((acc, clause) => ({ ...acc, ...clause }), {});
    }

order_clause 
    = order:(KW_ORDER / KW_NOORDER) { return { order }; }

cycle_clause
    = cycle:(KW_CYCLE / KW_NOCYCLE) { return { cycle }; }

cache_clause
    = (cache:KW_CACHE _ value:integer { return { cache, value }; }) /
      (cache:KW_NOCACHE { return { cache }; })

minvalue_clause
    = (minvalue:KW_MINVALUE _ value:integer { return { minvalue, value }; }) /
      (minvalue:KW_NOMINVALUE { return { minvalue }; })

maxvalue_clause
    = (maxvalue:KW_MAXVALUE _ value:integer { return { maxvalue, value }; }) /
      (maxvalue:KW_NOMAXVALUE { return { maxvalue }; })

increment_clause
    = KW_INCREMENT _ KW_BY _ value:integer { return { increment_by: value }; }

start_clause
    = KW_START _ KW_WITH _ value:(integer / KW_LIMIT _ KW_VALUE { return 'limit value'; }) { return { start_with: value }; }

data_type
    = ansi_supported_data_type
    / oracle_supplied_type
    / oracle_built_in_data_type
//    / user_defined_type

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

// DATETIME TYPE
datetime_data_type
    = "date"i { return { type: "date" }; }
    / datetime_type_timestamp
    / datetime_type_interval_day
    / datetime_type_interval_year

datetime_type_timestamp
    = "timestamp"i _ precision:("("_ p:integer _")" { return p; })? _ with_tz:("with"i _ l:("local"i { return "local" })? _ "time"i _ "zone"i { return `with ${l?"local ":""}time zone`})? { return { type: "timestamp", fractional_seconds_precision: precision, with_tz }; }

datetime_type_interval_year
    = "interval"i _ "year"i _ precision:("("_ p:integer _")" { return p; })? _ "to" _ "month"i { return { type: "interval year", year_precision: precision, to_month: "to month" }; }

datetime_type_interval_day
    = "interval"i _ "day"i _ day_precision:("("_ p:integer _")" { return p; })? _ "to" _ "second"i _ fractional_seconds_precision:("("_ p:integer _")" { return p; })? { return { type: "interval day", day_precision, to_second: "to second", fractional_seconds_precision }; }

// ORACLE SUPPLIED TYPES
oracle_supplied_type
    = any_type
    / XML_type
    / spacial_type

spacial_type
    = type:("SDO_Geometry"i / "SDO_Topo_Geometry"i / "SDO_GeoRaster") { return { type: type.toLowerCase() }; }

XML_type
    = type:("XMLType"i / "URIType"i) { return { type: type.toLowerCase() }; }

any_type
    = type:("sys.anydataset"i / "sys.anydata"i / "sys.anytype"i) { return { type: type.toLowerCase() }; }

// ANSI SUPPORTED TYPES
ansi_supported_data_type 
    = type:KW_CHARACTER _ varying:KW_VARYING? _ LPAR _ size:integer _ RPAR 
      { return { type, varying, size }; }
    / type:(KW_CHAR / KW_NCHAR) _ varying:KW_VARYING _ LPAR _ size:integer _ RPAR 
      { return { type, varying, size }; }
    / type:KW_VARCHAR _ LPAR _ size:integer _ RPAR 
      { return { type, size }; }
    / type:KW_NATIONAL _ char:(KW_CHAR / KW_CHARACTER) _ varying:KW_VARYING? _ LPAR _ size:integer _ RPAR 
      { return { type, char, varying, size }; }
    / type:(KW_INT / KW_INTEGER / KW_SMALLINT / KW_REAL) 
      { return { type }; }
    / type:KW_FLOAT _ precision:(LPAR _ s:integer _ RPAR { return s; })? 
      { return { type, precision }; }
    / type:(KW_NUMERIC / KW_DECIMAL / KW_DEC) ps:(LPAR _ p:integer _ s:(COMMA _ s:integer { return s; })? _ RPAR { return { p, s }; })? 
      { return { type, precision: ps?.p, scale: ps?.s } }
    / type:(KW_DOUBLE _ KW_PRECISION) 
      { return { type: type.filter(e => typeof e === 'string').join(' ') }; }

object_table = ""

XMLType_table = ""

// TODO
expr = integer

// TODO
condition = ""

integer
    = digits:[0-9]+ { return digits.join("");}

single_quoted_str
    = SQUO chars:[^']+ SQUO { return chars.join(''); }

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

EQ             = '='
DOT            = '.'
LPAR           = '('
RPAR           = ')'
COMMA          = ','
SEMI_COLON     = ';'
SQUO           = "'"

KW_CREATE      = 'create'i      !ident_start { return 'create'; }
KW_TABLE       = 'table'i       !ident_start { return 'table'; }
KW_GLOBAL      = 'global'i      !ident_start { return 'global'; }
KW_PRIVATE     = 'private'i     !ident_start { return 'private'; }
KW_TEMPORARY   = 'temporary'i   !ident_start { return 'temporary'; }
KW_SHARED      = 'shared'i      !ident_start { return 'shared'; }
KW_DUPLICATED  = 'duplicated'i  !ident_start { return 'duplicated'; }
KW_IMMUTABLE   = 'immutable'i   !ident_start { return 'immutable'; }
KW_BLOCKCHAIN  = 'blockchain'i  !ident_start { return 'blockchain'; }
KW_SHARING     = 'sharing'i     !ident_start { return 'sharing'; }
KW_METADATA    = 'metadata'i    !ident_start { return 'metadata'; }
KW_DATA        = 'data'i        !ident_start { return 'data'; }
KW_EXTENDED    = 'extended'i    !ident_start { return 'extended'; }
KW_NONE        = 'none'i        !ident_start { return 'none'; }
KW_MEMOPTIMIZE = 'memoptimize'i !ident_start { return 'memoptimize'; }
KW_FOR         = 'for'i         !ident_start { return 'for'; }
KW_READ        = 'read'i        !ident_start { return 'read'; }
KW_WRITE       = 'write'i       !ident_start { return 'write'; }
KW_PARENT      = 'parent'i      !ident_start { return 'parent'; }
KW_NO          = 'no'i          !ident_start { return 'no'; }
KW_ON          = 'on'i          !ident_start { return 'on'; }
KW_NOT         = 'not'i         !ident_start { return 'not'; }
KW_DROP        = 'drop'i        !ident_start { return 'drop'; }
KW_DELETE      = 'delete'i      !ident_start { return 'delete'; }
KW_UNTIL       = 'until'i       !ident_start { return 'until'; }
KW_DAYS        = 'days'i        !ident_start { return 'days'; }
KW_IDLE        = 'idle'i        !ident_start { return 'idle'; }
KW_LOCKED      = 'locked'i      !ident_start { return 'locked'; }
KW_AFTER       = 'after'i       !ident_start { return 'after'; }
KW_INSERT      = 'insert'i      !ident_start { return 'insert'; }
KW_HASHING     = 'hashing'i     !ident_start { return 'hashing'; }
KW_USING       = 'using'i       !ident_start { return 'using'; }
KW_VERSION     = 'version'i     !ident_start { return 'version'; }
KW_DEFAULT     = 'default'i     !ident_start { return 'default'; }
KW_COLLATION   = 'collation'i   !ident_start { return 'collation'; }
KW_COLLATE     = 'collate'i     !ident_start { return 'collate'; }
KW_COMMIT      = 'commit'i      !ident_start { return 'commit'; }
KW_PRESERVE    = 'preserve'i    !ident_start { return 'preserve'; }
KW_DEFINITION  = 'definition'i  !ident_start { return 'definition'; }
KW_ROWS        = 'rows'i        !ident_start { return 'rows'; }
KW_SORT        = 'sort'i        !ident_start { return 'sort'; }
KW_VISIBLE     = 'visible'i     !ident_start { return 'visible'; }
KW_INVISIBLE   = 'invisible'i   !ident_start { return 'invisible'; }
KW_NULL        = 'null'i        !ident_start { return 'null'; }
KW_GENERATED   = 'generated'i   !ident_start { return 'generated'; }
KW_ALWAYS      = 'always'i      !ident_start { return 'always'; }
KW_BY          = 'by'i          !ident_start { return 'by'; }
KW_AS          = 'as'i          !ident_start { return 'as'; }
KW_IDENTITY    = 'identity'i    !ident_start { return 'identity'; }
KW_START       = 'start'i       !ident_start { return 'start'; }
KW_WITH        = 'with'i        !ident_start { return 'with'; }
KW_SALT        = 'salt'i        !ident_start { return 'salt'; }
KW_LIMIT       = 'limit'i       !ident_start { return 'limit'; }
KW_VALUE       = 'value'i       !ident_start { return 'value'; }
KW_INCREMENT   = 'increment'i   !ident_start { return 'increment'; }
KW_MAXVALUE    = 'maxvalue'i    !ident_start { return 'maxvalue'; }
KW_NOMAXVALUE  = 'nomaxvalue'i  !ident_start { return 'nomaxvalue'; }
KW_MINVALUE    = 'minvalue'i    !ident_start { return 'minvalue'; }
KW_NOMINVALUE  = 'nominvalue'i  !ident_start { return 'nominvalue'; }
KW_CYCLE       = 'cycle'i       !ident_start { return 'cycle'; }
KW_NOCYCLE     = 'nocycle'i     !ident_start { return 'nocycle'; }
KW_CACHE       = 'cache'i       !ident_start { return 'cache'; }
KW_NOCACHE     = 'nocache'i     !ident_start { return 'nocache'; }
KW_ORDER       = 'order'i       !ident_start { return 'order'; }
KW_NOORDER     = 'noorder'i     !ident_start { return 'noorder'; }
KW_ENCRYPT     = 'encrypt'i     !ident_start { return 'encrypt'; }
KW_IDENTIFIED  = 'identified'i  !ident_start { return 'identified'; }
KW_CONSTRAINT  = 'constraint'i  !ident_start { return 'constraint'; }
KW_UNIQUE      = 'unique'i      !ident_start { return 'unique'; }
KW_PRIMARY     = 'primary'i     !ident_start { return 'primary'; }
KW_KEY         = 'key'i         !ident_start { return 'key'; }
KW_CHECK       = 'check'i       !ident_start { return 'check'; }

KW_VARYING     = 'varying'i     !ident_start { return 'varying'; }
KW_VARCHAR     = 'varchar'i     !ident_start { return 'varchar'; } 
KW_CHARACTER   = 'character'i   !ident_start { return 'character'; }
KW_CHAR        = 'char'i        !ident_start { return 'char'; }
KW_NCHAR       = 'nchar'i       !ident_start { return 'nchar'; }
KW_NATIONAL    = 'national'i    !ident_start { return 'national'; }
KW_INT         = 'int'i         !ident_start { return 'int'; }
KW_INTEGER     = 'integer'i     !ident_start { return 'integer'; }
KW_SMALLINT    = 'smallint'i    !ident_start { return 'smallint'; }
KW_FLOAT       = 'float'i       !ident_start { return 'float'; }
KW_REAL        = 'real'i        !ident_start { return 'real'; }
KW_NUMERIC     = 'numeric'i     !ident_start { return 'numeric'; }
KW_DECIMAL     = 'decimal'i     !ident_start { return 'decimal'; }
KW_DEC         = 'dec'i         !ident_start { return 'dec'; }
KW_DOUBLE      = 'double'i      !ident_start { return 'double'; }
KW_PRECISION   = 'precision'i   !ident_start { return 'precision'; }