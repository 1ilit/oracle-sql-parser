const { parse } = require("../parser/parser");

const src = `create table hi.users(
    id rowid
) tablespace set hi storage (buffer_pool keep next 20K) pctfree 20 logging;`;

console.log(JSON.stringify(parse(src), null, 2));