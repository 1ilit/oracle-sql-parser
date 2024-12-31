const { parse } = require("../../parser/parser");

describe("ansi supported types", () => {
  it("create table users(col character(20));", () => {
    const sql = "create table users(col character(20));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "character",
        size: "20",
        varying: null,
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col varchar(20));", () => {
    const sql = "create table users(col varchar(20));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "varchar",
        size: "20",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col nchar varying(20));", () => {
    const sql = "create table users(col nchar varying(20));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "nchar",
        size: "20",
        varying: "varying",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col character varying(20));", () => {
    const sql = "create table users(col character varying(20));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "character",
        size: "20",
        varying: "varying",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col national character varying(20));", () => {
    const sql = "create table users(col national character varying(20));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "national",
        char: "character",
        size: "20",
        varying: "varying",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col decimal(10, 2));", () => {
    const sql = "create table users(col decimal(10, 2));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "decimal",
        precision: "10",
        scale: "2",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col double precision);", () => {
    const sql = "create table users(col double precision);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "double precision",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });
});
