var exec = require('cordova/exec');
var SDXQRCodeReader = function () { }; 

SDXQRCodeReader.scanQRCode = function (onSuccess, onError) {
    exec(function (param) {
        try {
            var sdxTransaction = JSON.parse(param);
            alert ("Fez o parse!");            
            return onSuccess(sdxTransaction)
        } catch (error) {
            alert ("Caiu no catch!!");
            return onSuccess(param)
        }
    }, onError, "SDXQRCodeReader", "scanQRCode", [null]);
};

module.exports = SDXQRCodeReader;