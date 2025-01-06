const parseFn = require('../../build/parser').parse;

class Parser {
    parse(sql) {
        return parseFn(sql);
    }
}

module.exports = Parser;