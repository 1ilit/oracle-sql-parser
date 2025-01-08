import { Parser } from "oracle-sql-parser";

const parser = new Parser();

const ast = parser.parse(`create table users(id int);`);

export default function ASTViewer() {
  return <div>{JSON.stringify(ast, null, 2)}</div>;
}
