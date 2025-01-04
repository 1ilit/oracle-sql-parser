const { parse } = require("../parser/parser");

const src = `create table users(
    id rowid
);`;

console.log(JSON.stringify(parse(src), null, 2));