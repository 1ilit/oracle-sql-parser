import CodeMirror from "@uiw/react-codemirror";
import { sql } from "@codemirror/lang-sql";
import "./SQLEditor.css";

// eslint-disable-next-line react/prop-types
export default function SQLEditor({ value, onChange }) {
  return (
    <div>
      <CodeMirror extensions={[sql()]} value={value} onChange={onChange} />
    </div>
  );
}
