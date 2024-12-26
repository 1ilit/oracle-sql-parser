const { parse } = require("../parser/parser");

const src = `create table users(
    col sys.anydata
);`;

console.log(JSON.stringify(parse(src), null, 2));