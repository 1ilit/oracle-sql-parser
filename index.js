const { parse } = require("./rules-parser");

const src =
`create table users(
    col char(20 byte),
    col nchar(120),
    col varchar2(220 char),
    col nvarchar2(320)
);`

console.log(JSON.stringify(parse(src), null, 2));