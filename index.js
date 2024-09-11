const { parse } = require("./rules-parser");

const src =
`create table users(
    id integer,
    name text,
    dob date,
    height float
);`

console.log(parse(src));
