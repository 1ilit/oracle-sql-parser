# oracle-sql-parser

Simple SQL parser and [AST explorer](https://1ilit.github.io/oracle-sql-parser/) for Oracle SQL following the [Oracle Database Language Reference](https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/index.html).

## Usage

#### Install the package:

```sh
npm i oracle-sql-parser
```

#### Parse and print:

```js
const { Parser } = require('oracle-sql-parser');

const parser = new Parser();

const sql = 'CREATE TABLE users (id integer);';
const ast = parser.parse(sql);

console.log(ast);
```

## Run locally

```sh
git clone https://github.com/1ilit/oracle-sql-parser.git
cd oracle-sql-parser
npm i
npm test
```

## Scripts

Generate the parser in `./build/parser.js`

```sh
npm run generate
```

Generate and minify the parser in `./build/parser.js`

```sh
npm run build
```