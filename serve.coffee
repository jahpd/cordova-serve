### Licensed to the Apache Software Foundation (ASF) under one or more contributor license agreements.  See the NOTICE file distributed with this work for additional information regarding copyright ownership.  The ASF licenses this file to you under the Apache License, Version 2.0 (the 'License'); you may not use this file except in compliance with the License.  You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the specific language governing permissions and limitations under the License.###

compression = require('compression')
favicon = require('serve-favicon')
express = require('express')
assets = require("connect-assets")
path = require('path')
bodyParser = require('body-parser')
logger = require('./src/logger')

class CordovaServe
        constructor: (conf) ->
                @app = express()
                        
                #Pug templates
                @app.set 'view engine', 'pug'
                @app.set "#{k} path", path.join(__dirname, v) for k,v of a for a of conf.public
                @app.set "#{k}",      path.join(__dirname, v) for k,v of a for a of conf.server

                # rotas e endpoints internos
                @app.use(require(@app.get('cordova routes')))	 # hack this file with scrpts/routes.js
                
                #favicon
                @app.use(favicon(@app.get('favicon path')))

                #logger
                @app.use(logger())

                # comprime html
                @app.use(compression())

                # JSON parser
                @app.use(bodyParser.json())

                # Urls codificadas
                @app.use(bodyParser.urlencoded({ extended: false }))

                # compila *.scss e *.coffeescript para index.css e demais javascripts
                @app.use(assets(paths:@app.get "#{s} path" for s in ["css","js","img","public"]))

                # pasta public
                @app.use express.static(@app.get('public path'))

CordovaServe.prototype[k] = require(path.join(__dirname,v)) for k,v of {'servePlatform': 'src/platform', 'launchServer':  'src/server', 'launchBrowser': 'src/browser'}

module.exports = (conf) -> new CordovaServe conf

