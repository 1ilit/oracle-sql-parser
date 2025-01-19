const { Parser } = require("../../");

const parser = new Parser();

describe("ansi supported types", () => {
  it("create table users(col character(20));", () => {
    const sql = "create table users(col character(20));";
    const ast = parser.parse(sql);
    const expectedType = {
      type: "character",
      size: 20,
      varying: null,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expectedType);
  });

  it("create table users(col varchar(20));", () => {
    const sql = "create table users(col varchar(20));";
    const ast = parser.parse(sql);
    const expectedType = {
      type: "varchar",
      size: 20,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expectedType);
  });

  it("create table users(col nchar varying(20));", () => {
    const sql = "create table users(col nchar varying(20));";
    const ast = parser.parse(sql);
    const expectedType = {
      type: "nchar",
      size: 20,
      varying: "varying",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expectedType);
  });

  it("create table users(col character varying(20));", () => {
    const sql = "create table users(col character varying(20));";
    const ast = parser.parse(sql);
    const expectedType = {
      type: "character",
      size: 20,
      varying: "varying",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expectedType);
  });

  it("create table users(col national character varying(20));", () => {
    const sql = "create table users(col national character varying(20));";
    const ast = parser.parse(sql);
    const expectedType = {
      type: "national",
      char: "character",
      size: 20,
      varying: "varying",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expectedType);
  });

  it("create table users(col decimal(10, 2));", () => {
    const sql = "create table users(col decimal(10, 2));";
    const ast = parser.parse(sql);
    const expectedType = {
      type: "decimal",
      precision: 10,
      scale: 2,
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expectedType);
  });

  it("create table users(col double precision);", () => {
    const sql = "create table users(col double precision);";
    const ast = parser.parse(sql);
    const expectedType = {
      type: "double precision",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expectedType);
  });
});
