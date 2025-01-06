const { Parser } = require('../');

const p = new Parser();

const src = `create table users(
  id number,
  col clob
) lob (hi) store as basicfile (tablespace set hi) (partition hi lob (nyam) store as securefile);`;

console.log(JSON.stringify(p.parse(src), null, 2));