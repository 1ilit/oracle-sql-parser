const { Parser } = require("../../");

const parser = new Parser();

describe("built in row id type", () => {
  it("create table users(col rowid);", () => {
    const sql = "create table users(col rowid);";
    const ast = parser.parse(sql);
    const expected = {
      type: "rowid",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col urowid);", () => {
    const sql = "create table users(col urowid);";
    const ast = parser.parse(sql);
    const expected = {
      type: "urowid",
      size: null,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col urowid(20));", () => {
    const sql = "create table users(col urowid(20));";
    const ast = parser.parse(sql);
    const expected = {
      type: "urowid",
      size: 20,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });
});
