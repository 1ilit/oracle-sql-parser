const { parse } = require("../parser/parser");

const src =
`create table users(
    col number,
    col number(20),
    col number(20, 2),
    col float(20),
    col binary_float,
    col binary_double
);`

console.log(JSON.stringify(parse(src), null, 2));