const { parse } = require("../parser/parser");

const src = `create table hi.users(
    id rowid
) tablespace set hi pctfree 20 logging column store compress for query high no row level locking;`;

console.log(JSON.stringify(parse(src), null, 2));