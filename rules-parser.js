// @generated by Peggy 4.0.3.
//
// https://peggyjs.org/

"use strict";


function peg$subclass(child, parent) {
  function C() { this.constructor = child; }
  C.prototype = parent.prototype;
  child.prototype = new C();
}

function peg$SyntaxError(message, expected, found, location) {
  var self = Error.call(this, message);
  // istanbul ignore next Check is a necessary evil to support older environments
  if (Object.setPrototypeOf) {
    Object.setPrototypeOf(self, peg$SyntaxError.prototype);
  }
  self.expected = expected;
  self.found = found;
  self.location = location;
  self.name = "SyntaxError";
  return self;
}

peg$subclass(peg$SyntaxError, Error);

function peg$padEnd(str, targetLength, padString) {
  padString = padString || " ";
  if (str.length > targetLength) { return str; }
  targetLength -= str.length;
  padString += padString.repeat(targetLength);
  return str + padString.slice(0, targetLength);
}

peg$SyntaxError.prototype.format = function(sources) {
  var str = "Error: " + this.message;
  if (this.location) {
    var src = null;
    var k;
    for (k = 0; k < sources.length; k++) {
      if (sources[k].source === this.location.source) {
        src = sources[k].text.split(/\r\n|\n|\r/g);
        break;
      }
    }
    var s = this.location.start;
    var offset_s = (this.location.source && (typeof this.location.source.offset === "function"))
      ? this.location.source.offset(s)
      : s;
    var loc = this.location.source + ":" + offset_s.line + ":" + offset_s.column;
    if (src) {
      var e = this.location.end;
      var filler = peg$padEnd("", offset_s.line.toString().length, ' ');
      var line = src[s.line - 1];
      var last = s.line === e.line ? e.column : line.length + 1;
      var hatLen = (last - s.column) || 1;
      str += "\n --> " + loc + "\n"
          + filler + " |\n"
          + offset_s.line + " | " + line + "\n"
          + filler + " | " + peg$padEnd("", s.column - 1, ' ')
          + peg$padEnd("", hatLen, "^");
    } else {
      str += "\n at " + loc;
    }
  }
  return str;
};

peg$SyntaxError.buildMessage = function(expected, found) {
  var DESCRIBE_EXPECTATION_FNS = {
    literal: function(expectation) {
      return "\"" + literalEscape(expectation.text) + "\"";
    },

    class: function(expectation) {
      var escapedParts = expectation.parts.map(function(part) {
        return Array.isArray(part)
          ? classEscape(part[0]) + "-" + classEscape(part[1])
          : classEscape(part);
      });

      return "[" + (expectation.inverted ? "^" : "") + escapedParts.join("") + "]";
    },

    any: function() {
      return "any character";
    },

    end: function() {
      return "end of input";
    },

    other: function(expectation) {
      return expectation.description;
    }
  };

  function hex(ch) {
    return ch.charCodeAt(0).toString(16).toUpperCase();
  }

  function literalEscape(s) {
    return s
      .replace(/\\/g, "\\\\")
      .replace(/"/g,  "\\\"")
      .replace(/\0/g, "\\0")
      .replace(/\t/g, "\\t")
      .replace(/\n/g, "\\n")
      .replace(/\r/g, "\\r")
      .replace(/[\x00-\x0F]/g,          function(ch) { return "\\x0" + hex(ch); })
      .replace(/[\x10-\x1F\x7F-\x9F]/g, function(ch) { return "\\x"  + hex(ch); });
  }

  function classEscape(s) {
    return s
      .replace(/\\/g, "\\\\")
      .replace(/\]/g, "\\]")
      .replace(/\^/g, "\\^")
      .replace(/-/g,  "\\-")
      .replace(/\0/g, "\\0")
      .replace(/\t/g, "\\t")
      .replace(/\n/g, "\\n")
      .replace(/\r/g, "\\r")
      .replace(/[\x00-\x0F]/g,          function(ch) { return "\\x0" + hex(ch); })
      .replace(/[\x10-\x1F\x7F-\x9F]/g, function(ch) { return "\\x"  + hex(ch); });
  }

  function describeExpectation(expectation) {
    return DESCRIBE_EXPECTATION_FNS[expectation.type](expectation);
  }

  function describeExpected(expected) {
    var descriptions = expected.map(describeExpectation);
    var i, j;

    descriptions.sort();

    if (descriptions.length > 0) {
      for (i = 1, j = 1; i < descriptions.length; i++) {
        if (descriptions[i - 1] !== descriptions[i]) {
          descriptions[j] = descriptions[i];
          j++;
        }
      }
      descriptions.length = j;
    }

    switch (descriptions.length) {
      case 1:
        return descriptions[0];

      case 2:
        return descriptions[0] + " or " + descriptions[1];

      default:
        return descriptions.slice(0, -1).join(", ")
          + ", or "
          + descriptions[descriptions.length - 1];
    }
  }

  function describeFound(found) {
    return found ? "\"" + literalEscape(found) + "\"" : "end of input";
  }

  return "Expected " + describeExpected(expected) + " but " + describeFound(found) + " found.";
};

function peg$parse(input, options) {
  options = options !== undefined ? options : {};

  var peg$FAILED = {};
  var peg$source = options.grammarSource;

  var peg$startRuleFunctions = { start: peg$parsestart };
  var peg$startRuleFunction = peg$parsestart;

  var peg$c0 = "create";
  var peg$c1 = "table";
  var peg$c2 = "(";
  var peg$c3 = ",";
  var peg$c4 = ")";
  var peg$c5 = ";";
  var peg$c6 = "byte";
  var peg$c7 = "char";
  var peg$c8 = "varchar2";
  var peg$c9 = "nchar";
  var peg$c10 = "nvarchar2";
  var peg$c11 = "binary_float";
  var peg$c12 = "binary_double";
  var peg$c13 = "float";
  var peg$c14 = "number";
  var peg$c15 = "long raw";
  var peg$c16 = "long";
  var peg$c17 = "raw";
  var peg$c18 = "blob";
  var peg$c19 = "clob";
  var peg$c20 = "nclob";
  var peg$c21 = "bfile";

  var peg$r0 = /^[0-9]/;
  var peg$r1 = /^[a-zA-Z]/;
  var peg$r2 = /^[ \t\n\r]/;

  var peg$e0 = peg$literalExpectation("create", true);
  var peg$e1 = peg$literalExpectation("table", true);
  var peg$e2 = peg$literalExpectation("(", false);
  var peg$e3 = peg$literalExpectation(",", false);
  var peg$e4 = peg$literalExpectation(")", false);
  var peg$e5 = peg$literalExpectation(";", false);
  var peg$e6 = peg$literalExpectation("byte", true);
  var peg$e7 = peg$literalExpectation("char", true);
  var peg$e8 = peg$literalExpectation("varchar2", true);
  var peg$e9 = peg$literalExpectation("nchar", true);
  var peg$e10 = peg$literalExpectation("nvarchar2", true);
  var peg$e11 = peg$literalExpectation("binary_float", true);
  var peg$e12 = peg$literalExpectation("binary_double", true);
  var peg$e13 = peg$literalExpectation("float", true);
  var peg$e14 = peg$literalExpectation("number", true);
  var peg$e15 = peg$literalExpectation("long raw", true);
  var peg$e16 = peg$literalExpectation("long", true);
  var peg$e17 = peg$literalExpectation("raw", true);
  var peg$e18 = peg$literalExpectation("blob", true);
  var peg$e19 = peg$literalExpectation("clob", true);
  var peg$e20 = peg$literalExpectation("nclob", true);
  var peg$e21 = peg$literalExpectation("bfile", true);
  var peg$e22 = peg$classExpectation([["0", "9"]], false, false);
  var peg$e23 = peg$classExpectation([["a", "z"], ["A", "Z"]], false, false);
  var peg$e24 = peg$classExpectation([" ", "\t", "\n", "\r"], false, false);

  var peg$f0 = function(name, x, xs) { return { op: "create", object: "table", columns: [x, ...(xs.map(col => col[3]))] }; };
  var peg$f1 = function(name, type) { return { name, type }; };
  var peg$f2 = function(type, size) { return { type, size }; };
  var peg$f3 = function(size) { return { size, character_semantics: "byte" } };
  var peg$f4 = function(size) { return { size, character_semantics: "char" } };
  var peg$f5 = function() { return "char"; };
  var peg$f6 = function() { return "varchar2"; };
  var peg$f7 = function(type, size) { return { type, size }; };
  var peg$f8 = function(size) { return { size, character_semantics: null } };
  var peg$f9 = function() { return "nchar"; };
  var peg$f10 = function() { return "nvarchar2"; };
  var peg$f11 = function() { return { type: "binary_float" }; };
  var peg$f12 = function() { return { type: "binary_double" }; };
  var peg$f13 = function(p) { return p };
  var peg$f14 = function(precision) {
            return { type: "float", precision }; 
        };
  var peg$f15 = function(p, s) { return s };
  var peg$f16 = function(p, s) { return { p, s } };
  var peg$f17 = function(precision) {
            return { type: "number", precision: precision?.p, scale: precision?.s  }; 
        };
  var peg$f18 = function() { return { type: "long raw" }; };
  var peg$f19 = function() { return { type: "long" }; };
  var peg$f20 = function(size) { return { type: "raw", size }; };
  var peg$f21 = function(type) { return { type }; };
  var peg$f22 = function(digits) { return digits.join("");};
  var peg$f23 = function(chars) { return chars.join(""); };
  var peg$currPos = options.peg$currPos | 0;
  var peg$savedPos = peg$currPos;
  var peg$posDetailsCache = [{ line: 1, column: 1 }];
  var peg$maxFailPos = peg$currPos;
  var peg$maxFailExpected = options.peg$maxFailExpected || [];
  var peg$silentFails = options.peg$silentFails | 0;

  var peg$result;

  if (options.startRule) {
    if (!(options.startRule in peg$startRuleFunctions)) {
      throw new Error("Can't start parsing from rule \"" + options.startRule + "\".");
    }

    peg$startRuleFunction = peg$startRuleFunctions[options.startRule];
  }

  function text() {
    return input.substring(peg$savedPos, peg$currPos);
  }

  function offset() {
    return peg$savedPos;
  }

  function range() {
    return {
      source: peg$source,
      start: peg$savedPos,
      end: peg$currPos
    };
  }

  function location() {
    return peg$computeLocation(peg$savedPos, peg$currPos);
  }

  function expected(description, location) {
    location = location !== undefined
      ? location
      : peg$computeLocation(peg$savedPos, peg$currPos);

    throw peg$buildStructuredError(
      [peg$otherExpectation(description)],
      input.substring(peg$savedPos, peg$currPos),
      location
    );
  }

  function error(message, location) {
    location = location !== undefined
      ? location
      : peg$computeLocation(peg$savedPos, peg$currPos);

    throw peg$buildSimpleError(message, location);
  }

  function peg$literalExpectation(text, ignoreCase) {
    return { type: "literal", text: text, ignoreCase: ignoreCase };
  }

  function peg$classExpectation(parts, inverted, ignoreCase) {
    return { type: "class", parts: parts, inverted: inverted, ignoreCase: ignoreCase };
  }

  function peg$anyExpectation() {
    return { type: "any" };
  }

  function peg$endExpectation() {
    return { type: "end" };
  }

  function peg$otherExpectation(description) {
    return { type: "other", description: description };
  }

  function peg$computePosDetails(pos) {
    var details = peg$posDetailsCache[pos];
    var p;

    if (details) {
      return details;
    } else {
      if (pos >= peg$posDetailsCache.length) {
        p = peg$posDetailsCache.length - 1;
      } else {
        p = pos;
        while (!peg$posDetailsCache[--p]) {}
      }

      details = peg$posDetailsCache[p];
      details = {
        line: details.line,
        column: details.column
      };

      while (p < pos) {
        if (input.charCodeAt(p) === 10) {
          details.line++;
          details.column = 1;
        } else {
          details.column++;
        }

        p++;
      }

      peg$posDetailsCache[pos] = details;

      return details;
    }
  }

  function peg$computeLocation(startPos, endPos, offset) {
    var startPosDetails = peg$computePosDetails(startPos);
    var endPosDetails = peg$computePosDetails(endPos);

    var res = {
      source: peg$source,
      start: {
        offset: startPos,
        line: startPosDetails.line,
        column: startPosDetails.column
      },
      end: {
        offset: endPos,
        line: endPosDetails.line,
        column: endPosDetails.column
      }
    };
    if (offset && peg$source && (typeof peg$source.offset === "function")) {
      res.start = peg$source.offset(res.start);
      res.end = peg$source.offset(res.end);
    }
    return res;
  }

  function peg$fail(expected) {
    if (peg$currPos < peg$maxFailPos) { return; }

    if (peg$currPos > peg$maxFailPos) {
      peg$maxFailPos = peg$currPos;
      peg$maxFailExpected = [];
    }

    peg$maxFailExpected.push(expected);
  }

  function peg$buildSimpleError(message, location) {
    return new peg$SyntaxError(message, null, null, location);
  }

  function peg$buildStructuredError(expected, found, location) {
    return new peg$SyntaxError(
      peg$SyntaxError.buildMessage(expected, found),
      expected,
      found,
      location
    );
  }

  function peg$parsestart() {
    var s0;

    s0 = peg$parsecreate_table_stmt();

    return s0;
  }

  function peg$parsecreate_table_stmt() {
    var s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16;

    s0 = peg$currPos;
    s1 = peg$parse_();
    s2 = input.substr(peg$currPos, 6);
    if (s2.toLowerCase() === peg$c0) {
      peg$currPos += 6;
    } else {
      s2 = peg$FAILED;
      if (peg$silentFails === 0) { peg$fail(peg$e0); }
    }
    if (s2 !== peg$FAILED) {
      s3 = peg$parse_();
      s4 = input.substr(peg$currPos, 5);
      if (s4.toLowerCase() === peg$c1) {
        peg$currPos += 5;
      } else {
        s4 = peg$FAILED;
        if (peg$silentFails === 0) { peg$fail(peg$e1); }
      }
      if (s4 !== peg$FAILED) {
        s5 = peg$parse_();
        s6 = peg$parseidentifier_name();
        if (s6 !== peg$FAILED) {
          s7 = peg$parse_();
          if (input.charCodeAt(peg$currPos) === 40) {
            s8 = peg$c2;
            peg$currPos++;
          } else {
            s8 = peg$FAILED;
            if (peg$silentFails === 0) { peg$fail(peg$e2); }
          }
          if (s8 !== peg$FAILED) {
            s9 = peg$parse_();
            s10 = peg$parsecolumn_definition();
            if (s10 !== peg$FAILED) {
              s11 = [];
              s12 = peg$currPos;
              s13 = peg$parse_();
              if (input.charCodeAt(peg$currPos) === 44) {
                s14 = peg$c3;
                peg$currPos++;
              } else {
                s14 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$e3); }
              }
              if (s14 !== peg$FAILED) {
                s15 = peg$parse_();
                s16 = peg$parsecolumn_definition();
                if (s16 !== peg$FAILED) {
                  s13 = [s13, s14, s15, s16];
                  s12 = s13;
                } else {
                  peg$currPos = s12;
                  s12 = peg$FAILED;
                }
              } else {
                peg$currPos = s12;
                s12 = peg$FAILED;
              }
              while (s12 !== peg$FAILED) {
                s11.push(s12);
                s12 = peg$currPos;
                s13 = peg$parse_();
                if (input.charCodeAt(peg$currPos) === 44) {
                  s14 = peg$c3;
                  peg$currPos++;
                } else {
                  s14 = peg$FAILED;
                  if (peg$silentFails === 0) { peg$fail(peg$e3); }
                }
                if (s14 !== peg$FAILED) {
                  s15 = peg$parse_();
                  s16 = peg$parsecolumn_definition();
                  if (s16 !== peg$FAILED) {
                    s13 = [s13, s14, s15, s16];
                    s12 = s13;
                  } else {
                    peg$currPos = s12;
                    s12 = peg$FAILED;
                  }
                } else {
                  peg$currPos = s12;
                  s12 = peg$FAILED;
                }
              }
              s12 = peg$parse_();
              if (input.charCodeAt(peg$currPos) === 41) {
                s13 = peg$c4;
                peg$currPos++;
              } else {
                s13 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$e4); }
              }
              if (s13 !== peg$FAILED) {
                s14 = peg$parse_();
                if (input.charCodeAt(peg$currPos) === 59) {
                  s15 = peg$c5;
                  peg$currPos++;
                } else {
                  s15 = peg$FAILED;
                  if (peg$silentFails === 0) { peg$fail(peg$e5); }
                }
                if (s15 !== peg$FAILED) {
                  peg$savedPos = s0;
                  s0 = peg$f0(s6, s10, s11);
                } else {
                  peg$currPos = s0;
                  s0 = peg$FAILED;
                }
              } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
              }
            } else {
              peg$currPos = s0;
              s0 = peg$FAILED;
            }
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    return s0;
  }

  function peg$parsecolumn_definition() {
    var s0, s1, s2, s3, s4;

    s0 = peg$currPos;
    s1 = peg$parse_();
    s2 = peg$parseidentifier_name();
    if (s2 !== peg$FAILED) {
      s3 = peg$parse_();
      s4 = peg$parseoracle_built_in_data_type();
      if (s4 !== peg$FAILED) {
        peg$savedPos = s0;
        s0 = peg$f1(s2, s4);
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    return s0;
  }

  function peg$parseoracle_built_in_data_type() {
    var s0;

    s0 = peg$parsecharacter_data_type();
    if (s0 === peg$FAILED) {
      s0 = peg$parsenumber_data_type();
      if (s0 === peg$FAILED) {
        s0 = peg$parselong_and_raw_data_type();
        if (s0 === peg$FAILED) {
          s0 = peg$parselarge_object_data_type();
        }
      }
    }

    return s0;
  }

  function peg$parsecharacter_data_type() {
    var s0;

    s0 = peg$parsecharacter_data_type_with_semantics();
    if (s0 === peg$FAILED) {
      s0 = peg$parsecharacter_data_type_without_semantics();
    }

    return s0;
  }

  function peg$parsecharacter_data_type_with_semantics() {
    var s0, s1, s2, s3, s4, s5, s6, s7;

    s0 = peg$currPos;
    s1 = peg$parsecharacter_data_type_type_with_semantics();
    if (s1 !== peg$FAILED) {
      s2 = peg$parse_();
      if (input.charCodeAt(peg$currPos) === 40) {
        s3 = peg$c2;
        peg$currPos++;
      } else {
        s3 = peg$FAILED;
        if (peg$silentFails === 0) { peg$fail(peg$e2); }
      }
      if (s3 !== peg$FAILED) {
        s4 = peg$parse_();
        s5 = peg$parsecharacter_data_type_size_with_semantics();
        if (s5 !== peg$FAILED) {
          s6 = peg$parse_();
          if (input.charCodeAt(peg$currPos) === 41) {
            s7 = peg$c4;
            peg$currPos++;
          } else {
            s7 = peg$FAILED;
            if (peg$silentFails === 0) { peg$fail(peg$e4); }
          }
          if (s7 !== peg$FAILED) {
            peg$savedPos = s0;
            s0 = peg$f2(s1, s5);
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    return s0;
  }

  function peg$parsecharacter_data_type_size_with_semantics() {
    var s0, s1, s2, s3;

    s0 = peg$currPos;
    s1 = peg$parseinteger();
    if (s1 !== peg$FAILED) {
      s2 = peg$parse_();
      s3 = input.substr(peg$currPos, 4);
      if (s3.toLowerCase() === peg$c6) {
        peg$currPos += 4;
      } else {
        s3 = peg$FAILED;
        if (peg$silentFails === 0) { peg$fail(peg$e6); }
      }
      if (s3 !== peg$FAILED) {
        peg$savedPos = s0;
        s0 = peg$f3(s1);
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }
    if (s0 === peg$FAILED) {
      s0 = peg$currPos;
      s1 = peg$parseinteger();
      if (s1 !== peg$FAILED) {
        s2 = peg$parse_();
        s3 = input.substr(peg$currPos, 4);
        if (s3.toLowerCase() === peg$c7) {
          peg$currPos += 4;
        } else {
          s3 = peg$FAILED;
          if (peg$silentFails === 0) { peg$fail(peg$e7); }
        }
        if (s3 !== peg$FAILED) {
          peg$savedPos = s0;
          s0 = peg$f4(s1);
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    }

    return s0;
  }

  function peg$parsecharacter_data_type_type_with_semantics() {
    var s0, s1;

    s0 = peg$currPos;
    s1 = input.substr(peg$currPos, 4);
    if (s1.toLowerCase() === peg$c7) {
      peg$currPos += 4;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) { peg$fail(peg$e7); }
    }
    if (s1 !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$f5();
    }
    s0 = s1;
    if (s0 === peg$FAILED) {
      s0 = peg$currPos;
      s1 = input.substr(peg$currPos, 8);
      if (s1.toLowerCase() === peg$c8) {
        peg$currPos += 8;
      } else {
        s1 = peg$FAILED;
        if (peg$silentFails === 0) { peg$fail(peg$e8); }
      }
      if (s1 !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$f6();
      }
      s0 = s1;
    }

    return s0;
  }

  function peg$parsecharacter_data_type_without_semantics() {
    var s0, s1, s2, s3, s4, s5, s6, s7;

    s0 = peg$currPos;
    s1 = peg$parsecharacter_data_type_type_without_semantics();
    if (s1 !== peg$FAILED) {
      s2 = peg$parse_();
      if (input.charCodeAt(peg$currPos) === 40) {
        s3 = peg$c2;
        peg$currPos++;
      } else {
        s3 = peg$FAILED;
        if (peg$silentFails === 0) { peg$fail(peg$e2); }
      }
      if (s3 !== peg$FAILED) {
        s4 = peg$parse_();
        s5 = peg$parsecharacter_data_type_size_without_semantics();
        if (s5 !== peg$FAILED) {
          s6 = peg$parse_();
          if (input.charCodeAt(peg$currPos) === 41) {
            s7 = peg$c4;
            peg$currPos++;
          } else {
            s7 = peg$FAILED;
            if (peg$silentFails === 0) { peg$fail(peg$e4); }
          }
          if (s7 !== peg$FAILED) {
            peg$savedPos = s0;
            s0 = peg$f7(s1, s5);
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    return s0;
  }

  function peg$parsecharacter_data_type_size_without_semantics() {
    var s0, s1;

    s0 = peg$currPos;
    s1 = peg$parseinteger();
    if (s1 !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$f8(s1);
    }
    s0 = s1;

    return s0;
  }

  function peg$parsecharacter_data_type_type_without_semantics() {
    var s0, s1;

    s0 = peg$currPos;
    s1 = input.substr(peg$currPos, 5);
    if (s1.toLowerCase() === peg$c9) {
      peg$currPos += 5;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) { peg$fail(peg$e9); }
    }
    if (s1 !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$f9();
    }
    s0 = s1;
    if (s0 === peg$FAILED) {
      s0 = peg$currPos;
      s1 = input.substr(peg$currPos, 9);
      if (s1.toLowerCase() === peg$c10) {
        peg$currPos += 9;
      } else {
        s1 = peg$FAILED;
        if (peg$silentFails === 0) { peg$fail(peg$e10); }
      }
      if (s1 !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$f10();
      }
      s0 = s1;
    }

    return s0;
  }

  function peg$parsenumber_data_type() {
    var s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11;

    s0 = peg$currPos;
    s1 = input.substr(peg$currPos, 12);
    if (s1.toLowerCase() === peg$c11) {
      peg$currPos += 12;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) { peg$fail(peg$e11); }
    }
    if (s1 !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$f11();
    }
    s0 = s1;
    if (s0 === peg$FAILED) {
      s0 = peg$currPos;
      s1 = input.substr(peg$currPos, 13);
      if (s1.toLowerCase() === peg$c12) {
        peg$currPos += 13;
      } else {
        s1 = peg$FAILED;
        if (peg$silentFails === 0) { peg$fail(peg$e12); }
      }
      if (s1 !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$f12();
      }
      s0 = s1;
      if (s0 === peg$FAILED) {
        s0 = peg$currPos;
        s1 = input.substr(peg$currPos, 5);
        if (s1.toLowerCase() === peg$c13) {
          peg$currPos += 5;
        } else {
          s1 = peg$FAILED;
          if (peg$silentFails === 0) { peg$fail(peg$e13); }
        }
        if (s1 !== peg$FAILED) {
          s2 = peg$parse_();
          s3 = peg$currPos;
          if (input.charCodeAt(peg$currPos) === 40) {
            s4 = peg$c2;
            peg$currPos++;
          } else {
            s4 = peg$FAILED;
            if (peg$silentFails === 0) { peg$fail(peg$e2); }
          }
          if (s4 !== peg$FAILED) {
            s5 = peg$parse_();
            s6 = peg$parseinteger();
            if (s6 !== peg$FAILED) {
              s7 = peg$parse_();
              if (input.charCodeAt(peg$currPos) === 41) {
                s8 = peg$c4;
                peg$currPos++;
              } else {
                s8 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$e4); }
              }
              if (s8 !== peg$FAILED) {
                peg$savedPos = s3;
                s3 = peg$f13(s6);
              } else {
                peg$currPos = s3;
                s3 = peg$FAILED;
              }
            } else {
              peg$currPos = s3;
              s3 = peg$FAILED;
            }
          } else {
            peg$currPos = s3;
            s3 = peg$FAILED;
          }
          if (s3 === peg$FAILED) {
            s3 = null;
          }
          peg$savedPos = s0;
          s0 = peg$f14(s3);
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
        if (s0 === peg$FAILED) {
          s0 = peg$currPos;
          s1 = input.substr(peg$currPos, 6);
          if (s1.toLowerCase() === peg$c14) {
            peg$currPos += 6;
          } else {
            s1 = peg$FAILED;
            if (peg$silentFails === 0) { peg$fail(peg$e14); }
          }
          if (s1 !== peg$FAILED) {
            s2 = peg$parse_();
            s3 = peg$currPos;
            if (input.charCodeAt(peg$currPos) === 40) {
              s4 = peg$c2;
              peg$currPos++;
            } else {
              s4 = peg$FAILED;
              if (peg$silentFails === 0) { peg$fail(peg$e2); }
            }
            if (s4 !== peg$FAILED) {
              s5 = peg$parse_();
              s6 = peg$parseinteger();
              if (s6 !== peg$FAILED) {
                s7 = peg$parse_();
                s8 = peg$currPos;
                if (input.charCodeAt(peg$currPos) === 44) {
                  s9 = peg$c3;
                  peg$currPos++;
                } else {
                  s9 = peg$FAILED;
                  if (peg$silentFails === 0) { peg$fail(peg$e3); }
                }
                if (s9 !== peg$FAILED) {
                  s10 = peg$parse_();
                  s11 = peg$parseinteger();
                  if (s11 !== peg$FAILED) {
                    peg$savedPos = s8;
                    s8 = peg$f15(s6, s11);
                  } else {
                    peg$currPos = s8;
                    s8 = peg$FAILED;
                  }
                } else {
                  peg$currPos = s8;
                  s8 = peg$FAILED;
                }
                if (s8 === peg$FAILED) {
                  s8 = null;
                }
                s9 = peg$parse_();
                if (input.charCodeAt(peg$currPos) === 41) {
                  s10 = peg$c4;
                  peg$currPos++;
                } else {
                  s10 = peg$FAILED;
                  if (peg$silentFails === 0) { peg$fail(peg$e4); }
                }
                if (s10 !== peg$FAILED) {
                  peg$savedPos = s3;
                  s3 = peg$f16(s6, s8);
                } else {
                  peg$currPos = s3;
                  s3 = peg$FAILED;
                }
              } else {
                peg$currPos = s3;
                s3 = peg$FAILED;
              }
            } else {
              peg$currPos = s3;
              s3 = peg$FAILED;
            }
            if (s3 === peg$FAILED) {
              s3 = null;
            }
            peg$savedPos = s0;
            s0 = peg$f17(s3);
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        }
      }
    }

    return s0;
  }

  function peg$parselong_and_raw_data_type() {
    var s0, s1, s2, s3, s4, s5, s6, s7;

    s0 = peg$currPos;
    s1 = input.substr(peg$currPos, 8);
    if (s1.toLowerCase() === peg$c15) {
      peg$currPos += 8;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) { peg$fail(peg$e15); }
    }
    if (s1 !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$f18();
    }
    s0 = s1;
    if (s0 === peg$FAILED) {
      s0 = peg$currPos;
      s1 = input.substr(peg$currPos, 4);
      if (s1.toLowerCase() === peg$c16) {
        peg$currPos += 4;
      } else {
        s1 = peg$FAILED;
        if (peg$silentFails === 0) { peg$fail(peg$e16); }
      }
      if (s1 !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$f19();
      }
      s0 = s1;
      if (s0 === peg$FAILED) {
        s0 = peg$currPos;
        s1 = input.substr(peg$currPos, 3);
        if (s1.toLowerCase() === peg$c17) {
          peg$currPos += 3;
        } else {
          s1 = peg$FAILED;
          if (peg$silentFails === 0) { peg$fail(peg$e17); }
        }
        if (s1 !== peg$FAILED) {
          s2 = peg$parse_();
          if (input.charCodeAt(peg$currPos) === 40) {
            s3 = peg$c2;
            peg$currPos++;
          } else {
            s3 = peg$FAILED;
            if (peg$silentFails === 0) { peg$fail(peg$e2); }
          }
          if (s3 !== peg$FAILED) {
            s4 = peg$parse_();
            s5 = peg$parseinteger();
            if (s5 !== peg$FAILED) {
              s6 = peg$parse_();
              if (input.charCodeAt(peg$currPos) === 41) {
                s7 = peg$c4;
                peg$currPos++;
              } else {
                s7 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$e4); }
              }
              if (s7 !== peg$FAILED) {
                peg$savedPos = s0;
                s0 = peg$f20(s5);
              } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
              }
            } else {
              peg$currPos = s0;
              s0 = peg$FAILED;
            }
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      }
    }

    return s0;
  }

  function peg$parselarge_object_data_type() {
    var s0, s1;

    s0 = peg$currPos;
    s1 = input.substr(peg$currPos, 4);
    if (s1.toLowerCase() === peg$c18) {
      peg$currPos += 4;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) { peg$fail(peg$e18); }
    }
    if (s1 === peg$FAILED) {
      s1 = input.substr(peg$currPos, 4);
      if (s1.toLowerCase() === peg$c19) {
        peg$currPos += 4;
      } else {
        s1 = peg$FAILED;
        if (peg$silentFails === 0) { peg$fail(peg$e19); }
      }
      if (s1 === peg$FAILED) {
        s1 = input.substr(peg$currPos, 5);
        if (s1.toLowerCase() === peg$c20) {
          peg$currPos += 5;
        } else {
          s1 = peg$FAILED;
          if (peg$silentFails === 0) { peg$fail(peg$e20); }
        }
        if (s1 === peg$FAILED) {
          s1 = input.substr(peg$currPos, 5);
          if (s1.toLowerCase() === peg$c21) {
            peg$currPos += 5;
          } else {
            s1 = peg$FAILED;
            if (peg$silentFails === 0) { peg$fail(peg$e21); }
          }
        }
      }
    }
    if (s1 !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$f21(s1);
    }
    s0 = s1;

    return s0;
  }

  function peg$parseinteger() {
    var s0, s1, s2;

    s0 = peg$currPos;
    s1 = [];
    s2 = input.charAt(peg$currPos);
    if (peg$r0.test(s2)) {
      peg$currPos++;
    } else {
      s2 = peg$FAILED;
      if (peg$silentFails === 0) { peg$fail(peg$e22); }
    }
    if (s2 !== peg$FAILED) {
      while (s2 !== peg$FAILED) {
        s1.push(s2);
        s2 = input.charAt(peg$currPos);
        if (peg$r0.test(s2)) {
          peg$currPos++;
        } else {
          s2 = peg$FAILED;
          if (peg$silentFails === 0) { peg$fail(peg$e22); }
        }
      }
    } else {
      s1 = peg$FAILED;
    }
    if (s1 !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$f22(s1);
    }
    s0 = s1;

    return s0;
  }

  function peg$parseidentifier_name() {
    var s0, s1, s2;

    s0 = peg$currPos;
    s1 = [];
    s2 = input.charAt(peg$currPos);
    if (peg$r1.test(s2)) {
      peg$currPos++;
    } else {
      s2 = peg$FAILED;
      if (peg$silentFails === 0) { peg$fail(peg$e23); }
    }
    if (s2 !== peg$FAILED) {
      while (s2 !== peg$FAILED) {
        s1.push(s2);
        s2 = input.charAt(peg$currPos);
        if (peg$r1.test(s2)) {
          peg$currPos++;
        } else {
          s2 = peg$FAILED;
          if (peg$silentFails === 0) { peg$fail(peg$e23); }
        }
      }
    } else {
      s1 = peg$FAILED;
    }
    if (s1 !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$f23(s1);
    }
    s0 = s1;

    return s0;
  }

  function peg$parse_() {
    var s0, s1;

    s0 = [];
    s1 = input.charAt(peg$currPos);
    if (peg$r2.test(s1)) {
      peg$currPos++;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) { peg$fail(peg$e24); }
    }
    while (s1 !== peg$FAILED) {
      s0.push(s1);
      s1 = input.charAt(peg$currPos);
      if (peg$r2.test(s1)) {
        peg$currPos++;
      } else {
        s1 = peg$FAILED;
        if (peg$silentFails === 0) { peg$fail(peg$e24); }
      }
    }

    return s0;
  }

  peg$result = peg$startRuleFunction();

  if (options.peg$library) {
    return /** @type {any} */ ({
      peg$result,
      peg$currPos,
      peg$FAILED,
      peg$maxFailExpected,
      peg$maxFailPos
    });
  }
  if (peg$result !== peg$FAILED && peg$currPos === input.length) {
    return peg$result;
  } else {
    if (peg$result !== peg$FAILED && peg$currPos < input.length) {
      peg$fail(peg$endExpectation());
    }

    throw peg$buildStructuredError(
      peg$maxFailExpected,
      peg$maxFailPos < input.length ? input.charAt(peg$maxFailPos) : null,
      peg$maxFailPos < input.length
        ? peg$computeLocation(peg$maxFailPos, peg$maxFailPos + 1)
        : peg$computeLocation(peg$maxFailPos, peg$maxFailPos)
    );
  }
}

module.exports = {
  StartRules: ["start"],
  SyntaxError: peg$SyntaxError,
  parse: peg$parse
};
