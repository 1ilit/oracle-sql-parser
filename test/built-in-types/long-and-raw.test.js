const { parse } = require("../../parser/parser");

describe("built in long and raw datatypes", () => {
  it("create table users(col long);", () => {
    const sql = "create table users(col long);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "long",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col long raw);", () => {
    const sql = "create table users(col long raw);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "long raw",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col raw);", () => {
    const sql = "create table users(col raw(20));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "raw",
        size: "20",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });
});
