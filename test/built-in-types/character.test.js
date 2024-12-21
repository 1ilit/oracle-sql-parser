const { parse } = require("../../parser/parser");

describe("built in character data types", () => {
  it("create table users(col char);", () => {
    const sql = "create table users(col char);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "char",
        size: null,
        semantics: null,
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col char(20));", () => {
    const sql = "create table users(col char(20));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "char",
        size: "20",
        semantics: null,
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col char(20 byte));", () => {
    const sql = "create table users(col char(20 byte));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "char",
        size: "20",
        semantics: "byte",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col nchar);", () => {
    const sql = "create table users(col nchar);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "nchar",
        size: null,
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col nchar(100));", () => {
    const sql = "create table users(col nchar(100));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "nchar",
        size: "100",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });
});
