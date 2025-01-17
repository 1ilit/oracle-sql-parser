const { Parser } = require("../../");

const parser = new Parser();

describe("drop table statement", () => {
  it("drop table some_db.users cascade constraints purge;", () => {
    const sql = "drop table some_db.users cascade constraints purge;";
    const ast = parser.parse(sql);
    const expected = {
      name: {
        schema: "some_db",
        table: "users",
      },
      purge: "purge",
      object: "table",
      operation: "drop",
      cascade_constraints: "cascade constraints",
    };
    expect(ast[0]).toMatchObject(expected);
  });
});
