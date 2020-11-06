package com.sdx.qrcodereader;

import android.widget.Toast;
import com.google.gson.Gson;
import com.sodexo.qrcodegenerator.SDXQRGenerator;
import com.sodexo.qrcodegenerator.SDXQrCodeListener;
import com.sodexo.qrcodegenerator.domain.SDXQRCodeTransaction;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class SDXQRCodeReader extends CordovaPlugin {

  @Override public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("scanQRCode")) {
      this.scanQRCode(callbackContext);
      return true;
    }
    return false;
  }

  private void scanQRCode(CallbackContext callbackContext) {
    new SDXQRGenerator().scan(cordova.getContext(), false, false, new SDXQrCodeListener() {
      @Override public void success(SDXQRCodeTransaction model) {
        try {
          String sdxTransactionValue = new Gson().toJson(model);
          JSONObject sdxTransctionObject = new JSONObject(sdxTransactionValue);
          callbackContext.success(sdxTransctionObject);
        } catch (JSONException e) {
          callbackContext.error("There was an error trying to open the camera.");
        }
      }

      @Override public void error() {
        callbackContext.error("It was not possible to parse the data.");
      }
    });
  }
}