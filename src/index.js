const { parse } = require("../parser/parser");

const src = `create table users(
    id rowid,
    nyam timestamp,
    period for nyam(nyam, nyam)
);`;

console.log(JSON.stringify(parse(src), null, 2));