import { Parser } from "oracle-sql-parser";
import { useMemo, useState } from "react";
import JSONViewer from "../json-viewer/JSONViewer";
import TreeViewer from "../tree-viewer/TreeViewer";

const parser = new Parser();

const ASTViewerMode = {
  TREEVIEW: 0,
  JSON: 1,
};

// eslint-disable-next-line react/prop-types
export default function ASTViewer({ sql }) {
  const [mode, setMode] = useState(ASTViewerMode.TREEVIEW);

  const tree = useMemo(() => {
    try {
      return parser.parse(sql);
    } catch (e) {
      console.log(e);
    }
  }, [sql]);

  return (
    <div className="relative w-full h-full overflow-auto bg-zinc-100">
      {mode === ASTViewerMode.JSON && (
        <JSONViewer value={JSON.stringify(tree, null, 2)} />
      )}
      {mode === ASTViewerMode.TREEVIEW && <TreeViewer value={tree} />}

      <div className="fixed top-20 right-8 bg-white flex border rounded-md p-2">
        <button
          onClick={() => setMode(ASTViewerMode.JSON)}
          className={`${
            mode === ASTViewerMode.JSON ? "bg-zinc-100" : ""
          } px-4 py-2 rounded-md`}
        >
          JSON
        </button>
        <button
          onClick={() => setMode(ASTViewerMode.TREEVIEW)}
          className={`${
            mode === ASTViewerMode.TREEVIEW ? "bg-zinc-100" : ""
          } px-4 py-2 rounded-md`}
        >
          TreeViewer
        </button>
      </div>
    </div>
  );
}
