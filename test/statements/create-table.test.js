const { parse } = require("../../parser/parser");

describe("create table", () => {
  it("create table global temporary users(col rowid);", () => {
    const sql = "create table global temporary users(col rowid);";
    const ast = parse(sql);
    const expected = {
      operation: "create",
      object: "table",
      properties: {
        scope: "global",
        temporary: "temporary",
      },
      columns: [
        {
          name: "col",
          type: {
            type: "rowid",
          },
        },
      ],
    };
    expect(ast).toMatchObject(expected);
  });

  it("create table immutable users(col rowid);", () => {
    const sql = "create table immutable users(col rowid);";
    const ast = parse(sql);
    const expected = {
      operation: "create",
      object: "table",
      properties: {
        immutable: "immutable",
      },
      columns: [
        {
          name: "col",
          type: {
            type: "rowid",
          },
        },
      ],
    };
    expect(ast).toMatchObject(expected);
  });

  it("create table immutable blockchain users(col rowid);", () => {
    const sql = "create table immutable blockchain users(col rowid);";
    const ast = parse(sql);
    const expected = {
      operation: "create",
      object: "table",
      properties: {
        immutable: "immutable",
        blockchain: "blockchain",
      },
      columns: [
        {
          name: "col",
          type: {
            type: "rowid",
          },
        },
      ],
    };
    expect(ast).toMatchObject(expected);
  });
});
