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
        {Object.entries(node).map(([key, val]) => {
          const currentPath = path ? `${path}.${key}` : key;
          const isExpanded = expandedNodes[currentPath];

          return (
            <div key={currentPath}>
              <div
                onClick={() => toggleNode(currentPath)}
                className="cursor-pointer"
              >
                {/* collapse icon or indent */}
                {isObjectOrArray(val) ? (
                  <i
                    className={`text-xs text-zinc-500 inline-flex items-center justify-center w-4 h-4 mr-1 ${
                      isExpanded
                        ? "fa-solid fa-chevron-up"
                        : "fa-solid fa-chevron-down"
                    }`}
                  ></i>
                ) : (
                  <span className="ms-5"></span>
                )}
                {/* field key */}
                <span
                  className={`${
                    depth % 2 === 0 ? "text-sky-600" : "text-yellow-600"
                  } hover:underline`}
                >
                  {key}
                </span>
                :{/* array element count or opening bracket */}
                {Array.isArray(val) && (
                  <>
                    {!isExpanded && (
                      <span className="text-zinc-400 italic hover:underline">
                        {" [" + val.length + " elements]"}
                      </span>
                    )}

                    {isExpanded && (
                      <span className="text-zinc-400">{" ["}</span>
                    )}
                  </>
                )}
                {/* object keys or opening brace */}
                {isObject(val) && (
                  <>
                    {!isExpanded && (
                      <span className="ms-1 text-zinc-400 italic hover:underline">
                        {Object.keys(val).length > 3
                          ? `{ ${Object.keys(val).slice(0, 3).join(", ")}... }`
                          : `{ ${Object.keys(val).join(", ")} }`}
                      </span>
                    )}

                    {isExpanded && (
                      <span className="text-zinc-400">{" {"}</span>
                    )}
                  </>
                )}
                {/* literal */}
                {!isObjectOrArray(val) && (
                  <span className="ms-1">
                    {val ? (
                      <span className="text-emerald-600">
                        {typeof val === "string" ? `"${val}"` : val}
                      </span>
                    ) : (
                      <span className="text-indigo-400">NULL</span>
                    )}
                  </span>
                )}
              </div>

              {/* rest of node */}
              {isExpanded && renderTree(val, depth + 1, currentPath)}

              {/* closing array bracket */}
              {Array.isArray(val) && isExpanded && (
                <span className="ms-5 text-zinc-400">{"]"}</span>
              )}

              {/* closing object brace */}
              {isObject(val) && isExpanded && (
                <span className="ms-5 text-zinc-400">{"}"}</span>
              )}
            </div>
          );
        })}
      </div>
    );
  };

  return <div className="px-6 py-3 text-lg">{renderTree(value)}</div>;
}
