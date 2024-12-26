const { parse } = require("../../parser/parser");

describe("oracle supplied types type", () => {
  it("create table users(col SYS.AnyData);", () => {
    const sql = "create table users(col SYS.AnyData);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "sys.anydata",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col SYS.AnyType);", () => {
    const sql = "create table users(col SYS.AnyType);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "sys.anytype",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col SYS.AnyDataSet);", () => {
    const sql = "create table users(col SYS.AnyDataSet);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "sys.anydataset",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col XMLType);", () => {
    const sql = "create table users(col XMLType);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "xmltype",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col URIType);", () => {
    const sql = "create table users(col URIType);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "uritype",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col SDO_Geometry);", () => {
    const sql = "create table users(col SDO_Geometry);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "sdo_geometry",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col SDO_Topo_Geometry);", () => {
    const sql = "create table users(col SDO_Topo_Geometry);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "sdo_topo_geometry",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });

  it("create table users(col SDO_GeoRaster);", () => {
    const sql = "create table users(col SDO_GeoRaster);";
    const ast = parse(sql);
    const expected = {
      name: "col",
      type: {
        type: "sdo_georaster",
      },
    };
    expect(ast.columns[0]).toMatchObject(expected);
  });
});
