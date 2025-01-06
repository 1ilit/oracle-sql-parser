const { parse } = require("../parser/parser");

const src = `create table users(
  id number,
  col clob
) lob (hi) store as basicfile (tablespace set hi) (partition hi lob (nyam) store as securefile);`;

console.log(JSON.stringify(parse(src), null, 2));