const { Parser } = require("../../");

const parser = new Parser();

describe("create table statement", () => {
  it("create table some_db.users(col integer);", () => {
    const sql = "create table some_db.users(col integer);";
    const ast = parser.parse(sql);
    const expectedName = {
      schema: "some_db",
      name: "users",
    };
    expect(ast[0].name).toMatchObject(expectedName);
  });

  it("create table immutable some_db.users(col integer);", () => {
    const sql = "create table immutable some_db.users(col integer);";
    const ast = parser.parse(sql);
    const expectedTableType = {
      immutable: "immutable",
    };
    expect(ast[0].type).toMatchObject(expectedTableType);
  });

  it("create table immutable blockchain some_db.users(col integer);", () => {
    const sql = "create table immutable blockchain some_db.users(col integer);";
    const ast = parser.parse(sql);
    const expectedTableType = {
      immutable: "immutable",
      blockchain: "blockchain",
    };
    expect(ast[0].type).toMatchObject(expectedTableType);
  });

  it("create table users sharing = extended data(col integer);", () => {
    const sql = "create table users sharing = extended data(col rowid);";
    const ast = parser.parse(sql);
    const expectedSharingObj = {
      sharing: "sharing",
      attribute: "extended data",
    };
    expect(ast[0].sharing).toMatchObject(expectedSharingObj);
  });

  it("create table users(col integer) memoptimize for read memoptimize for write;", () => {
    const sql =
      "create table users(col integer) memoptimize for read memoptimize for write;";
    const ast = parser.parse(sql);
    const expectedMemoptimize = {
      read: "read",
      write: "write",
    };
    expect(ast[0].memoptimize_for).toMatchObject(expectedMemoptimize);
  });

  it("create table users(col integer) parent some_other_db.person;", () => {
    const sql = "create table users(col integer) parent some_other_db.person;";
    const ast = parser.parse(sql);
    const expectedParent = {
      name: "person",
      schema: "some_other_db",
    };
    expect(ast[0].parent).toMatchObject(expectedParent);
  });

  it("create table users(col integer) default collation some_collation;", () => {
    const sql =
      "create table users(col integer) default collation some_collation;";
    const ast = parser.parse(sql);
    const expectedTableCollation = {
      default: "default",
      name: "some_collation",
    };
    expect(ast[0].table.collation).toMatchObject(expectedTableCollation);
  });
});
