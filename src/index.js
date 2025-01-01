const { parse } = require("../parser/parser");

const src = `create table global temporary users sharing = extended data(
    col timestamp
) memoptimize for write;`;

console.log(JSON.stringify(parse(src), null, 2));