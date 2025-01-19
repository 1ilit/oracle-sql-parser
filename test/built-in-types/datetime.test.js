const { Parser } = require("../../");

const parser = new Parser();

describe("built in datetime type", () => {
  it("create table users(col date);", () => {
    const sql = "create table users(col date);";
    const ast = parser.parse(sql);
    const expected = {
      type: "date",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col timestamp(10) with local time zone);", () => {
    const sql = "create table users(col timestamp(10) with local time zone);";
    const ast = parser.parse(sql);
    const expected = {
      type: "timestamp",
      fractional_seconds_precision: 10,
      with_tz: "with local time zone",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col interval year(10) to month);", () => {
    const sql = "create table users(col interval year(10) to month);";
    const ast = parser.parse(sql);
    const expected = {
      type: "interval year",
      year_precision: 10,
      to_month: "to month",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col interval day(10) to second(10));", () => {
    const sql = "create table users(col interval day(10) to second(10));";
    const ast = parser.parse(sql);
    const expected = {
      type: "interval day",
      day_precision: 10,
      fractional_seconds_precision: 10,
      to_second: "to second",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });
});
