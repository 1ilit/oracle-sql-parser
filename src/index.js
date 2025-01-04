const { parse } = require("../parser/parser");

const src = `create table hi.users(
    id rowid
) tablespace set hi inmemory memcompress for capacity low priority high distribute auto for service me no duplicate spatial id inmemory memcompress for capacity low (buni, pl) ilm add policy set inmemory no memcompress segment after 10 days of no modification;`;

console.log(JSON.stringify(parse(src), null, 2));