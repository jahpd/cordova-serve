/**
   Licensed to the Apache Software Foundation (ASF) under one
   or more contributor license agreements.  See the NOTICE file
   distributed with this work for additional information
   regarding copyright ownership.  The ASF licenses this file
   to you under the Apache License, Version 2.0 (the
   'License'); you may not use this file except in compliance
   with the License.  You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing,
   software distributed under the License is distributed on an
   'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
   KIND, either express or implied.  See the License for the
   specific language governing permissions and limitations
   under the License.
*/

var chalk = require('chalk'),
    compression = require('compression'),
    express = require('express'),
    middleware = require('./src/middleware'),
    path = require('path')


module.exports = function (opt, fn) {
    var server = new CordovaServe(opt);
    if(fn !== undefined){
	fn(server.app.Router);
    }
    return server
};

function CordovaServe(opt) {
    this.app = express();
    this.servePlatform = require('./src/platform');
    this.launchServer = require('./src/server');
    this.launchBrowser = require('./src/browser')

    // Attach this before anything else to provide status output
    this.app.use(function (req, res, next) {
        res.on('finish', function () {
            var color = this.statusCode == '404' ? chalk.red : chalk.green;
            var msg = color(this.statusCode) + ' ' + this.req.originalUrl;
            var encoding = this._headers && this._headers['content-encoding'];
            if (encoding) {
                msg += chalk.gray(' (' + encoding + ')');
            }
            server.log(msg);
        });
        next();
    });

    // Turn on compression
    this.app.use(compression());
    
    // Static path
    this.app.use(express["static"](path.join(__dirname, opt.public_folder)));

    // Pug and sass
    middleware(this.app, {
	views: this.views,
	bodyParser:{
	    json: true,
	    urlencoded:{
		extended: false
	    }
	},
	cookieParser: false,
	sass:{
	    src: this.sass.src,
	    dest: this.sass.dest,
	    indentedSyntax: true,
	    sourceMap: true,
	    debug: true,
	    outputStyle: 'compressed'
	},
    }); 
}

