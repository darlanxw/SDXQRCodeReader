var exec = require('cordova/exec');
var SDXQRCodeReader = function () { }; 

SDXQRCodeReader.scanQRCode = function (onSuccess, onError) {
    alert("Chegou no plgin JS");
    exec(function (param) {
        alert("Voltou do plugin nativo!");
        var sdxTransaction = JSON.parse(param);
        return onSuccess(sdxTransaction)
    }, onError, "SDXQRCodeReader", "scanQRCode", [null]);
};

module.exports = SDXQRCodeReader;