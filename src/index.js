const { parse } = require("../parser/parser");

const src = `create table users(
    _col number,
    _col2 number,
    _col_2 number,
    Col_2 number
);`;

console.log(JSON.stringify(parse(src), null, 2));