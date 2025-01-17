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

    const validAccessDrivers = {
        ORACLE_LOADER: true, 
        ORACLE_DATAPUMP: true,
        ORACLE_HDFS: true, 
        ORACLE_HIVE: true,
    };
}

start
    = (_ c:stmt _ { return c; })*

stmt
    = create_table_stmt

create_table_stmt
    = operation:KW_CREATE _ 
      object:KW_TABLE _ 
      type:table_type? _ 
      schema:(s:identifier_name _ DOT _ { return s; })? 
      name:identifier_name _
      sharing:table_sharing_clause?
      table:(relational_table / object_table / XMLType_table)
      memoptimize_for:table_memoptimize_clauses? _
      parent:table_parent_clause? _ SEMI_COLON { 
        return {
            name,
            type,
            table,
            object, 
            parent,
            schema,
            sharing,
            operation, 
            memoptimize_for,
        }; 
      }

table_type 
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

// TODO: replace default collation with a rule
relational_table 
    = relational_properties:(LPAR _ c:relational_properties _ RPAR { return c; })?
      blockchain_clauses:blockchain_table_clauses?_ 
      immutable_clauses:immutable_table_clauses? _ 
      collation:(KW_DEFAULT _ KW_COLLATION _ name:identifier_name { return { name }; })? _ 
      on_commit_definition:(KW_ON _ KW_COMMIT _ operation:(KW_DROP / KW_PRESERVE) _ KW_DEFINITION { return { operation }; })? _
      on_commit_rows:(KW_ON _ KW_COMMIT _ operation:(KW_DROP / KW_PRESERVE) _ KW_ROWS { return { operation }; })? _
      physical_properties:physical_properties? _ 
      table_properties:table_properties? { 
        return { 
            collation,
            on_commit_rows,
            table_properties,
            immutable_clauses,
            blockchain_clauses,
            physical_properties,
            on_commit_definition,
            relational_properties,
         };
      }

table_properties
    = column_properties:column_properties? _ 
      read_only:read_only_clause? _ 
      indexing:indexing_clause? _
      table_partitioning:table_partitioning_clauses? _ 
      attribute_clusering:attribute_clusering_clause? _
      cache:(KW_CACHE / KW_NOCACHE)? _
      result_cache:result_cache_clause? _
      parallel:parallel_clause? _ 
      rowdependencies:(KW_NOROWDEPENDENCIES / KW_ROWDEPENDENCIES)? _ 
      enable_disable:enable_disable_clause? _
      row_movement:row_movement_clause? _
      logical_replication:logical_replication_clause? _
      flashback_archive:flashback_archive_clause? _
      row_archival:(KW_ROW _ KW_ARCHIVAL { return 'row archival'; } )? _
      rest:(
        KW_AS _ subquery:subquery { return { as: subquery }; } /
        KW_FOR _ KW_EXCHANGE _ KW_WITH _ KW_TABLE _ schema:(s:identifier_name _ DOT { return s; }) _ table:identifier_name {
            return { for_exchange: { schema, table } };
        }
      )? {
        const props = {
            ...rest,
            cache,
            parallel,
            indexing,
            read_only,
            row_movement,
            result_cache,
            enable_disable,
            rowdependencies,
            column_properties,
            flashback_archive,
            table_partitioning,
            attribute_clusering,
            logical_replication,
        }

        return Object.values(props).some(x => x) ? props : null; 
    }

flashback_archive_clause
    = flashback:KW_FLASHBACK _ KW_ARCHIVE _ archive:identifier_name? { return { flashback, archive }; }
    / KW_NO _ KW_FLASHBACK _ KW_ARCHIVE { return { flashback: 'no flashback' }; }

logical_replication_clause
    = enable:KW_DISABLE _ KW_LOGICAL _ KW_REPLICATION { return { enable }; }
    / enable:KW_ENABLE _ KW_LOGICAL _ KW_REPLICATION _ 
      keys_setting:(x:(KW_ALL / KW_ALLOW _ KW_NOVALIDATE { return 'allow novalidate'; }) _ KW_KEYS { return x; })? {
        return { enable, keys_setting };
      }

row_movement_clause
    = enable:(KW_ENABLE / KW_DISABLE) _ KW_ROW _ KW_MOVEMENT {
        return { enable };
    }

enable_disable_clause
    = enable:(KW_ENABLE / KW_DISABLE) _
      validate:(KW_VALIDATE / KW_NOVALIDATE)? _
      constraint:(
        unique:KW_UNIQUE _ LPAR _ columns:comma_separated_identifiers _ RPAR { return { unique, columns }; } /
        KW_PRIMARY _ KW_KEY { return { primary_key: 'primary key' }; } /
        KW_CONSTRAINT _ constraint:identifier_name { return { constraint }; }
      ) _ 
      using_index:using_index_clause? _
      exceptions:exception_clause? _
      cascade:KW_CASCADE? _
      index_action:(action:(KW_DROP / KW_KEEP) _ index:KW_INDEX { return { action, index }; })? {
        return {
            enable,
            cascade,
            validate,
            exceptions,
            constraint,
            using_index,
            index_action,
        };
      }

parallel_clause
    = parallel:KW_NOPARALLEL { return { parallel }; }
    / parallel:KW_PARALLEL _ value:integer? { return { parallel, value }; }

result_cache_clause
    = KW_RESULT_CACHE _ LPAR _
      rest:(
        mode:(KW_MODE _ m:(KW_DEFAULT / KW_FORCE) { return m; })? _ 
        standby:(_ COMMA _ KW_STANDBY _ s:(KW_ENABLE / KW_DISABLE) { return s;}) { 
            return { mode, standby };
        } /
        standby:(KW_STANDBY _ s:(KW_ENABLE / KW_DISABLE) { return s;}) _ 
        mode:(_ COMMA _ KW_MODE _ m:(KW_DEFAULT / KW_FORCE) { return m; }) { 
            return { mode, standby };
        }
      ) _ RPAR {
        return { ...rest };
      }

attribute_clusering_clause
    = KW_CLUSTERING _ 
      join:clusering_join _ 
      cluster:cluster_clause _ 
      when:clustering_when? _ 
      zonemap:zonemap_clause? {
        return { join, cluster, when, zonemap };
      }

zonemap_clause
    = w:KW_WITH _ KW_MATERIALIZED _ KW_ZONEMAP _ 
      zonemap:(LPAR _ z:identifier_name _ RPAR { return z; }) { 
        return { with: w, zonemap }; 
      } 
    / w:KW_WITHOUT _ KW_MATERIALIZED _ KW_ZONEMAP { return { with:w }; }

clustering_when
    = on_load:(x:(KW_NO / KW_YES) _ KW_ON _ KW_LOAD { return x; })? _
      on_data_movement:(x:(KW_NO / KW_YES) _ KW_ON _ KW_DATA _ KW_MOVEMENT { return x; })? {
        return { on_load, on_data_movement };
      }

cluster_clause
    = KW_BY _ option:(KW_LINEAR / KW_INTERLEAVED)? _ KW_ORDER _ columns:clustering_columns {
        return { option, columns };
    }

clustering_columns
    = clustering_column_group
    / LPAR _ x:clustering_column_group (_ COMMA _ c:clustering_column_group { return c; })* _ RPAR {
        return [x, ...xs];
    }

clustering_column_group
    = LPAR _ columns:comma_separated_identifiers _ RPAR {
        return columns;
    }

clusering_join
    = table:schema_table _ joins:clusering_join_stmts {
        return { table, joins };
    }

clusering_join_stmts
    = x:clusering_join_stmt 
      xs:(_ COMMA _ a:clusering_join_stmt { return a; })* {
        return [x, ...xs];
      }

clusering_join_stmt
    = KW_JOIN _ join_table:schema_table _ KW_ON _ LPAR _ condition:equijoin_condition _ RPAR {
        return { join_table, condition };
      }

equijoin_condition
    = left_table:schema_table _ EQ _ right_table:schema_table {
        return { left_table, right_table };
    }

// TODO: replace rest of the instances with this rule
schema_table
    = schema:(s:identifier_name _ DOT { return s; })? _ table:identifier_name {
        return { schema, table };
    }

table_partitioning_clauses
    = range_partitions
    / list_partitions
    / hash_partitions
    / composite_range_partitions
    / composite_list_partitions
    / composite_hash_partitions
    / reference_partitioning
    / system_partitioning
    / consistent_hash_partitions
    / consistent_hash_with_subpartitions
    / partitionset_clauses

partitionset_clauses
    = range_partitionset_clause
    / list_partitionset_clause

list_partitionset_clause
    = KW_PARTITIONSET _ KW_BY _ KW_LIST _ LPAR _
      list_columns:comma_separated_identifiers _ RPAR _ 
      KW_PARTITION _ KW_BY _ KW_CONSISTENT _ KW_HASH _ LPAR _ 
      hash_columns:comma_separated_identifiers _ RPAR _ 
      subpartition:(KW_SUBPARTITION _ KW_BY _ 
        by:(
          option:(KW_RANGE / KW_HASH) _ LPAR _ columns:comma_separated_identifiers _ RPAR { return { option, columns };} /
          option:KW_LIST _ LPAR _ column:identifier_name _ RPAR { return { option, column }; }
        ) _ 
        template:subpartition_template? {
            return { by, template };
        }
      ) _
      KW_PARTITIONS _ KW_AUTO _ LPAR _ 
      desc:(x:list_partitionset_desc xs:(_ COMMA _ r:list_partitionset_desc)* { return [x, ...xs]; }) _ RPAR {
        return { 
            desc,
            hash_columns,
            subpartition,
            list_columns,
        };
      }

list_partitionset_desc
    = KW_PARTITIONSET _ 
      partitionset:identifier_name _ 
      list_values:list_values_clause _ 
      tablespace_set:(KW_TABLESPACE _ KW_SET _ x:identifier_name { return x; })? _ 
      lob_storage:LOB_storage_clause? _ 
      subpartitions:(KW_SUBPARTITIONS _ KW_STORE _ KW_IN _ LPAR _ x:comma_separated_identifiers _ RPAR { 
        return { store_in: x };
      })? {
        return { 
            partitionset, 
            list_values,
            tablespace_set,
            lob_storage,
            subpartitions,
        };
      }

range_partitionset_clause
    = KW_PARTITIONSET _ KW_BY _ KW_RANGE _ LPAR _
      range_columns:comma_separated_identifiers _ RPAR _ 
      KW_PARTITION _ KW_BY _ KW_CONSISTENT _ KW_HASH _ LPAR _ 
      hash_columns:comma_separated_identifiers _ RPAR _ 
      subpartition:(KW_SUBPARTITION _ KW_BY _ 
        by:(
          option:(KW_RANGE / KW_HASH) _ LPAR _ columns:comma_separated_identifiers _ RPAR { return { option, columns };} /
          option:KW_LIST _ LPAR _ column:identifier_name _ RPAR { return { option, column }; }
        ) _ 
        template:subpartition_template? {
            return { by, template };
        }
      ) _
      KW_PARTITIONS _ KW_AUTO _ LPAR _ 
      desc:(x:range_partitionset_desc xs:(_ COMMA _ r:range_partitionset_desc)* { return [x, ...xs]; }) _ RPAR {
        return { 
            desc,
            hash_columns,
            subpartition,
            range_columns,
        };
      }

range_partitionset_desc
    = KW_PARTITIONSET _ 
      partitionset:identifier_name _ 
      range_values:range_values_clause _ 
      tablespace_set:(KW_TABLESPACE _ KW_SET _ x:identifier_name { return x; })? _ 
      lob_storage:LOB_storage_clause? _ 
      subpartitions:(KW_SUBPARTITIONS _ KW_STORE _ KW_IN _ LPAR _ x:comma_separated_identifiers _ RPAR { 
        return { store_in: x };
      })? {
        return { 
            partitionset, 
            range_values,
            tablespace_set,
            lob_storage,
            subpartitions,
        };
      }

consistent_hash_partitions
    = KW_PARTITION _ KW_BY _ consistent:KW_CONSISTENT _ KW_HASH _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      partitions:(KW_PARTITIONS _ a:KW_AUTO { return a; })? _ 
      KW_TABLESPACE _ KW_SET _ tablespace_set:identifier_name {
        return {
            columns,
            consistent,
            partitions,
            tablespace_set,
            partition: 'by hash',
        }
      }

consistent_hash_with_subpartitions
    = KW_PARTITION _ KW_BY _ consistent:KW_CONSISTENT _ KW_HASH _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      subpartition:subpartition _
      partitions:(KW_PARTITIONS _ a:KW_AUTO { return a; })? {
        return {
            columns,
            consistent,
            partitions,
            subpartition,
            partition: 'by hash',
        }
      }


composite_hash_partitions
    = KW_PARTITION _ KW_BY _ KW_HASH _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      subpartition:subpartition _
      partitions:(individual_hash_partitions / hash_partitions_by_quantity) {
        return {
            columns,
            partitions,
            subpartition,
            partition: 'by hash',
        }
      }

composite_list_partitions
    = KW_PARTITION _ KW_BY _ KW_LIST _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      automatic:(KW_AUTOMATIC _
        store_in:(KW_STORE _ KW_IN _ LPAR _ 
            tablespaces:comma_separated_identifiers _ RPAR {
                return { tablespaces };
            }
        )? { 
        return { store_in }; 
      })? _ LPAR _ 
      subpartition:subpartition _
      list_partition_desc:list_partition_descs {
        return {
            columns,
            automatic,
            subpartition,
            list_partition_desc,
            partition: 'by list',
        }
      }

list_partition_descs
    = LPAR _ x:list_partition_desc xs:(_ COMMA _ r:list_partition_desc { return r; }) _ RPAR {
        return [x, ...xs];
    }

list_partition_desc
    = KW_PARTITION _
      partition:identifier_name? _ 
      list_values:list_values_clause _
      table_partition:table_partition_description _
      subparts:(
        hash_subpartition_quantity:integer { return { hash_subpartition_quantity }; } /
        LPAR _ desc:(list_subpartition_desc_arr / range_subpartition_desc_arr / individual_hash_subparts_arr) _ RPAR { return { desc }; }
      )? {
        return { partition, range_values, table_partition, subparts };
      }

composite_range_partitions
    = KW_PARTITION _ KW_BY _ KW_RANGE _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      interval:(KW_INTERVAL _ LPAR _ 
        expr:expr _ RPAR _ 
        store_in:(KW_STORE _ KW_IN _ LPAR _ 
            tablespaces:comma_separated_identifiers _ RPAR {
                return { tablespaces };
            }
        )? { 
        return { expr, store_in }; 
      })? _ 
      subpartition:subpartition _
      range_partition_desc:range_partition_descs {
        return {
            columns,
            interval,
            subpartition,
            range_partition_desc,
            partition: 'by range',
        }
      }

range_partition_descs
    = LPAR _ x:range_partition_desc xs:(_ COMMA _ r:range_partition_desc { return r; }) _ RPAR {
        return [x, ...xs];
    }

range_partition_desc
    = KW_PARTITION _
      partition:identifier_name? _ 
      range_values:range_values_clause _
      table_partition:table_partition_description _
      subparts:(
        hash_subpartition_quantity:integer { return { hash_subpartition_quantity }; } /
        LPAR _ desc:(list_subpartition_desc_arr / range_subpartition_desc_arr / individual_hash_subparts_arr) _ RPAR { return { desc }; }
      )? {
        return { partition, range_values, table_partition, subparts };
      }

subpartition
    = subpartition_by_range
    / subpartition_by_list
    / subpartition_by_hash

subpartition_by_hash
    = KW_SUBPARTITION _ KW_BY _ KW_HASH _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      template:(
        subpartition_template / 
        KW_SUBPARTITIONS _ 
        quantity:integer _ 
        store_in:(KW_STORE _ KW_IN _ LPAR _ tablespaces:comma_separated_identifiers _ RPAR { return { tablespaces }; })? {
            return { quantity, store_in };
        }
      )? {
        return { subpartition: 'by hash', columns, template };
      }

subpartition_by_range
    = KW_SUBPARTITION _ KW_BY _ KW_RANGE _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      template:subpartition_template? {
        return { subpartition: 'by range', columns, template };
      }

subpartition_by_list
    = KW_SUBPARTITION _ KW_BY _ KW_LIST _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      template:subpartition_template? {
        return { subpartition: 'by list', columns, template };
      }

subpartition_template
    = KW_SUBPARTITION _ KW_TEMPLATE _ 
      rest:(
        hash_subpartition_quantity:integer { return { hash_subpartition_quantity }; } /
        LPAR _ desc:(list_subpartition_desc_arr / range_subpartition_desc_arr / individual_hash_subparts_arr) _ RPAR { return { desc }; }
      ) {
        return { ...rest };
      }

range_subpartition_desc_arr
    = x:range_subpartition_desc xs:(_ COMMA _ r:range_subpartition_desc { return r; })* {
        return [x, ...xs];
    }

list_subpartition_desc_arr
    = x:list_subpartition_desc xs:(_ COMMA _ r:list_subpartition_desc { return r; })* {
        return [x, ...xs];
    }

individual_hash_subparts_arr
    = x:individual_hash_subparts xs:(_ COMMA _ r:individual_hash_subparts { return r; })* {
        return [x, ...xs];
    }

range_subpartition_desc
    = KW_SUBPARTITION _ 
      subpartition:identifier_name? _
      range_values:range_values_clause _
      read_only:read_only_clause? _ 
      indexing:indexing_clause? _ 
      partition_storage:partitioning_storage_clause? _
      external_data_props:external_part_subpart_data_props? {
        return {
            subpartition,
            range_values,
            read_only,
            indexing,
            partition_storage,
            external_data_props,
        };
      }

list_subpartition_desc
    = KW_SUBPARTITION _ 
      subpartition:identifier_name? _
      list_values:list_values_clause _
      read_only:read_only_clause? _ 
      indexing:indexing_clause? _ 
      partition_storage:partitioning_storage_clause? _
      external_data_props:external_part_subpart_data_props? {
        return {
            subpartition,
            list_values,
            read_only,
            indexing,
            partition_storage,
            external_data_props,
        };
      }

individual_hash_subparts
    = KW_SUBPARTITION _ 
      subpartition:identifier_name? _
      read_only:read_only_clause? _ 
      indexing:indexing_clause? _ 
      partition_storage:partitioning_storage_clause? _ {
        return {
            subpartition,
            read_only,
            indexing,
            partition_storage,
        };
      }

hash_partitions
    = KW_PARTITION _ KW_BY _ KW_HASH _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      partitions:(individual_hash_partitions / hash_partitions_by_quantity) {
        return {
            columns,
            partitions,
            partition: 'by hash',
        }
      }

individual_hash_partitions
    = LPAR _ 
      x:individual_hash_partition 
      xs:(_ COMMA _ a:individual_hash_partition { return a; })* _ RPAR { 
        return [x, ...xs]; 
      }

individual_hash_partition
    = KW_PARTITION _ 
      partition:identifier_name? _ 
      read_only:read_only_clause? _ 
      indexing:indexing_clause? _
      partition_storage:partitioning_storage_clause? _ {
        return {
            partition,
            read_only,
            indexing,
            partition_storage,
        };
      }

partitioning_storage_clause
    = (_ x:partitioning_storage_options _ { return x; })*

partitioning_storage_options
    = inmemory_clause
    / LOB_partitioning_storage
    / ilm_clause
    / index_compression
    / table_compression
    / JSON_storage_clause
    / tablespace_or_tablespace_set
    / overflow:KW_OVERFLOW _ tablespace:tablespace_or_tablespace_set? { return { overflow, tablespace }; }
    / varray:KW_VARRAY _ varray_item:identifier_name _ KW_STORE _ KW_AS _ store_as:(KW_SECUREFILE / KW_BASICFILE)? _ KW_LOB _ lob_segname:identifier_name {
        return { varray, varray_item, store_as, lob_segname };
      }

tablespace_or_tablespace_set
    = LPAR _ KW_TABLESPACE _ KW_SET _ tablespace_set:identifier_name _ RPAR { return { tablespace_set }; } 
    / LPAR _ KW_TABLESPACE _ tablespace:identifier_name _ RPAR { return { tablespace }; } 

index_compression
    = prefix_compression
    / advanced_index_compression

advanced_index_compression
    = compress:KW_COMPRESS _ advanced:KW_ADVANCED _ level:(KW_HIGH / KW_LOW)? { return { compress, advanced, level }; }
    / compress:KW_NOCOMPRESS { return { compress }; }

hash_partitions_by_quantity
    = KW_PARTITIONS _ 
      quantity:integer _ 
      store_in:(KW_STORE _ KW_IN _ LPAR _ tablespaces:comma_separated_identifiers _ RPAR { return { tablespaces }; })? _
      compression:(table_compression / index_compression)? _
      overflow:(KW_OVERFLOW _ KW_STORE _ KW_IN _ LPAR _ tablespaces:comma_separated_identifiers _ RPAR { return { tablespaces }; })? {
        return { quantity, store_in, compression, overflow };
      }

list_partitions
    = KW_PARTITION _ KW_BY _ KW_LIST _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      automatic:(KW_AUTOMATIC _
        store_in:(KW_STORE _ KW_IN _ LPAR _ 
            tablespaces:comma_separated_identifiers _ RPAR {
                return { tablespaces };
            }
        )? { 
        return { store_in }; 
      })? _ LPAR _ 
      partitions:(x:list_partition xs:(_ COMMA _ p:list_partition { return p; })* { return [x, ...xs]; }) _ RPAR {
        return {
            columns,
            automatic,
            partitions,
            partition: 'by list',
        }
      }

list_partition
    = KW_PARTITION _ 
      partition:identifier_name? _ 
      list_values:list_values_clause _ 
      table_partition:table_partition_description _
      external_data_props:external_part_subpart_data_props? _ {
        return {
            partition,
            list_values,
            table_partition,
            external_data_props,
        };
      }

list_values_clause
    = KW_VALUES _ LPAR _ value:(KW_DEFAULT / list_values) _ RPAR {
        return value;
    }

list_values_list
    = x:(LPAR _ l:list_values _ RPAR { return l; }) 
      xs:(_ COMMA _ a:(LPAR _ l:list_values _ RPAR { return l; }) { return a; })* { 
        return [x, ...xs]; 
      }

list_values
    = x:(KW_NULL / literal) xs:(_ COMMA _ a:(KW_NULL / literal) { return a; })* { return [x, ...xs]; }

reference_partitioning
    = KW_PARTITION _ KW_BY _ KW_REFERENCE _ LPAR _ 
      constraint:identifier_name _ 
      partitions:(LPAR _ p:reference_partition_desc _ RPAR { return r; } )? {
        return {
            constraint,
            partitions,
            partition: 'by reference',
        };
      }

system_partitioning
    = KW_PARTITION _ KW_BY _ KW_SYSTEM _
      partitions:(
        KW_PARTITIONS _ value:integer { return { value }; } / reference_partition_desc
      )? {
        return {
            partitions,
            partiton: 'by system',
        };
      }

reference_partition_desc
    = x:reference_partition_option xs:(_ COMMA _ r:reference_partition_option { return r; })* {
        return [x, ...xs];
    }

reference_partition_option
    = KW_PARTITION _ partition:identifier_name? _ table_partition:table_partition_description? {
        return { partition, table_partition };
    }

range_partitions
    = KW_PARTITION _ KW_BY _ KW_RANGE _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      interval:(KW_INTERVAL _ LPAR _ 
        expr:expr _ RPAR _ 
        store_in:(KW_STORE _ KW_IN _ LPAR _ 
            tablespaces:comma_separated_identifiers _ RPAR {
                return { tablespaces };
            }
        )? { 
        return { expr, store_in }; 
      })? _ LPAR _ 
      partitions:(x:range_partition xs:(_ COMMA _ p:range_partition { return p; })* { return [x, ...xs]; }) _ RPAR {
        return {
            columns,
            interval,
            partitions,
            partition: 'by range',
        }
      }

range_partition
    = KW_PARTITION _ 
      partition:identifier_name? _ 
      range_values:range_values_clause _ 
      table_partition:table_partition_description _
      external_data_props:external_part_subpart_data_props? _ {
        return {
            partition,
            range_values,
            table_partition,
            external_data_props,
        };
      }

external_part_subpart_data_props
    = default_directory:(KW_DEFAULT _ KW_DIRECTORY dir:identifier_name { return dir; })? _ 
      location:(KW_LOCATION _ LPAR _ dirs:external_table_data_prop_dirs _ RPAR { return dirs; })? {
        return { default_directory, location };
      }

table_partition_description
    = type:(KW_INTERNAL / KW_EXTERNAL)? _
      deferred_segment_creation:deferred_segment_creation? _ 
      read_only:read_only_clause? _ 
      indexing:indexing_clause? _
      segment_attributes:segment_attributes_clause? _
      compression:(table_compression / prefix_compression)? _ 
      inmemory:inmemory_clause? _
      ilm:ilm_clause? _
      overflow:(KW_OVERFLOW _ s:segment_attributes_clause? { return { segment_attributes: s }; })? _ 
      properties:table_partition_description_props? {
        return {
            ilm,
            type,
            indexing,
            inmemory,
            overflow,
            read_only,
            properties,
            compression,
            segment_attributes,
            deferred_segment_creation,
        };
      }

table_partition_description_props
    = (_ p:table_partition_description_prop _ { return p; })+

table_partition_description_prop
    = JSON_storage_clause
    / LOB_storage_clause
    / varray_col_properties
    / nested_table_col_properties

inmemory_clause
    = KW_NO _ KW_INMEMORY { return { setting: 'no inmemory' }; }
    / KW_INMEMORY _ attributes:inmemory_attributes? _ 
      text:(
        columns:comma_separated_identifiers { return columns; } /
        columns:(x:inmemory_col_policy xs:(_ COMMA _ i:inmemory_col_policy { return i; })* { return [x, ...xs]; })
      ) {
        return { text, attributes, setting: 'inmemory' };
      }

inmemory_col_policy
    = column:identifier_name _ KW_USING _ policy:identifier_name {
        return { column, policy };
    }

range_values_clause
    = KW_VALUES _ KW_LESS _ KW_THAN _ LPAR _ 
      values:(x:range_value xs:(_ COMMA _ r:range_value { return r; })* { return [x, ...xs]; }) _ RPAR {
        return values;
      }

range_value 
    = KW_MAXVALUE
    / literal 

read_only_clause
    = KW_READ _ KW_ONLY { return 'read only'; }
    / KW_READ _ KW_WRITE { return 'read write'; }

indexing_clause
    = KW_INDEXING _ mode:(KW_ON / KW_OFF) {
        return mode;
    }

column_properties
    = xs:(_ x:column_property { return x; })+ {
      return xs;
    }

column_property
    = object_type_col_properties
    / nested_table_col_properties
    / JSON_storage_clause
    / v:varray_col_properties p:(_ LPAR _ x:LOB_partition_storage xs:(_ COMMA _ LOB_partition_storage)* _ RPAR { 
        return [x, ...xs]; 
      })? { 
        return {...v, lob_partition: p }; 
      }
    / l:LOB_storage_clause p:(_ LPAR _ x:LOB_partition_storage xs:(_ COMMA _ LOB_partition_storage)* _ RPAR { 
        return [x, ...xs]; 
      })? { 
        return {...l, lob_partition: p }; 
      }

LOB_partition_storage
    = KW_PARTITION _ 
      partition:identifier_name _ 
      options:(_ x:(varray_col_properties / LOB_storage_clause) { return x; })+ _
      subpartition:(
        LPAR _ KW_SUBPARTITION _ 
        name:identifier_name _ 
        opts:(_ x:(varray_col_properties / LOB_partitioning_storage) { return x; })+ _ RPAR {
            return { name, options: opts };
        }
      )? {
        return { partition, options, subpartition };
      }

LOB_partitioning_storage
    = lob:KW_LOB _ LPAR _ item:identifier_name _ LPAR _ 
      KW_STORE _ KW_AS filetype:(KW_BASICFILE / KW_SECUREFILE)? _ 
      rest:(
          tablespace_or_tablespace_set /
          segname:identifier_name _ tablespace:(
            tablespace_or_tablespace_set
          )? {
            return { segname, ...tablespace };
          }
      )? {
        return { lob, item, filetype, ...rest };
      }

LOB_storage_clause
    = lob:KW_LOB _ 
      rest:(
          LPAR _ items:comma_separated_identifiers _ RPAR _ 
          store_as:(KW_STORE _ KW_AS _ x:LOB_storage_store_as_wo_segname { return x; }) { 
            return { items, store_as };
          } / 
          LPAR _ item:identifier_name _ RPAR _ 
          store_as:(KW_STORE _ KW_AS _ x:LOB_storage_store_as_w_segname { return x; }) { 
            return { item, store_as };
          }
      ) {
        return { lob, ...rest };
      }

LOB_storage_store_as_w_segname
    = xs:( _ x:(
        basicfile:KW_BASICFILE  { return { basicfile }; } / 
        securefile:KW_SECUREFILE { return { securefile }; } /
        lob_segname:identifier_name { return { lob_segname }; } /
        LPAR _ lob_storage_params:LOB_storage_parameters _ RPAR { return { lob_storage_params }; }) _ {
            return x;
        }
    )+ {
        return xs;
    }

LOB_storage_store_as_wo_segname
    = xs:( _ x:(
        basicfile:KW_BASICFILE  { return { basicfile }; } / 
        securefile:KW_SECUREFILE { return { securefile }; } /
        LPAR _ lob_storage_params:LOB_storage_parameters _ RPAR { return { lob_storage_params }; }) _ {
            return x;
        }
    )+ {
        return xs;
    }

varray_col_properties
    = varray:KW_VARRAY _ 
      varray_item:identifier_name _
      rest:(
        substitutable_column:substitutable_column_clause { return { substitutable_column }; } /
        substitutable_column:substitutable_column_clause? _ varray_storage:varray_storage_clause { 
            return { substitutable_column, varray_storage }; 
        }
      ) {
        return { varray, varray_item, ...rest };
      }

varray_storage_clause
    = KW_STORE _ KW_AS _ 
      store_as:(KW_SECUREFILE / KW_BASICFILE)? _
      lob:(KW_LOB _ 
        opts:(
            segname:identifier_name { return { segname }; } /
            segname:identifier_name? _ LPAR _ storage_params:LOB_storage_parameters _ RPAR { 
                return { segname, storage_params }; 
            }
        ) {
            return { ...opts };
        }
      ) {
        return { store_as, lob };
      }

LOB_storage_parameters
    = storage_clause 
    / params:(
        _ param:(
            lob_parameters:LOB_parameters _ storage:storage_clause? { return { lob_parameters, storage }; } /
            KW_TABLESPACE _ KW_SET _ tablespace_set:identifier_name { return { tablespace_set }; } /
            KW_TABLESPACE _ tablespace:identifier_name { return { tablespace }; }
        ) _ {
            return param;
        }
      )+ {
        return params;
      }

LOB_parameters
    = xs:(_ x:LOB_param { return x; })+ { return xs; }

LOB_param
    = KW_CHUNK _ chunk:integer { return { chunk }; }
    / KW_PCTVERSION _ pctversion:integer { return { pctversion }; }
    / KW_FREEPOOLS _ freepools:integer { return { freepools }; }
    / enable:(KW_ENABLE / KW_DISABLE) _ KW_STORAGE _ KW_IN _ KW_ROW { 
        return { enable, storage_in_row: 'storage in row' };
      }
    / encrypt:KW_ENCRYPT _ specs:encryption_spec { return { encrypt, specs }; }
    / encrypt:KW_DECRYPT { return { encrypt }; }
    / cache:(KW_CACHE / KW_NOCACHE / KW_CACHE _ KW_READS { return 'cache reads'; }) _
      logging:logging_clause? {
        return { cache, logging };
      }
    / LOB_deduplicate_clause
    / LOB_deduplicate_clause
    / LOB_compression_clause

LOB_deduplicate_clause
    = deduplicate:(KW_DEDUPLICATE / KW_KEEP_DUPLICATES) {
        return { deduplicate };
    }    

LOB_retention_clause
    = KW_RETENTION _ 
      retention:(
        metric:(KW_MAX / KW_NONE / KW_AUTO) { return { metric }; } /
        metric:KW_MIN _ value:integer { return { metric, value }; }
      )? {
        return { retention };
      }

LOB_compression_clause
    = compression:KW_NOCOMPRESS { return { compress }; }
    / compression:KW_COMPRESS _ level:(KW_LOW / KW_MEDIUM / KW_HIGH) { return { compression, level }; }

JSON_storage_clause
    = json:KW_JSON _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR _
      store_as:(KW_STORE _ KW_AS _ lob_segname:identifier_name? _ params:JSON_parameters? {
        return { lob_segname, params };
      }) {
        return { json, columns, store_as };
      }

JSON_parameters
    = LPAR _ x:JSON_param xs:(_ COMMA _ p:JSON_param { return p; })* _ RPAR {
        return [x, ...xs];
    }

JSON_param
    = KW_TABLESPACE _ tablespace:identifier_name { return { tablespace }; }
    / storage:storage_clause { return { storage }; }
    / retention:KW_RETENTION { return { retention }; }
    / KW_CHUNK _ chunck:integer { return { chunck }; }
    / KW_PCTVERSION _ pctversion:integer { return { pctversion }; }
    / KW_FREEPOOLS _ freepools:integer { return { freepools }; }

nested_table_col_properties
    = nested:KW_NESTED _ KW_TABLE _ 
      item:('COLUMN_VALUE'i / identifier_name) _ 
      substitutable_column:substitutable_column_clause? _
      scope:(KW_LOCAL / KW_GLOBAL)? _
      store_as:(
        KW_STORE _ KW_AS _ 
        storage_table:identifier_name _ 
        properties:nested_table_col_prop_store_props? {
            return { storage_table, properties };
        }
      ) _
      ret:(KW_RETURN _ as:KW_AS? _ option:(KW_LOCATOR / KW_VALUE) { return { as, option }; }) {
        return {
            item,
            scope,
            nested,
            store_as,
            return: ret,
            substitutable_column,
        }
      }

nested_table_col_prop_store_props
    = LPAR _ xs:(_ x:nested_table_col_prop_store_prop _ { return x; })+ _ RPAR {
        return xs;
    }

nested_table_col_prop_store_prop
    = LPAR _ x:object_properties _ RPAR { return { ...x, property: 'object' }; }
    / x:physical_properties { return { ...x, property: 'physical' }; }
    / x:column_properties { return { ...x, property: 'column' }; }

object_properties
    = column:identifier_name _ def:(KW_DEFAULT _ e:expr { return e; })? _ constraints:column_constraints? {
        return { column, default: def, constraints };
      }
    / out_of_line_constraint
    / out_of_line_ref_constraint
    / supplemental_logging_props

object_type_col_properties
    = KW_COLUMN _ 
      column:identifier_name _ 
      subsubstitutable_column:substitutable_column_clause {
        return { column, subsubstitutable_column };
      }

substitutable_column_clause
    = not:KW_NOT? _ substitutable:KW_SUBSTITUTABLE _ KW_AT _ KW_ALL _ KW_LEVELS {
        return { not, substitutable, at_all_levels: 'at all levels' };
      } 
    / element:KW_ELEMENT? _ KW_IS _ KW_OF _ KW_TYPE? _ LPAR _ KW_ONLY _ type:identifier_name _ RPAR {
        return { element, is_of_type: type };
      }

physical_properties
    = physical_properties_1
    / physical_properties_2
    / physical_properties_3

physical_properties_1
    = deferred_segment_creation:deferred_segment_creation? _
      segment_attributes:segment_attributes_clause _
      compression:table_compression? _
      inmemory_table:inmemory_table_clause? _
      ilm:ilm_clause? _ {
        return { 
            ilm,
            compression, 
            inmemory_table, 
            segment_attributes, 
            deferred_segment_creation, 
        };
      }

physical_properties_2
    = deferred_segment_creation:deferred_segment_creation? _
      rest:(
        external:KW_EXTERNAL _ 
        partiton:KW_PARTITION _ 
        attributes:KW_ATTRIBUTES _ 
        external_table:external_table_clause _ 
        reject_limit:(KW_REJECT _ KW_LIMIT { return 'reject limit'; })? {
          return { external_partition: { reject_limit, external, partition, attributes, external_table } };
        } /
        organization:(KW_ORGANIZATION _ o:physical_properties_organization { return o; }) {
            return { organization };
        }
      ) {
        return { deferred_segment_creation, ...rest }; 
      }

physical_properties_organization
    = option:KW_EXTERNAL _ external_table:external_table_clause { 
        return { option, external_table }; 
      }
    / option:KW_HEAP _ segment_attributes:segment_attributes_clause? _ heap_org:heap_org_table_clause { 
        return { option, segment_attributes, heap_org }; 
      }
    / option:KW_INDEX _ segment_attributes:segment_attributes_clause? _ index_org:index_org_table_clause { 
        return { option, segment_attributes, index_org }; 
      }

index_org_table_clause
    = options:(_ x:index_org_table_option _ { return x; })* _
      overflow:index_org_overflow_clause? {
        return { options, overflow };
      }

index_org_overflow_clause
    = including:(KW_INCLUDING _ column:identifier_name { return column; })? _ KW_OVERFLOW _ 
      segment_attributes:segment_attributes_clause? {
        return { including, segment_attributes };
      }

index_org_table_option
    = mapping_table_clause
    / prefix_compression
    / pctthreshold:KW_PCTTHRESHOLD _ value:integer { return { pctthreshold, value }; }

prefix_compression
    = compress:KW_COMPRESS _ value:integer { return { compress, value }; }
    / compress:KW_NOCOMPRESS { return { compress }; }

mapping_table_clause
    = mapping:KW_MAPPING _ table:KW_TABLE { return { mapping, table }; }
    / mapping:KW_NOMAPPING { return { mapping }; }

heap_org_table_clause
    = table_compression:table_compression? _
      inmemory_table:inmemory_table_clause? _
      ilm:ilm_clause? _ {
        return { 
            ilm,
            inmemory_table,
            table_compression, 
        };
      }

// TODO: check ident-name here after adding quotes
external_table_clause
    = LPAR _ 
      type:(KW_TYPE _ access_driver_type:identifier_name {
        if(validAccessDrivers[access_driver_type.toUpperCase()] !== true) {
            throw new Error(`${access_driver_type} is not a valid access driver`);
        }
        return { access_driver_type }; 
      })? _
      data_props:external_table_data_props? _ RPAR _ 
      reject_limit:(KW_REJECT _ KW_LIMIT _ opt:(KW_UNLIMITED / integer) { return opt; })? _ 
      inmemory_table:inmemory_table_clause? _ {
        return { type, data_props, reject_limit, inmemory_table };
      }

external_table_data_props
    = default_directory:(KW_DEFAULT _ KW_DIRECTORY _ dir:identifier_name { return dir; })? _
      access_parameters:(KW_ACCESS _ KW_PARAMETERS _ param:external_table_data_prop_access_param { return param; })? _
      location:(KW_LOCATION _ LPAR _ dirs:external_table_data_prop_dirs _ RPAR { return dirs; })? _ {
        return { default_directory, access_parameters, location };
      }

external_table_data_prop_dirs
    = x:external_table_data_prop_dir 
      xs:( _ COMMA _ e:external_table_data_prop_dir { return e; })* {
        return [x, ...xs];
    }

external_table_data_prop_dir
    = directory:(d:identifier_name _ COLON _ { return d; })? _ SQUO _ location_specifier:any _ SQUO {
        return { directory, location_specifier };
    }

external_table_data_prop_access_param
    = LPAR _ SQUO _ spec:'opaque_format_spec' _ SQUO _ RPAR { return { spec }; }
    / LPAR _ spec:'opaque_format_spec' _ RPAR { return { spec }; }
    / KW_USING _ clob:KW_CLOB _ subquery:subquery { return { using: clob, subquery }; }

physical_properties_3
    = KW_CLUSTER _ cluster:identifier_name _ LPAR _ columns:comma_separated_identifiers _ RPAR {
        return { cluster, columns };
    }

ilm_clause
    = KW_ILM _ 
      body:(
        action:KW_ADD _ resource:KW_POLICY _ policy:ilm_policy_clause { return { action, resource, policy }; } /
        action:(KW_DELETE / KW_DISABLE / KW_ENABLE) _ KW_POLICY _ policy_name:identifier_name { return { action, policy_name }; } /
        action:(KW_DELETE_ALL / KW_ENABLE_ALL / KW_DISABLE_ALL) { return { action }; }
      ) { 
        return body; 
      }

ilm_policy_clause
    = ilm_compression_policy
    / ilm_tiering_policy
    / ilm_inmemory_policy

ilm_inmemory_policy
    = inmemory_action:(
        action:KW_SET _ KW_INMEMORY _ attributes:inmemory_attributes? { return { action, attributes };} /
        action:KW_MODIFY _ KW_INMEMORY _ memcompress:inmemory_memcompress { return { action, memcompress }; } /
        action:KW_NO _ KW_INMEMORY { return { action }; }
      ) _ 
      target:KW_SEGMENT? _ 
      when:(
        on:KW_ON _ function_name:identifier_name { return { on, function_name }; } /
        after:KW_AFTER _ 
        period:ilm_time_period _ KW_OF _ 
        action:(KW_NO _ KW_ACCESS { return 'no access'; } / KW_NO _ KW_MODIFICATION { return 'no modification'; } / KW_CREATION) {
            return { after, period, action };
        }
      ) {
        return { policy_type: 'inmemory', target, when, ...inmemory_action };
      }

ilm_tiering_policy
    = KW_TIER _ KW_TO _
      tablespace:identifier_name _ 
      body:(
        KW_READ _ KW_ONLY _ 
        target:(KW_SEGMENT / KW_GROUP)? _
        when:(
            on:KW_ON _ function_name:identifier_name { return { on, function_name }; } /
            after:KW_AFTER _ 
            period:ilm_time_period _ KW_OF _ 
            action:(KW_NO _ KW_ACCESS { return 'no access'; } / KW_NO _ KW_MODIFICATION { return 'no modification'; } / KW_CREATION) {
                return { after, period, action };
            }
        )? {
            return { read_only: 'read only', target, when };
        } /
        target:(KW_SEGMENT / KW_GROUP)? _ 
        when:(on:KW_ON _ function_name:identifier_name { return { on, function_name }; })? {
            return { target, when };
        }
      ) {
        return { tablespace, ...body, policy_type: 'tiering' };
      }

ilm_compression_policy
    = compression:table_compression _ 
      target:(KW_SEGMENT / KW_GROUP) _ 
      when:(
        on:KW_ON _ function_name:identifier_name { return { on, function_name }; } /
        after:KW_AFTER _ 
        period:ilm_time_period _ KW_OF _ 
        action:(KW_NO _ KW_ACCESS { return 'no access'; } / KW_NO _ KW_MODIFICATION { return 'no modification'; } / KW_CREATION) {
            return { after, period, action };
        }
      ) { 
        return { compression, target, when, policy_type: 'compression' }; 
      } /
      compress:(
        store:KW_ROW _ KW_STORE _ KW_COMPRESS _ level:KW_ADVANCED { return { store, level }; } /
        store:KW_COLUMN _ KW_STORE _ KW_COMPRESS _ KW_FOR _ KW_QUERY { return { store, for_query: 'for query' }; }
      ) _ target:KW_ROW _ KW_AFTER _ period:ilm_time_period _ KW_OF _ KW_NO _ KW_MODIFICATION {
        return { compress, target, period, action: 'no modification', policy_type: 'compression' };
      }

ilm_time_period
    = value:integer _ unit:(KW_DAY / KW_DAYS / KW_MONTH / KW_MONTHS / KW_YEAR / KW_YEARS) {
        return { value, unit };
    }

inmemory_table_clause
    = inmemory:(
        setting:KW_INMEMORY _ attributes:inmemory_attributes? { return { setting, attributes }; } /
        KW_NO _ KW_INMEMORY { return { setting: 'no inmemory' }; }
      )? _
      column:inmemory_column_clause? _  {
        return { inmemory, column };
      }

inmemory_column_clause
    = x:(_ c:inmemory_column_def { return c; })+ { return x; } 

inmemory_column_def
    = inmemory:(
        setting:KW_INMEMORY _ memcompress:inmemory_memcompress? { return { setting, memcompress }; } /
        KW_NO _ KW_INMEMORY { return { setting: 'no inmemory' }; }
      ) _ LPAR _ 
      columns:comma_separated_identifiers _ RPAR {
        return { inmemory, columns };
      }

inmemory_attributes
    = memcompress:inmemory_memcompress? _ 
      priority:inmemory_priority? _
      distribute:inmemory_distribute? _
      duplicate:inmemory_duplicate? _
      spatial:inmemory_spatial? _ {
        return { memcompress, priority, distribute, duplicate, spatial };
      }

inmemory_spatial
    = KW_SPATIAL _ column:identifier_name { return { column }; }

inmemory_duplicate
    = KW_DUPLICATE _ all:KW_ALL? { return `duplicate${ all ? ' all' : '' }`; }
    / KW_NO _ KW_DUPLICATE { return 'no duplicate'; }

inmemory_distribute
    = KW_DISTRIBUTE _ 
      partition:(KW_AUTO / KW_BY _ x:(KW_PARTITION / KW_SUBPARTITION / KW_ROWID _ KW_RANGE { return 'rowid range'; }) { return `by ${x}`;})? _
      for_service:(KW_FOR _ KW_SERVICE _ x:(KW_DEFAULT / KW_ALL / identifier_name / KW_NONE) { return x; })? {
        return { partition, for_service };
      }

inmemory_priority
    = KW_PRIORITY _ priority:(KW_NONE / KW_LOW / KW_MEDIUM / KW_HIGH / KW_CRITICAL) {
        return priority;
    }

inmemory_memcompress
    = KW_NO _ KW_MEMCOMPRESS { return { mode: 'no memcompress' }; }
    / KW_MEMCOMPRESS _ KW_AUTO { return { mode: 'memcompress auto' }; }
    / mode:KW_MEMCOMPRESS _ KW_FOR _  
      compression_target:(
        target:KW_DML { return { target }; } / 
        target:(KW_QUERY / KW_CAPACITY) _ level:(KW_LOW / KW_HIGH)? { return { target, level }; }
      )? {
        return { mode, ...compression_target };
      }

table_compression
    = option:(KW_COMPRESS / KW_NOCOMPRESS) { return { option }; }
    / store:KW_ROW _ KW_STORE _ option:KW_COMPRESS _ level:(KW_BASIC / KW_ADVANCED)? { return { store, option, level }; }
    / store:KW_COLUMN _ KW_STORE _ option:KW_COMPRESS _ 
      target:(KW_FOR _ opt:(KW_QUERY / KW_ARCHIVE) _ level:(KW_LOW / KW_HIGH)? { return { option: opt, level }; })? _ 
      row_level_locking:(no:KW_NO _ KW_ROW _ KW_LEVEL _ KW_LOCKING { return no; })? { 
        return { store, option, for_query, row_level_locking };
      }

segment_attributes_clause
    = xs:(_ s:segment_attribute { return s; })+ {
        return xs;
    }

segment_attribute 
    = KW_TABLESPACE _ KW_SET _ name:identifier_name { return { attribute: 'tablespace set', name }; }
    / KW_TABLESPACE _ name:identifier_name { return { attribute: 'tablespace', name }; }
    / logging:logging_clause { return { attribute: 'logging', logging }; }
    / physical_attributes:physical_attributes_clause { return { attribute: 'physical_attributes', physical_attributes }; }

physical_attributes_clause
    = xs:(_ p:physical_attribute _ { return p; })+ {
        return xs;
    }

physical_attribute
    = param:(KW_PCTFREE / KW_PCTUSED / KW_INITRANS) _ value:integer { return { param, value, attribute: 'param' }; }
    / storage:storage_clause { return { storage, attribute: 'storage' }; }

storage_clause
    = KW_STORAGE _ LPAR _ options:(o:storage_option _ { return o; })+ _ RPAR { 
        return { options }; 
    }

storage_option
    = initial:KW_INITIAL _ size:size_clause { return { initial, size }; }
    / next:KW_NEXT _ size:size_clause { return { next, size }; }
    / pctincrease:KW_PCTINCREASE _ value:integer { return { pctincrease, value }; }
    / minextents:KW_MINEXTENTS _ value:integer { return { minextents, value }; }
    / maxextents:KW_MAXEXTENTS _ value:(integer / KW_UNLIMITED) { return { minextents, value }; }
    / maxsize_clause
    / encrypt:KW_ENCRYPT { return { encrypt }; }
    / cache:(KW_FLASH_CACHE / KW_CELL_FLASH_CACHE) _ option:(KW_KEEP / KW_NONE / KW_DEFAULT) { return { cache, option }; }
    / buffer_pool:KW_BUFFER_POOL _ option:(KW_KEEP / KW_RECYCLE / KW_DEFAULT) { return { buffer_pool, option }; }
    / KW_FREELIST _ KW_GROUPS _ value:integer { return { freelist: 'freelist groups', value }; }
    / KW_FREELISTS _ value:integer { return { freelist: 'freelists', value }; }
    / optimal:KW_OPTIMAL _ size:(size_clause / KW_NULL)? { return {optimal, size}; }

maxsize_clause
    = maxsize:KW_MAXSIZE _ size:(size_clause / KW_UNLIMITED) {
        return { maxsize, size };
    }

size_clause
    = value:integer _ byte:('K' / 'M' / 'G' / 'T' / 'P' / 'E')? {
        return { value, byte };
    }

deferred_segment_creation
    = KW_SEGMENT _ KW_CREATION _ x:(KW_DEFERRED / KW_IMMEDIATE) { return x; }

immutable_table_clauses 
    = no_drop_clause:immutable_table_no_drop_clause? _ 
      no_delete_clause:immutable_table_no_delete_clause? {
        return { no_drop_clause, no_delete_clause };
    }

immutable_table_no_drop_clause 
    = KW_NO _ KW_DROP until_days_idle:(_ KW_UNTIL _ x:integer _ KW_DAYS _ KW_IDLE { return x; })? {
        return { no_drop: 'no drop', until_days_idle }
    }

immutable_table_no_delete_clause
    = KW_NO _ KW_DELETE _ 
      l:(locked:KW_LOCKED { return { locked }; } /
        (_ KW_UNTIL _ x:integer _ KW_DAYS _ KW_AFTER _ KW_INSERT _  locked:KW_LOCKED? { 
            return { until_days_after_insert: x, locked }; 
        })
      )? {
        return { no_delete: 'no delete', ...l }
      }

blockchain_table_clauses
    = drop:blockchain_drop_table_clause _ 
      row_retention:blockchain_row_retention_clause _ 
      hash:blockchain_hash_and_data_format_clause {
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
    = x:relational_property xs:(_ COMMA _ c:relational_property { return c; })* { 
        return [x, ...xs];
    }

relational_property
    = column_definition
    / out_of_line_property
    / period_definition
    / supplemental_logging_props

supplemental_logging_props
    = KW_SUPPLEMENTAL _ KW_LOG _ 
      opts:(
        log_group_prop:supplemental_log_grp_clause { return { log_group_prop }; } /
        id_key_prop:supplemental_id_key_clause { return { id_key_prop }; }
      ) {
        return { resource: 'supplental log', ...opts };
    }

supplemental_id_key_clause
    = KW_DATA _ LPAR _ 
      columns:(
        x:supplemental_id_key_column
        xs:(_ COMMA _ s:supplemental_id_key_column { return s; })* {
            return [x, ...xs];
        }
      ) _ RPAR _ KW_COLUMNS {
        return columns;
    } 

supplemental_id_key_column
    = unique:KW_UNIQUE { return { unique }; }
    /  all:KW_ALL { return { all }; }
    /  KW_PRIMARY _ KW_KEY { return { primary_key: 'primary key' }; }
    /  KW_FOREIGN _ KW_KEY { return { foreign_key: 'foreign key' }; }

supplemental_log_grp_clause
    = KW_GROUP _ 
      log_group:identifier_name _ LPAR _
      columns:(x:supplemental_log_grp_column xs:(_ COMMA _ s:supplemental_log_grp_column { return s; })* { 
        return [x, ...xs]; 
      }) _ RPAR _
      always:KW_ALWAYS? {
        return { log_group, columns, always };
    }

supplemental_log_grp_column
    = column:identifier_name _ no_log:(KW_NO _ KW_LOG { return 'no log'; })? {
        return { column, no_log };
    }

period_definition
    = KW_PERIOD _ KW_FOR _ 
      time_column:identifier_name _ 
      range:(LPAR _ start_time_column:identifier_name _ COMMA _ end_time_column:identifier_name _ RPAR { 
        return { start_time_column, end_time_column }; 
      })? {
        return { resource: 'period', time_column, ...range };
      }

out_of_line_property
    = out_of_line_constraint
    / x:out_of_line_ref_constraint { return {...x, resource: 'ref_constraint',}}

out_of_line_ref_constraint
    = (scope:KW_SCOPE _ KW_FOR _ LPAR _ 
       column:identifier_name _ RPAR _ KW_IS _ 
       schema:(s:identifier_name _ DOT _ { return s; })? 
       name:identifier_name {
        return { scope, schema, name, column }; 
      }) /
      (ref:KW_REF _ LPAR _
       column:identifier_name _ RPAR _ 
       w:KW_WITH _ rowid:KW_ROWID { 
        return { with: w, rowid, column }; 
      }) /
      (name:(KW_CONSTRAINT _ n:identifier_name { return n; })? _ 
       KW_FOREIGN _ KW_KEY _ LPAR _
       columns:comma_separated_identifiers _ RPAR _
       reference:references_clause _ 
       state:constraint_state? { 
        return { 
            name, 
            state,
            columns,
            reference, 
            foreign_key: 'foreign key'
        }; 
      })

out_of_line_constraint
    = name:(KW_CONSTRAINT _ n:identifier_name { return n; })? _ 
      constraint:(
        (unique:KW_UNIQUE _ LPAR _ columns:comma_separated_identifiers _ RPAR { 
            return { unique, columns };
        }) /
        (KW_PRIMARY _ KW_KEY _ LPAR _ columns:comma_separated_identifiers _ RPAR { 
            return { primary_key: 'primary key', columns }; 
        }) /
        (KW_FOREIGN _ KW_KEY _ LPAR _ columns:comma_separated_identifiers _ RPAR _ reference:references_clause { 
            return { primary_key: 'primary key', columns, reference }; 
        }) /
        (KW_CHECK _ LPAR _ condition:condition _ RPAR { return { check: condition }; })
      ) _ 
      state:constraint_state? {
      return {
        name, 
        state,
        constraint, 
        resource: 'constraint', 
      };
    }

column_definition
    = name:identifier_name _ 
      type:data_type _ 
      collate:(KW_COLLATE _ n:identifier_name { return n; })? _
      sort:KW_SORT? _ 
      visibility:(KW_VISIBLE / KW_INVISIBLE)? _
      default_or_identity:(column_default_clause / identity_clause)? _
      encrypt:(e:KW_ENCRYPT _ spec:encryption_spec? { return { encrypt: e, spec}; })? _
      constraints:column_constraints? _ { 
        return { 
            name,
            type,
            sort,
            encrypt,
            collate,
            visibility,
            constraints,
            resource: 'column',
            ...default_or_identity,
        }; 
      }

column_constraints
    = x:inline_ref_constraint { return [{...x, resource: 'ref_constraint'}]; } 
    / inline_constraints

inline_ref_constraint
    = (scope:KW_SCOPE _ KW_IS _ 
       schema:(s:identifier_name _ DOT _ { return s; })? 
       name:identifier_name {
        return { scope, schema, name }; 
      }) /
      (w:KW_WITH _ 
       rowid:KW_ROWID {
        return { with: w, rowid }; 
      }) /
      (name:(KW_CONSTRAINT _ n:identifier_name { return n; })? _ 
       reference:references_clause _ 
       state:constraint_state? {
        return { name, reference, state }; 
      })

inline_constraints
    = clauses:(_ c:inline_constraint { return c; })* {
      return clauses;
    }

inline_constraint
    = name:(KW_CONSTRAINT _ n:identifier_name { return n; })? _ 
      constraint:(
        (not:KW_NOT? _ KW_NULL { return { not_null: not ? 'not null' : 'null' }; }) /
        (unique:KW_UNIQUE { return { unique }; }) /
        (KW_PRIMARY _ KW_KEY { return { primary_key: 'primary key' }; }) /
        (KW_CHECK _ LPAR _ condition:condition _ RPAR { return { check: condition }; }) /
        references_clause
      ) _ 
      state:constraint_state? {
      return { resource: 'constraint', name, constraint, state };
    }

constraint_state 
    = start:(
        deferrable:deferrable_clause _ initially:initially_clause? { return { deferrable, initially }; } /
        initially:initially_clause _ deferrable:deferrable_clause? { return { deferrable, initially }; }
      ) _ 
      rely:(KW_RELY / KW_NORELY)? _ 
      using_index:using_index_clause? _ 
      enable:(KW_ENABLE / KW_DISABLE)? _
      validate:(KW_VALIDATE / KW_NOVALIDATE)? _
      exception:exception_clause? {
        return { ...start, rely, enable, using_index, validate, exception };
      }

exception_clause
    = KW_EXCEPTIONS _ KW_INTO _ schema:(s:identifier_name _ DOT _ { return s; })? name:identifier_name {
        return { table: { schema, name } };
    }

// TODO:
using_index_clause
    = ""

deferrable_clause
    = not:KW_NOT? _ d:KW_DEFERRABLE { return `${not ? 'not ':''}${d}`; }

initially_clause
    = initially:KW_INITIALLY _ state:(KW_DEFERRED / KW_IMMEDIATE) { return state; }

references_clause
    = KW_REFERENCES _ 
      object:(schema:(s:identifier_name _ DOT _ { return s; })? _ name:identifier_name { return { schema, name }; }) _
      columns:(LPAR _ c:comma_separated_identifiers _ RPAR { return c; })? _
      on_delete:(KW_ON _ KW_DELETE _ x:(KW_CASCADE / KW_SET _ KW_NULL { return 'set null'; }) { return x; })? {
        return { type: 'reference', object, columns, on_delete };
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
        return { 
            salt,
            algorithm, 
            integrity_algorith, 
            identified_by_password, 
        };
      }

column_default_clause
    = KW_DEFAULT _ on_null:(KW_ON _ KW_NULL { return 'on null'; })? _ expr:expr {
        return { default: { on_null, expr } };
    }

identity_clause
    = generated:KW_GENERATED _ 
      when:(
        KW_ALWAYS { return { always }; } /
        KW_BY _ def:KW_DEFAULT on_null:(KW_ON _ KW_NULL { return 'on null'; })? { return { default: def, on_null }; }
      )? _ 
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
    = KW_START _ KW_WITH _ value:(integer / KW_LIMIT _ KW_VALUE { return 'limit value'; }) { 
        return { start_with: value }; 
    }

data_type
    = ansi_supported_data_type
    / oracle_supplied_type
    / oracle_built_in_data_type
//    / user_defined_type TODO:

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

logging_clause
    = KW_LOGGING 
    / KW_NOLOGGING 
    / KW_FILESYSTEM_LIKE_LOGGING

object_table = ""

XMLType_table = ""

// TODO:
literal
    = ""

// TODO:
subquery = ""

// TODO:
expr = integer

// TODO:
condition = ""

comma_separated_identifiers
    = x:identifier_name xs:(_ COMMA _ c:identifier_name { return c; })* { return [x, ...xs]; }

integer
    = digits:[0-9]+ { return digits.join("");}

single_quoted_str
    = SQUO s:any { return s; }

any 
    = chars:[^']+ { return chars.join(''); }

identifier_name
    = name:ident_name {
        if(reservedKeywords[name.toUpperCase()] === true) {
            throw new Error(`${name} is a reserved keyword`);
        }
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
COLON          = ':'

KW_CREATE                   = 'create'i                  !ident_start { return 'create'; }
KW_TABLE                    = 'table'i                   !ident_start { return 'table'; }
KW_GLOBAL                   = 'global'i                  !ident_start { return 'global'; }
KW_PRIVATE                  = 'private'i                 !ident_start { return 'private'; }
KW_TEMPORARY                = 'temporary'i               !ident_start { return 'temporary'; }
KW_SHARED                   = 'shared'i                  !ident_start { return 'shared'; }
KW_DUPLICATED               = 'duplicated'i              !ident_start { return 'duplicated'; }
KW_IMMUTABLE                = 'immutable'i               !ident_start { return 'immutable'; }
KW_BLOCKCHAIN               = 'blockchain'i              !ident_start { return 'blockchain'; }
KW_SHARING                  = 'sharing'i                 !ident_start { return 'sharing'; }
KW_METADATA                 = 'metadata'i                !ident_start { return 'metadata'; }
KW_DATA                     = 'data'i                    !ident_start { return 'data'; }
KW_EXTENDED                 = 'extended'i                !ident_start { return 'extended'; }
KW_NONE                     = 'none'i                    !ident_start { return 'none'; }
KW_MEMOPTIMIZE              = 'memoptimize'i             !ident_start { return 'memoptimize'; }
KW_FOR                      = 'for'i                     !ident_start { return 'for'; }
KW_READ                     = 'read'i                    !ident_start { return 'read'; }
KW_WRITE                    = 'write'i                   !ident_start { return 'write'; }
KW_PARENT                   = 'parent'i                  !ident_start { return 'parent'; }
KW_NO                       = 'no'i                      !ident_start { return 'no'; }
KW_ON                       = 'on'i                      !ident_start { return 'on'; }
KW_NOT                      = 'not'i                     !ident_start { return 'not'; }
KW_INTO                     = 'into'i                    !ident_start { return 'into'; }
KW_DROP                     = 'drop'i                    !ident_start { return 'drop'; }
KW_DELETE                   = 'delete'i                  !ident_start { return 'delete'; }
KW_UNTIL                    = 'until'i                   !ident_start { return 'until'; }
KW_DAYS                     = 'days'i                    !ident_start { return 'days'; }
KW_IDLE                     = 'idle'i                    !ident_start { return 'idle'; }
KW_LOCKED                   = 'locked'i                  !ident_start { return 'locked'; }
KW_AFTER                    = 'after'i                   !ident_start { return 'after'; }
KW_INSERT                   = 'insert'i                  !ident_start { return 'insert'; }
KW_HASHING                  = 'hashing'i                 !ident_start { return 'hashing'; }
KW_USING                    = 'using'i                   !ident_start { return 'using'; }
KW_VERSION                  = 'version'i                 !ident_start { return 'version'; }
KW_DEFAULT                  = 'default'i                 !ident_start { return 'default'; }
KW_COLLATION                = 'collation'i               !ident_start { return 'collation'; }
KW_COLLATE                  = 'collate'i                 !ident_start { return 'collate'; }
KW_COMMIT                   = 'commit'i                  !ident_start { return 'commit'; }
KW_PRESERVE                 = 'preserve'i                !ident_start { return 'preserve'; }
KW_DEFINITION               = 'definition'i              !ident_start { return 'definition'; }
KW_ROWS                     = 'rows'i                    !ident_start { return 'rows'; }
KW_SORT                     = 'sort'i                    !ident_start { return 'sort'; }
KW_VISIBLE                  = 'visible'i                 !ident_start { return 'visible'; }
KW_INVISIBLE                = 'invisible'i               !ident_start { return 'invisible'; }
KW_NULL                     = 'null'i                    !ident_start { return 'null'; }
KW_GENERATED                = 'generated'i               !ident_start { return 'generated'; }
KW_ALWAYS                   = 'always'i                  !ident_start { return 'always'; }
KW_BY                       = 'by'i                      !ident_start { return 'by'; }
KW_AS                       = 'as'i                      !ident_start { return 'as'; }
KW_IS                       = 'is'i                      !ident_start { return 'is'; }
KW_OF                       = 'of'i                      !ident_start { return 'of'; }
KW_TO                       = 'to'i                      !ident_start { return 'to'; }
KW_IDENTITY                 = 'identity'i                !ident_start { return 'identity'; }
KW_START                    = 'start'i                   !ident_start { return 'start'; }
KW_WITH                     = 'with'i                    !ident_start { return 'with'; }
KW_SALT                     = 'salt'i                    !ident_start { return 'salt'; }
KW_LIMIT                    = 'limit'i                   !ident_start { return 'limit'; }
KW_VALUE                    = 'value'i                   !ident_start { return 'value'; }
KW_INCREMENT                = 'increment'i               !ident_start { return 'increment'; }
KW_MAXVALUE                 = 'maxvalue'i                !ident_start { return 'maxvalue'; }
KW_NOMAXVALUE               = 'nomaxvalue'i              !ident_start { return 'nomaxvalue'; }
KW_MINVALUE                 = 'minvalue'i                !ident_start { return 'minvalue'; }
KW_NOMINVALUE               = 'nominvalue'i              !ident_start { return 'nominvalue'; }
KW_CYCLE                    = 'cycle'i                   !ident_start { return 'cycle'; }
KW_NOCYCLE                  = 'nocycle'i                 !ident_start { return 'nocycle'; }
KW_CACHE                    = 'cache'i                   !ident_start { return 'cache'; }
KW_NOCACHE                  = 'nocache'i                 !ident_start { return 'nocache'; }
KW_ORDER                    = 'order'i                   !ident_start { return 'order'; }
KW_NOORDER                  = 'noorder'i                 !ident_start { return 'noorder'; }
KW_ENCRYPT                  = 'encrypt'i                 !ident_start { return 'encrypt'; }
KW_IDENTIFIED               = 'identified'i              !ident_start { return 'identified'; }
KW_CONSTRAINT               = 'constraint'i              !ident_start { return 'constraint'; }
KW_UNIQUE                   = 'unique'i                  !ident_start { return 'unique'; }
KW_PRIMARY                  = 'primary'i                 !ident_start { return 'primary'; }
KW_KEY                      = 'key'i                     !ident_start { return 'key'; }
KW_CHECK                    = 'check'i                   !ident_start { return 'check'; }
KW_REFERENCES               = 'references'i              !ident_start { return 'references'; }
KW_CASCADE                  = 'cascade'i                 !ident_start { return 'cascade'; }
KW_SET                      = 'set'i                     !ident_start { return 'set'; }
KW_REF                      = 'ref'i                     !ident_start { return 'ref'; }
KW_RELY                     = 'rely'i                    !ident_start { return 'rely'; }
KW_NORELY                   = 'norely'i                  !ident_start { return 'norely'; }
KW_DEFERRABLE               = 'deferrable'i              !ident_start { return 'deferrable'; }
KW_DEFERRED                 = 'deferred'i                !ident_start { return 'deferred'; }
KW_INITIALLY                = 'initially'i               !ident_start { return 'initially'; }
KW_IMMEDIATE                = 'immediate'i               !ident_start { return 'immediate'; }
KW_ENABLE                   = 'enable'i                  !ident_start { return 'enable'; }
KW_DISABLE                  = 'disable'i                 !ident_start { return 'disable'; }
KW_VALIDATE                 = 'validate'i                !ident_start { return 'validate'; }
KW_NOVALIDATE               = 'novalidate'i              !ident_start { return 'novalidate'; }
KW_EXCEPTIONS               = 'exceptions'i              !ident_start { return 'exceptions'; }
KW_SCOPE                    = 'scope'i                   !ident_start { return 'scope'; }
KW_FOREIGN                  = 'foreign'i                 !ident_start { return 'foreign'; }
KW_SEGMENT                  = 'segment'i                 !ident_start { return 'segment'; }
KW_CREATION                 = 'creation'i                !ident_start { return 'creation'; }
KW_TABLESPACE               = 'tablespace'i              !ident_start { return 'tablespace'; }
KW_LOGGING                  = 'logging'i                 !ident_start { return 'logging'; }
KW_NOLOGGING                = 'nologging'i               !ident_start { return 'nologging'; }
KW_FILESYSTEM_LIKE_LOGGING  = 'filesystem_like_logging'i !ident_start { return 'filesystem_like_logging'; }
KW_PCTFREE                  = 'pctfree'i                 !ident_start { return 'pctfree'; }
KW_PCTUSED                  = 'pctused'i                 !ident_start { return 'pctused'; }
KW_INITRANS                 = 'initrans'i                !ident_start { return 'initrans'; }
KW_STORAGE                  = 'storage'i                 !ident_start { return 'storage'; }
KW_INITIAL                  = 'initial'i                 !ident_start { return 'initial'; }
KW_NEXT                     = 'next'i                    !ident_start { return 'next'; }
KW_MINEXTENTS               = 'minextents'i              !ident_start { return 'minextents'; }
KW_MAXEXTENTS               = 'maxextents'i              !ident_start { return 'maxextents'; }
KW_UNLIMITED                = 'unlimited'i               !ident_start { return 'unlimited'; }
KW_MAXSIZE                  = 'maxsize'i                 !ident_start { return 'maxsize'; }
KW_KEEP                     = 'keep'i                    !ident_start { return 'keep'; }
KW_RECYCLE                  = 'recycle'i                 !ident_start { return 'recycle'; }
KW_OPTIMAL                  = 'optimal'i                 !ident_start { return 'optimal'; }
KW_PCTINCREASE              = 'pctincrease'i             !ident_start { return 'pctincrease'; }
KW_FREELISTS                = 'freelists'i               !ident_start { return 'freelists'; }
KW_FREELIST                 = 'freelist'i                !ident_start { return 'freelist'; }
KW_GROUPS                   = 'groups'i                  !ident_start { return 'groups'; }
KW_BUFFER_POOL              = 'buffer_pool'i             !ident_start { return 'buffer_pool'; }
KW_FLASH_CACHE              = 'flash_cache'i             !ident_start { return 'flash_cache'; }
KW_CELL_FLASH_CACHE         = 'cell_flash_cache'i        !ident_start { return 'cell_flash_cache'; }
KW_COMPRESS                 = 'compress'i                !ident_start { return 'compress'; }
KW_ROW                      = 'row'i                     !ident_start { return 'row'; }
KW_STORE                    = 'store'i                   !ident_start { return 'store'; }
KW_BASIC                    = 'basic'i                   !ident_start { return 'basic'; }
KW_ADVANCED                 = 'advanced'i                !ident_start { return 'advanced'; }
KW_COLUMN                   = 'column'i                  !ident_start { return 'column'; }
KW_QUERY                    = 'query'i                   !ident_start { return 'query'; }
KW_ARCHIVE                  = 'archive'i                 !ident_start { return 'archive'; }
KW_LOW                      = 'low'i                     !ident_start { return 'low'; }
KW_HIGH                     = 'high'i                    !ident_start { return 'high'; }
KW_ROW_LEVEL_LOCKING        = 'row level locking'i       !ident_start { return 'row level locking'; }
KW_NOCOMPRESS               = 'nocompress'i              !ident_start { return 'nocompress'; }
KW_LEVEL                    = 'level'i                   !ident_start { return 'level'; }
KW_LOCKING                  = 'locking'i                 !ident_start { return 'locking'; }
KW_INMEMORY                 = 'inmemory'i                !ident_start { return 'inmemory'; }
KW_MEMCOMPRESS              = 'memcompress'i             !ident_start { return 'memcompress'; }
KW_DML                      = 'dml'i                     !ident_start { return 'dml'; }
KW_CAPACITY                 = 'capacity'i                !ident_start { return 'capacity'; }
KW_AUTO                     = 'auto'i                    !ident_start { return 'auto'; }
KW_PRIORITY                 = 'priority'i                !ident_start { return 'priority'; }
KW_MEDIUM                   = 'medium'i                  !ident_start { return 'medium'; }
KW_CRITICAL                 = 'critical'i                !ident_start { return 'critical'; }
KW_DISTRIBUTE               = 'distribute'i              !ident_start { return 'distribute'; }
KW_RANGE                    = 'range'i                   !ident_start { return 'range'; }
KW_PARTITION                = 'partition'i               !ident_start { return 'partition'; }
KW_SUBPARTITION             = 'subpartition'i            !ident_start { return 'subpartition'; }
KW_SERVICE                  = 'service'i                 !ident_start { return 'service'; }
KW_ALL                      = 'all'i                     !ident_start { return 'all'; }
KW_DUPLICATE                = 'duplicate'i               !ident_start { return 'duplicate'; }
KW_SPATIAL                  = 'spatial'i                 !ident_start { return 'spatial'; }
KW_ILM                      = 'ilm'i                     !ident_start { return 'ilm'; }
KW_ADD                      = 'add'i                     !ident_start { return 'add'; }
KW_POLICY                   = 'policy'i                  !ident_start { return 'policy'; }
KW_DISABLE_ALL              = 'disable_all'i             !ident_start { return 'disable_all'; }
KW_DELETE_ALL               = 'delete_all'i              !ident_start { return 'delete_all'; }
KW_ENABLE_ALL               = 'enable_all'i              !ident_start { return 'enable_all'; }
KW_GROUP                    = 'group'i                   !ident_start { return 'group'; }
KW_ACCESS                   = 'access'i                  !ident_start { return 'access'; }
KW_MODIFICATION             = 'modification'i            !ident_start { return 'modification'; }
KW_DAY                      = 'day'i                     !ident_start { return 'day'; }
KW_MONTH                    = 'month'i                   !ident_start { return 'month'; }
KW_MONTHS                   = 'months'i                  !ident_start { return 'months'; }
KW_YEAR                     = 'year'i                    !ident_start { return 'year'; }
KW_YEARS                    = 'years'i                   !ident_start { return 'years'; }
KW_TIER                     = 'tier'i                    !ident_start { return 'tier'; }
KW_ONLY                     = 'only'i                    !ident_start { return 'only'; }
KW_MODIFY                   = 'modify'i                  !ident_start { return 'modify'; }
KW_CLUSTER                  = 'cluster'i                 !ident_start { return 'cluster'; }
KW_INDEX                    = 'index'i                   !ident_start { return 'index'; }
KW_EXTERNAL                 = 'external'i                !ident_start { return 'external'; }
KW_REJECT                   = 'reject'i                  !ident_start { return 'reject'; }
KW_ATTRIBUTES               = 'attributes'i              !ident_start { return 'attributes'; }
KW_TYPE                     = 'type'i                    !ident_start { return 'type'; }
KW_DIRECTORY                = 'directory'i               !ident_start { return 'directory'; }
KW_LOCATION                 = 'location'i                !ident_start { return 'location'; }
KW_CLOB                     = 'clob'i                    !ident_start { return 'clob'; }
KW_HEAP                     = 'heap'i                    !ident_start { return 'heap'; }
KW_PARAMETERS               = 'parameters'i              !ident_start { return 'parameters'; }
KW_ORGANIZATION             = 'organization'i            !ident_start { return 'organization'; }
KW_MAPPING                  = 'mapping'i                 !ident_start { return 'mapping'; }
KW_NOMAPPING                = 'nomapping'i               !ident_start { return 'nomapping'; }
KW_PCTTHRESHOLD             = 'pctthreshold'i            !ident_start { return 'pctthreshold'; }
KW_INCLUDING                = 'including'i               !ident_start { return 'including'; }
KW_OVERFLOW                 = 'overflow'i                !ident_start { return 'overflow'; }
KW_PERIOD                   = 'period'i                  !ident_start { return 'period'; }
KW_SUPPLEMENTAL             = 'supplemental'i            !ident_start { return 'supplemental'; }
KW_LOG                      = 'log'i                     !ident_start { return 'log'; }
KW_COLUMNS                  = 'columns'i                 !ident_start { return 'columns'; }
KW_SUBSTITUTABLE            = 'substitutable'i           !ident_start { return 'substitutable'; }
KW_ELEMENT                  = 'element'i                 !ident_start { return 'element'; }
KW_LEVELS                   = 'levels'i                  !ident_start { return 'levels'; }
KW_AT                       = 'at'i                      !ident_start { return 'at'; }
KW_NESTED                   = 'nested'i                  !ident_start { return 'nested'; }
KW_RETURN                   = 'return'i                  !ident_start { return 'return'; }
KW_LOCATOR                  = 'locator'i                 !ident_start { return 'locator'; }
KW_LOCAL                    = 'local'i                   !ident_start { return 'local'; }
KW_RETENTION                = 'retention'i               !ident_start { return 'retention'; }
KW_CHUNK                    = 'chunk'i                   !ident_start { return 'chunk'; }
KW_PCTVERSION               = 'pctversion'i              !ident_start { return 'pctversion'; }
KW_FREEPOOLS                = 'freepools'i               !ident_start { return 'freepools'; }
KW_VARRAY                   = 'varray'i                  !ident_start { return 'varray'; }
KW_SECUREFILE               = 'securefile'i              !ident_start { return 'securefile'; }
KW_BASICFILE                = 'basicfile'i               !ident_start { return 'basicfile'; }
KW_LOB                      = 'lob'i                     !ident_start { return 'lob'; }
KW_IN                       = 'in'i                      !ident_start { return 'in'; }
KW_DECRYPT                  = 'decrypt'i                 !ident_start { return 'decrypt'; }
KW_READS                    = 'reads'i                   !ident_start { return 'reads'; }
KW_DEDUPLICATE              = 'deduplicate'i             !ident_start { return 'deduplicate'; }
KW_KEEP_DUPLICATES          = 'keep_duplicates'i         !ident_start { return 'keep_duplicates'; }
KW_MAX                      = 'max'i                     !ident_start { return 'max'; }
KW_MIN                      = 'min'i                     !ident_start { return 'min'; }
KW_OFF                      = 'off'i                     !ident_start { return 'off'; }
KW_INDEXING                 = 'indexing'i                !ident_start { return 'indexing'; }
KW_INTERVAL                 = 'interval'i                !ident_start { return 'interval'; }
KW_VALUES                   = 'values'i                  !ident_start { return 'values'; }
KW_LESS                     = 'less'i                    !ident_start { return 'less'; }
KW_THAN                     = 'than'i                    !ident_start { return 'than'; }
KW_INTERNAL                 = 'internal'i                !ident_start { return 'internal'; }
KW_SYSTEM                   = 'system'i                  !ident_start { return 'system'; }
KW_PARTITIONS               = 'partitions'i              !ident_start { return 'partitions'; }
KW_REFERENCE                = 'reference'i               !ident_start { return 'reference'; }
KW_LIST                     = 'list'i                    !ident_start { return 'list'; }
KW_AUTOMATIC                = 'automatic'i               !ident_start { return 'automatic'; }
KW_HASH                     = 'hash'i                    !ident_start { return 'hash'; }
KW_TEMPLATE                 = 'template'i                !ident_start { return 'template'; }
KW_SUBPARTITIONS            = 'subpartitions'i           !ident_start { return 'subpartitions'; }
KW_CONSISTENT               = 'consistent'i              !ident_start { return 'consistent'; }
KW_PARTITIONSET             = 'partitionset'i            !ident_start { return 'partitionset'; }
KW_NOPARALLEL               = 'noparallel'i              !ident_start { return 'noparallel'; }
KW_PARALLEL                 = 'parallel'i                !ident_start { return 'parallel'; }
KW_ROWDEPENDENCIES          = 'rowdependencies'i         !ident_start { return 'rowdependencies'; }
KW_NOROWDEPENDENCIES        = 'norowdependencies'i       !ident_start { return 'norowdependencies'; }
KW_MOVEMENT                 = 'movement'i                !ident_start { return 'movement'; }
KW_LOGICAL                  = 'logical'i                 !ident_start { return 'logical'; }
KW_REPLICATION              = 'replication'i             !ident_start { return 'replication'; }
KW_ALLOW                    = 'allow'i                   !ident_start { return 'allow'; }
KW_KEYS                     = 'keys'i                    !ident_start { return 'keys'; }
KW_FLASHBACK                = 'flashback'i               !ident_start { return 'flashback'; }
KW_ARCHIVAL                 = 'archival'i                !ident_start { return 'archival'; }
KW_EXCHANGE                 = 'exchange'i                !ident_start { return 'exchange'; }
KW_RESULT_CACHE             = 'result_cache'i            !ident_start { return 'result_cache'; }
KW_MODE                     = 'mode'i                    !ident_start { return 'mode'; }
KW_FORCE                    = 'force'i                   !ident_start { return 'force'; }
KW_STANDBY                  = 'standby'i                 !ident_start { return 'standby'; }
KW_CLUSTERING               = 'clustering'i              !ident_start { return 'clustering'; }
KW_JOIN                     = 'join'i                    !ident_start { return 'join'; }
KW_LINEAR                   = 'linear'i                  !ident_start { return 'linear'; }
KW_INTERLEAVED              = 'interleaved'i             !ident_start { return 'interleaved'; }
KW_YES                      = 'yes'i                     !ident_start { return 'yes'; }
KW_LOAD                     = 'load'i                    !ident_start { return 'load'; }
KW_MATERIALIZED             = 'materialized'i            !ident_start { return 'materialized'; }
KW_ZONEMAP                  = 'zonemap'i                 !ident_start { return 'zonemap'; }
KW_WITHOUT                  = 'without'i                 !ident_start { return 'without'; }

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
KW_ROWID       = 'rowid'i       !ident_start { return 'rowid'; }
KW_VARCHAR2    = 'varchar2'i    !ident_start { return 'varchar2'; }
KW_JSON        = 'json'i        !ident_start { return 'json'; }