import { useState } from "react";
import ASTViewer from "../components/ast-viewer/ASTViewer";
import Header from "../components/header/Header";
import SQLEditor from "../components/sql-editor/SQLEditor";

const minEditorWidth = 360;

export default function Playground() {
  const [isResizing, setIsResizing] = useState(false);
  const [editorWidth, setEditorWidth] = useState(minEditorWidth);
  const [sql, setSQL] = useState("");

  const handleResize = (e) => {
    if (!isResizing) return;

    if (e.clientX > minEditorWidth) {
      setEditorWidth(e.clientX);
    } else {
      setIsResizing(false);
    }
  };

  return (
    <div onMouseMove={handleResize}>
      <Header />
      <div className="flex h-96 bg-pink-50">
        <div style={{ minWidth: editorWidth }}>
          <SQLEditor value={sql} onChange={(v) => setSQL(v)} />
        </div>
        <div
          className="flex justify-center items-center p-1 h-auto hover-2 cursor-col-resize bg-neutral-100"
          onMouseDown={() => setIsResizing(true)}
          onMouseUp={() => setIsResizing(false)}
        >
          <div className="w-1 border-x border-neutral-200 h-1/5" />
        </div>
        <ASTViewer sql={sql}/>
      </div>
    </div>
  );
}
