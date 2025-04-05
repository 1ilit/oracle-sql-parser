const { Parser } = require("../../");

const parser = new Parser();

describe("create index statement", () => {
  it("create unique index some_index on some_table (col1, col2);", () => {
    const sql = "create unique index some_index on some_table (col1, col2);";
    const ast = parser.parse(sql);
    const expected = {
      operation: "create",
      type: "unique",
      object: "index",
      if_not_exists: null,
      name: {
        schema: null,
        name: "some_index",
      },
      target: {
        name: {
          schema: null,
          name: "some_table",
        },
        object: "table",
        t_alias: null,
        columns: [
          {
            name: "col1",
            order: null,
          },
          {
            name: "col2",
            order: null,
          },
        ],
      },
      usable: null,
      invalidation: null,
    };
    expect(ast[0]).toMatchObject(expected);
  });
});
