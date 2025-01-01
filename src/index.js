const { parse } = require("../parser/parser");

const src = `create table users(id rowid encrypt salt);`;

console.log(JSON.stringify(parse(src), null, 2));