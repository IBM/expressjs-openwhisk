
## Quick start

Add `expressjs-openwhisk` module dependency in your project.

```bash
$ npm install expressjs-openwhisk --save
```

Then create an OpenWhisk action handling Web requests by forwarding them to `expressjs-openwhisk`:

```
const app = require('./server');
const forward = require('openwhisk-expressjs')(app);

function main(request) {
  return forward(request);
}

exports.main = main;
```

To deploy this action and dependencies, do:
```bash
$ npm install
$ zip -r action.zip *
$ wsk action update <actionname> action.zip --kind nodejs:6 --web raw
```

