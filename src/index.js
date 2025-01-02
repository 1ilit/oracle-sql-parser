const { parse } = require("../parser/parser");

const src = `create table hi.users(id rowid references hello.ji(hi,hi) on delete set null initially deferred not deferrable norely enable validate exceptions into nyam.lol, name varchar(100) with rowid);`;

console.log(JSON.stringify(parse(src), null, 2));