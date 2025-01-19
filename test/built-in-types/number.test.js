const { Parser } = require("../../");

const parser = new Parser();

describe("built in number data types", () => {
  it("create table users(col number);", () => {
    const sql = "create table users(col number);";
    const ast = parser.parse(sql);
    const expected = {
      type: "number",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col number(20));", () => {
    const sql = "create table users(col number(20));";
    const ast = parser.parse(sql);
    const expected = {
      type: "number",
      precision: 20,
      scale: null,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col number(20, 2));", () => {
    const sql = "create table users(col number(20,2));";
    const ast = parser.parse(sql);
    const expected = {
      type: "number",
      precision: 20,
      scale: 2,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col float);", () => {
    const sql = "create table users(col float);";
    const ast = parser.parse(sql);
    const expected = {
      type: "float",
      precision: null,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col float(100));", () => {
    const sql = "create table users(col float(100));";
    const ast = parser.parse(sql);
    const expected = {
      type: "float",
      precision: 100,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col binary_float);", () => {
    const sql = "create table users(col binary_float);";
    const ast = parser.parse(sql);
    const expected = {
      type: "binary_float",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });
});
