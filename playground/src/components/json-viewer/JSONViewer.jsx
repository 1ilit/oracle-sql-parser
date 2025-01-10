import CodeMirror from "@uiw/react-codemirror";
import { json } from "@codemirror/lang-json";
import "./JSONViewer.css";

// eslint-disable-next-line react/prop-types
export default function JSONViewer({ value }) {
  return (
    <div>
      <CodeMirror extensions={[json()]} value={value} editable={false} />
    </div>
  );
}
