const { parse } = require("../parser/parser");

const src = `create table users(id rowid unique primary key);`;

console.log(JSON.stringify(parse(src), null, 2));