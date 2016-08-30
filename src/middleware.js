cookieParser = require('cookie-parser');
bodyParser = require('body-parser');
sass = require('node-sass-middleware');

module.exports = function(app, options){
    
    if(options.views){
	app.set('views', options.views.path);
	app.set('view engine', options.views.engine);
    }
    if(options.bodyParser){
	if(options.bodyParser.json){
	    app.use(bodyParser.json());
	}
	if(options.bodyParser.urlencoded){
	    app.use(bodyParser.urlencoded(options.bodyParser.urlencoded));
	}
    }

    if(options.cookieParser){
	app.use(cookieParser());
    }

    if(options.sass){
	app.use(sass(options.sass));
    }

    if(options.routes){
	for(var method in options.routes){
	    for(var action in options.routes[method]){
		var endpoint = options.routes[method][action]
		app[method](endpoint.path, endpoint.fn);
	    }
	}
    }
}
