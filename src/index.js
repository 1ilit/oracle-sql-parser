const { parse } = require("../parser/parser");

const src = `create table users(
    id rowid,
    nyam timestamp,
    period for nyam(nyam, nyam),
    supplemental log data (UNIQUE, PRIMARY KEY) COLUMNS,
    supplemental log group grp(hi, hi no log) always
);`;

console.log(JSON.stringify(parse(src), null, 2));