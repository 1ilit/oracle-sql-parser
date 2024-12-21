const { parse } = require("../../parser/parser");

describe("built in number data types", () => {
  it("create table users(col number);", () => {
    const sql = "create table users(col number);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "number",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col number(20));", () => {
    const sql = "create table users(col number(20));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "number",
        precision: "20",
        scale: null,
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col number(20, 2));", () => {
    const sql = "create table users(col number(20,2));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "number",
        precision: "20",
        scale: "2",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col float);", () => {
    const sql = "create table users(col float);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "float",
        precision: null,
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col float(100));", () => {
    const sql = "create table users(col float(100));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "float",
        precision: "100",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col binary_float);", () => {
    const sql = "create table users(col binary_float);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "binary_float",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });
});
