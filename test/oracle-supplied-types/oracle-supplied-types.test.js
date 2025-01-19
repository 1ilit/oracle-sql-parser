const { Parser } = require("../../");

const parser = new Parser();

describe("oracle supplied types type", () => {
  it("create table users(col SYS.AnyData);", () => {
    const sql = "create table users(col SYS.AnyData);";
    const ast = parser.parse(sql);
    const expected = {
      type: "sys.anydata",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col SYS.AnyType);", () => {
    const sql = "create table users(col SYS.AnyType);";
    const ast = parser.parse(sql);
    const expected = {
      type: "sys.anytype",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col SYS.AnyDataSet);", () => {
    const sql = "create table users(col SYS.AnyDataSet);";
    const ast = parser.parse(sql);
    const expected = {
      type: "sys.anydataset",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col XMLType);", () => {
    const sql = "create table users(col XMLType);";
    const ast = parser.parse(sql);
    const expected = {
      type: "xmltype",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col URIType);", () => {
    const sql = "create table users(col URIType);";
    const ast = parser.parse(sql);
    const expected = {
      type: "uritype",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col SDO_Geometry);", () => {
    const sql = "create table users(col SDO_Geometry);";
    const ast = parser.parse(sql);
    const expected = {
      type: "sdo_geometry",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col SDO_Topo_Geometry);", () => {
    const sql = "create table users(col SDO_Topo_Geometry);";
    const ast = parser.parse(sql);
    const expected = {
      type: "sdo_topo_geometry",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });

  it("create table users(col SDO_GeoRaster);", () => {
    const sql = "create table users(col SDO_GeoRaster);";
    const ast = parser.parse(sql);
    const expected = {
      type: "sdo_georaster",
    };
    expect(ast[0].table.relational_properties[0].type).toMatchObject(expected);
  });
});
