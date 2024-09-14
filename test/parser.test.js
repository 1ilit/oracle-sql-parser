const { parse } = require("../rules-parser");

describe("character data types", () => {
  it("should return ast with with col name, type, and character semantics", async () => {
    const sql = "create table users(col char(20 byte));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "char",
        size: {
          size: "20",
          character_semantics: "byte",
        },
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });
});
