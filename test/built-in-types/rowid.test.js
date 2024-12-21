const { parse } = require("../../parser/parser");

describe("built in row id type", () => {
  it("create table users(col rowid);", () => {
    const sql = "create table users(col rowid);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "rowid",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col urowid);", () => {
    const sql = "create table users(col urowid);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "urowid",
        size: null,
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col urowid(20));", () => {
    const sql = "create table users(col urowid(20));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "urowid",
        size: "20",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });
});
