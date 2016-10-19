### Licensed to the Apache Software Foundation (ASF) under one or more contributor license agreements.  See the NOTICE file distributed with this work for additional information regarding copyright ownership.  The ASF licenses this file to you under the Apache License, Version 2.0 (the 'License'); you may not use this file except in compliance with the License.  You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the specific language governing permissions and limitations under the License.###

compression = require('compression')
favicon = require('serve-favicon')
express = require('express')
assets = require("connect-assets")
path = require('path')
bodyParser = require('body-parser')
chalk = require('chalk')

class CordovaServe
        constructor: (conf) ->
                @app = express()

                #logger
                @app.use (req, res, next) ->
                        res.on 'finish', ->
                                color = if @statusCode is '404' then chalk.red else chalk.green
                                msg = color(@statusCode) + ' ' + @req.originalUrl;
                                encoding = @._headers && @._headers['content-encoding']
                                if encoding
                                        msg += chalk.gray(' (' + encoding + ')')
                                        console.log(msg)
                        next()

                # html engine
                @app.set "view engine", conf["view engine"]

                @app.set "views", path.join(__dirname, conf.root, conf["views"])
                
                # comprime html
                @app.use compression()
                
                #favicon
                @app.use favicon path.join(__dirname, conf.root, conf["favicon"])

                # assets
                # compila *.scss e *.coffeescript para index.css e demais javascripts
                paths = paths: (path.join(__dirname, conf.root,v) for v in conf["assets"])
                @app.use assets(paths)

                # JSON parser
                @app.use bodyParser.json()

                # Urls codificadas
                @app.use bodyParser.urlencoded(extended: false)

                # pasta public
                @app.use express.static path.join(__dirname, conf.root, conf["public"])

                #Rotas
                @app.use require path.join(__dirname, conf.root, conf["routes"]) 

CordovaServe.prototype[k] = require(path.join(__dirname,v)) for k,v of {'servePlatform': 'src/platform', 'launchServer':  'src/server', 'launchBrowser': 'src/browser'}

module.exports = (conf) -> new CordovaServe conf

