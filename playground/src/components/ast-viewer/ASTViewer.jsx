import { Parser } from "oracle-sql-parser";
import { useMemo } from "react";

const parser = new Parser();

// eslint-disable-next-line react/prop-types
export default function ASTViewer({ sql }) {
  const tree = useMemo(() => {
    try {
      return parser.parse(sql);
    } catch (e) {
      console.log(e);
    }
  }, [sql]);

  return <div>{JSON.stringify(tree, null, 2)}</div>;
}
