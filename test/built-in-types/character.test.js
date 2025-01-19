const { Parser } = require("../../");

const parser = new Parser();

describe("built in character data types", () => {
  it("create table users(col char);", () => {
    const sql = "create table users(col char);";
    const ast = parser.parse(sql);
    const expected = {
      type: "char",
      size: null,
      semantics: null,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col char(20));", () => {
    const sql = "create table users(col char(20));";
    const ast = parser.parse(sql);
    const expected = {
      type: "char",
      size: 20,
      semantics: null,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col char(20 byte));", () => {
    const sql = "create table users(col char(20 byte));";
    const ast = parser.parse(sql);
    const expected = {
      type: "char",
      size: 20,
      semantics: "byte",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col nchar);", () => {
    const sql = "create table users(col nchar);";
    const ast = parser.parse(sql);
    const expected = {
      type: "nchar",
      size: null,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col nchar(100));", () => {
    const sql = "create table users(col nchar(100));";
    const ast = parser.parse(sql);
    const expected = {
      type: "nchar",
      size: 100,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });
});
