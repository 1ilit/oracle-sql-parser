const { parse } = require("../parser/parser");

const src = `create table global temporary users(
    col timestamp,
    col timestamp(10),
    col timestamp with time zone,
    col timestamp with local time zone,
    col timestamp(10) with local time zone
);`;

console.log(JSON.stringify(parse(src), null, 2));