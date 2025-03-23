const { Parser } = require("../../");

const parser = new Parser();

describe("create sequence statement", () => {
  it("create sequence incr increment by 1;", () => {
    const sql = "create sequence incr increment by 1;";
    const ast = parser.parse(sql);
    const expected = {
      operation: "create",
      object: "sequence",
      if_not_exists: null,
      name: { schema: null, name: "incr" },
      sharing: null,
      settings: { increment_by: 1 },
    };
    expect(ast[0]).toMatchObject(expected);
  });
});
