var chalk = require('chalk');

module.exports = function (req, res, next) {
    res.on('finish', function () {
        var color = this.statusCode == '404' ? chalk.red : chalk.green;
        var msg = color(this.statusCode) + ' ' + this.req.originalUrl;
        var encoding = this._headers && this._headers['content-encoding'];
        if (encoding) {
            msg += chalk.gray(' (' + encoding + ')');
        }
        console.log(msg);
    });
    next();
};
