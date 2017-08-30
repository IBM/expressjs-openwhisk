This project shows how to deploy new and existing Express.js applications to OpenWhisk. 
This tutorial takes less then 5 minutes to complete. 

# Prerequisite

- Apache OpenWhisk
- node.js
- Bluemix account

# Steps

1. Create new Express.js application
1. Change relative paths 
1. Create OpenWhisk action
1. Deploy application
1. Test application


## 1. Create new Express.js application

Open a terminal, and type

```bash
$ npm install express-generator -g
$ express --view=pug myexpressapp
$ cd myexpressapp
$ npm install 
```

This creates a minimal Express.js application. 
To check it is working, start the application by typing the command 
`npm start` and load [http://localhost:3000]() in a browser.


## 2. Change relative paths
 
The generated Express.s application expects resources to be installed 
in the domain root folder but by default Apache OpenWhisk web actions are 
served from a sub-directory. 

Change `views/layout.pug`:

```jade
doctype html
html
  head
    title= title
    if baseurl
      base(href=baseurl)
    link(rel='stylesheet', href='stylesheets/style.css')
  body
    block content
```

## 3. Create OpenWhisk action

Add `expressjs-openwhisk` module dependency in your project.

```bash
$ npm install expressjs-openwhisk --save
```

Then create the Apache OpenWhisk action handling Web requests by forwarding 
them to `expressjs-openwhisk`. Create a file named `action.js` with this content:

```
const app = require('./app');
const forward = require('expressjs-openwhisk')(app);

function main(request) {
  return forward(request);
}

exports.main = main;
```

In `package.json`, add the following entry:

```json
{
   "main": "action.js",
   ...
}
```

## 4. Deploy application

To deploy the application and dependencies on Bluemix, do:

```bash
$ zip -r app.zip .
$ wsk action update express app.zip --kind nodejs:6 --web raw \
    -p baseurl https://openwhisk.ng.bluemix.net/api/v1/web/<org>_<space>/default/express/
```

Replace `<org>` and `<space>` by your Bluemix organization and space, respectively. 

## 5. Test application

And finally test the application by opening
`https://openwhisk.ng.bluemix.net/api/v1/web/<org>_<space>/default/express`
in a browser

# License

[Apache 2.0](LICENSE.txt)
