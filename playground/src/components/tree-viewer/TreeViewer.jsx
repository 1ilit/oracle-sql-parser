import { useState } from "react";

const indentSize = 12;

function isObjectOrArray(node) {
  return typeof node === "object" && node !== null;
}

function isObject(node) {
  return typeof node === "object" && node !== null && !Array.isArray(node);
}

// eslint-disable-next-line react/prop-types
export default function TreeViewer({ value }) {
  const [expandedNodes, setExpandedNodes] = useState({});

  const toggleNode = (key) => {
    setExpandedNodes((prev) => ({
      ...prev,
      [key]: !prev[key],
    }));
  };

  const renderTree = (node, depth = 0, path = "") => {
    if (typeof node !== "object" || node === null) {
      return null;
    }

    return (
      <div style={{ marginLeft: depth * indentSize }}>
        {Object.keys(node).map((key) => {
          const currentPath = path ? `${path}.${key}` : key;
          const isExpanded = expandedNodes[currentPath];

          return (
            <div key={currentPath}>
              <div
                onClick={() => toggleNode(currentPath)}
                style={{ cursor: "pointer" }}
              >
                {isObjectOrArray(node[key]) ? (
                  <span>{isExpanded ? " + " : " - "}</span>
                ) : (
                  <span className="ms-3"></span>
                )}
                {key}:
                {Array.isArray(node[key]) && (
                  <>
                    {!isExpanded && (
                      <span className="text-zinc-400 italic">
                        {" [" + node[key].length + " elements]"}
                      </span>
                    )}

                    {isExpanded && <span>{" ["}</span>}
                  </>
                )}
                {isObject(node[key]) && (
                  <>
                    {!isExpanded && (
                      <span className="ms-1 text-zinc-400 italic">
                        {Object.keys(node[key]).length > 3
                          ? `{ ${Object.keys(node[key])
                              .slice(0, 3)
                              .join(", ")}... }`
                          : `{ ${Object.keys(node[key]).join(", ")} }`}
                      </span>
                    )}

                    {isExpanded && <span>{" {"}</span>}
                  </>
                )}
                {(typeof node[key] !== "object" || node[key] === null) && (
                  <span>{node[key] ?? "null"} </span>
                )}
              </div>
              {isExpanded && renderTree(node[key], depth + 1, currentPath)}
              {Array.isArray(node[key]) && isExpanded && (
                <span className="ms-3">{"]"}</span>
              )}
              {isObject(node[key]) && isExpanded && (
                <span className="ms-3">{"}"}</span>
              )}
            </div>
          );
        })}
      </div>
    );
  };

  return <div className="px-6 py-3">{renderTree(value)}</div>;
}
