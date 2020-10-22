var exec = require('cordova/exec');
var SDXQRCodeReader = function () { }; 

SDXQRCodeReader.scanQRCode = function (onSuccess, onError) {
    exec(function (param) {
        alert("Chegou no retorno de sucesso!!");
        var sdxTransaction = JSON.parse(param);
        return onSuccess(sdxTransaction)
    }, onError, "SDXQRCodeReader", "scanQRCode", [null]);
};

module.exports = SDXQRCodeReader;