const { parse } = require("../../parser/parser");

describe("built in datetime type", () => {
  it("create table users(col date);", () => {
    const sql = "create table users(col date);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "date",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col timestamp(10) with local time zone);", () => {
    const sql = "create table users(col timestamp(10) with local time zone);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "timestamp",
        fractional_seconds_precision: "10",
        with_tz: "with local time zone"
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col interval year(10) to month);", () => {
    const sql = "create table users(col interval year(10) to month);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "interval year",
        year_precision: "10",
        to_month: "to month"
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col interval day(10) to second(10));", () => {
    const sql = "create table users(col interval day(10) to second(10));";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "interval day",
        day_precision: "10",
        fractional_seconds_precision: "10",
        to_second: "to second"
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });
});
