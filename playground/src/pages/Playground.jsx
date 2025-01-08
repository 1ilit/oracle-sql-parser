import ASTViewer from "../components/ast-viewer/ASTViewer";
import SQLEditor from "../components/sql-editor/SQLEditor";

export default function Playground() {
  return (
    <div>
      <SQLEditor />
      <ASTViewer />
    </div>
  );
}
