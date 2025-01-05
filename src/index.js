const { parse } = require("../parser/parser");

const src = `create table users(
  id number,
  col clob
) json(col) store as (tablespace nyam);`;

console.log(JSON.stringify(parse(src), null, 2));