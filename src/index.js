const { parse } = require("../parser/parser");

const src =
`create table users(
    col char,
    col char(20),
    col char(20 byte),
    col nchar,
    col nchar(100)
);`

console.log(JSON.stringify(parse(src), null, 2));