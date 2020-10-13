package com.sdx.qrcodereader;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class SDXQRCodeReader extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("scanQRCode")) {
            this.scanQRCode(callbackContext);
            return true;
        }
        return false;
    }

    private void scanQRCode(CallbackContext callbackContext) {
        callbackContext.success("Chegou!");
    }
}
