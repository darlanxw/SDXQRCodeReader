var exec = require('cordova/exec');
var SDXQRCodeReader = function () { }; 

SDXQRCodeReader.scanQRCode = function (onSuccess, onError) {
    exec(function (param) {
        try {
            var sdxTransaction = JSON.parse(param);         
            return onSuccess(sdxTransaction)
        } catch (error) {
            return onSuccess(param)
        }
    }, onError, "SDXQRCodeReader", "scanQRCode", [null]);
};

module.exports = SDXQRCodeReader;