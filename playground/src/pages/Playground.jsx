import ASTViewer from "../components/ast-viewer/ASTViewer";
import Header from "../components/header/Header";
import SQLEditor from "../components/sql-editor/SQLEditor";

export default function Playground() {
  return (
    <div>
      <Header />
      <div className="flex">
        <SQLEditor />
        <ASTViewer />
      </div>
    </div>
  );
}
