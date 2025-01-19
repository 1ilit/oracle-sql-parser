const { Parser } = require("../../");

const parser = new Parser();

describe("built in long and raw datatypes", () => {
  it("create table users(col long);", () => {
    const sql = "create table users(col long);";
    const ast = parser.parse(sql);
    const expected = {
      type: "long",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col long raw);", () => {
    const sql = "create table users(col long raw);";
    const ast = parser.parse(sql);
    const expected = {
      type: "long raw",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col raw);", () => {
    const sql = "create table users(col raw(20));";
    const ast = parser.parse(sql);
    const expected = {
      type: "raw",
      size: 20,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });
});
