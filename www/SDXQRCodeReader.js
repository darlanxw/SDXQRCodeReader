var exec = require('cordova/exec');
var SDXQRCodeReader = function () { }; 

SDXQRCodeReader.scanQRCode = function (onSuccess, onError) {
    alert("Chegou no JS!!");
    exec(function (param) {
        var sdxTransaction = JSON.parse(param);
        return onSuccess(sdxTransaction)
    }, onError, "SDXQRCodeReader", "scanQRCode", [null]);
};

module.exports = SDXQRCodeReader;