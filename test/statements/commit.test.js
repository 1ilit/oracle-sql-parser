const { Parser } = require("../../");

const parser = new Parser();

describe("commit statement", () => {
  it("commit;", () => {
    const sql = "commit;";
    const ast = parser.parse(sql);
    const expected = {
      operation: "commit",
      work: null,
      settings: null,
    };
    expect(ast[0]).toMatchObject(expected);
  });
});
