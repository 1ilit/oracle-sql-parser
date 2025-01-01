const { parse } = require("../../parser/parser");

describe("create table", () => {
  it("create table global temporary some_db.users(col rowid);", () => {
    const sql = "create table global temporary some_db.users(col rowid);";
    const ast = parse(sql);
    const expected = {
      operation: "create",
      object: "table",
      name: "users",
      parent: null,
      memoptimize_for: null,
      schema: "some_db",
      properties: {
        scope: "global",
        temporary: "temporary",
      },
      columns: [
        {
          name: "col",
          type: {
            type: "rowid",
          },
        },
      ],
    };
    expect(ast).toMatchObject(expected);
  });

  it("create table immutable users(col rowid);", () => {
    const sql = "create table immutable users(col rowid);";
    const ast = parse(sql);
    const expected = {
      operation: "create",
      object: "table",
      name: "users",
      parent: null,
      memoptimize_for: null,
      schema: null,
      sharing: null,
      properties: {
        immutable: "immutable",
      },
      columns: [
        {
          name: "col",
          type: {
            type: "rowid",
          },
        },
      ],
    };
    expect(ast).toMatchObject(expected);
  });

  it("create table immutable blockchain users(col rowid);", () => {
    const sql = "create table immutable blockchain users(col rowid);";
    const ast = parse(sql);
    const expected = {
      operation: "create",
      object: "table",
      name: "users",
      parent: null,
      memoptimize_for: null,
      schema: null,
      sharing: null,
      properties: {
        immutable: "immutable",
        blockchain: "blockchain",
      },
      columns: [
        {
          name: "col",
          type: {
            type: "rowid",
          },
        },
      ],
    };
    expect(ast).toMatchObject(expected);
  });

  it("create table users sharing = extended data(col rowid);", () => {
    const sql = "create table users sharing = extended data(col rowid);";
    const ast = parse(sql);
    const expected = {
      operation: "create",
      object: "table",
      name: "users",
      parent: null,
      memoptimize_for: null,
      schema: null,
      sharing: {
        sharing: "sharing",
        attribute: "extended data",
      },
      properties: null,
      columns: [
        {
          name: "col",
          type: {
            type: "rowid",
          },
        },
      ],
    };
    expect(ast).toMatchObject(expected);
  });

  it("create table users(col rowid) memoptimize for read memoptimize for write;", () => {
    const sql =
      "create table users(col rowid) memoptimize for read memoptimize for write;";
    const ast = parse(sql);
    const expected = {
      operation: "create",
      object: "table",
      name: "users",
      parent: null,
      memoptimize_for: {
        read: "read",
        write: "write",
      },
      schema: null,
      sharing: null,
      properties: null,
      columns: [
        {
          name: "col",
          type: {
            type: "rowid",
          },
        },
      ],
    };
    expect(ast).toMatchObject(expected);
  });

  it("create table users(col rowid) parent some_other_db.person;", () => {
    const sql = "create table users(col rowid) parent some_other_db.person;";
    const ast = parse(sql);
    const expected = {
      operation: "create",
      object: "table",
      name: "users",
      memoptimize_for: null,
      schema: null,
      sharing: null,
      properties: null,
      parent: {
        table: "person",
        schema: "some_other_db",
      },
      columns: [
        {
          name: "col",
          type: {
            type: "rowid",
          },
        },
      ],
    };
    expect(ast).toMatchObject(expected);
  });
});
