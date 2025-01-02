const { parse } = require("../parser/parser");

const src = `create table hi.users(id rowid references hello.ji(hi,hi) on delete set null);`;

console.log(JSON.stringify(parse(src), null, 2));