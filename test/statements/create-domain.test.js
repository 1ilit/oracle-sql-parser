const { Parser } = require("../../");

const parser = new Parser();

describe("create domain statement", () => {
  it("create domain sizes as enum (small, medium, large);", () => {
    const sql = "create domain sizes as enum (small, medium, large);";
    const ast = parser.parse(sql);

    const expected = {
      operation: "create",
      usecase: null,
      object: "domain",
      if_not_exists: null,
      name: {
        schema: null,
        name: "sizes",
      },
      as: {
        object: "enum",
        enum_list: [
          {
            name: "small",
            enum_alias_list: null,
            value: null,
          },
          {
            name: "medium",
            enum_alias_list: null,
            value: null,
          },
          {
            name: "large",
            enum_alias_list: null,
            value: null,
          },
        ],
      },
    };
    expect(ast[0]).toMatchObject(expected);
  });
});
