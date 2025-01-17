import { useEffect, useState } from "react";
import ASTViewer from "../components/ast-viewer/ASTViewer";
import Header from "../components/header/Header";
import SQLEditor from "../components/sql-editor/SQLEditor";
import useDebounce from "../hooks/useDebounce";

const minEditorWidth = 540;

export default function Playground() {
  const [isResizing, setIsResizing] = useState(false);
  const [editorWidth, setEditorWidth] = useState(minEditorWidth);
  const [sql, setSQL] = useState(() => localStorage.getItem("sql-code") || "");
  const debouncedValue = useDebounce(sql);

  const handleResize = (e) => {
    if (!isResizing) return;

    setEditorWidth(Math.max(e.clientX, minEditorWidth));
  };

  useEffect(() => {
    localStorage.setItem("sql-code", debouncedValue);
  }, [debouncedValue]);

  return (
    <div
      onMouseMove={handleResize}
      onMouseUp={() => setIsResizing(false)}
      className="h-screen flex flex-col overflow-hidden"
    >
      <Header />
      <div className="flex h-full overflow-y-auto">
        <div style={{ minWidth: editorWidth }} className="h-full overflow-auto">
          <SQLEditor value={sql} onChange={(v) => setSQL(v)} />
        </div>
        <div
          className="flex justify-center items-center p-1 cursor-col-resize bg-zinc-50 h-full overflow-auto border-x hover:bg-zinc-100"
          onMouseDown={() => setIsResizing(true)}
        >
          <div className="w-1 border-x border-zinc-200 h-1/5" />
        </div>
        <ASTViewer sql={debouncedValue} className="h-full" />
      </div>
    </div>
  );
}
