var exec = require('cordova/exec');
var SDXQRCodeReader = function () { }; 

SDXQRCodeReader.scanQRCode = function (arg0, onSuccess, onError) {
    exec(onSuccess, onError, "SDXQRCodeReader", "scanQRCode", [arg0]);
};
module.exports = SDXQRCodeReader;