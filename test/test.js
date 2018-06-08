/*
 * Copyright 2017 IBM Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const assert = require('assert');
const express = require('express');
const bodyParser = require('body-parser')

const app = express();
app.use(bodyParser.json())

app.get('/', (req, res) => {
  res.send('hello');
});

app.post('/', (req, res) => {
  res.send(req.body);
});


app.put('/', (req, res) => {
  res.send(req.body);
});

app.patch('/', (req, res) => {
  res.send(req.body);
});

const forward = require('../index.js')(app);

describe('get', () => {
  describe('text', () => {
    it('should return hello', (done) => {
      forward({
        __ow_method: 'get',
        __ow_path: '/'
      }).then(res => {
        assert.equal('hello', res.body);
        done();
      });
    });
  });
});


describe('post', () => {
  describe('json', () => {
    it('should return e30=', (done) => {
      forward({
        __ow_method: 'post',
        __ow_path: '/',
        __ow_body:'{}'
      }).then(res => {
        assert.equal('e30=', res.body);
        done();
      });
    });
  });
});

describe('patch', () => {
  describe('json', () => {
    it('should return e30=', (done) => {
      forward({
        __ow_method: 'patch',
        __ow_path: '/',
        __ow_body:'{}'
      }).then(res => {
        assert.equal('e30=', res.body);
        done();
      });
    });
  });
});

describe('put', () => {
  describe('json', () => {
    it('should return e30=', (done) => {
      forward({
        __ow_method: 'put',
        __ow_path: '/',
        __ow_body:'{}'
      }).then(res => {
        assert.equal('e30=', res.body);
        done();
      });
    });
  });
});
