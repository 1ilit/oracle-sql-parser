const { parse } = require("../parser/parser");

const src = `create table users(
  id number,
  col clob
) varray hi store as basicfile lob (chunk 10 pctversion 10 storage(next 20K));`;

console.log(JSON.stringify(parse(src), null, 2));