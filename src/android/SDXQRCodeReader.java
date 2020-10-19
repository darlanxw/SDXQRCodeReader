package com.sdx.qrcodereader;

import android.widget.Toast;
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
          JSONObject json = new JSONObject();
          json.put("merchantId", model.getMerchantId());
          json.put("merchantUserId", model.getMerchantUserId());
          json.put("city", model.getCity());
          json.put("country", model.getCountry());
          json.put("currency", model.getCurrency());
          if (model.getDateTime() != null) {
            json.put("dateTime", model.getDateTime());
          }
          if (model.getMerchantBranchCode() != null) {
            json.put("merchantBranchCode", model.getMerchantBranchCode());
          }
          if (model.getTransactionId() != null) {
            json.put("transactionId", model.getTransactionId());
          }
          json.put("dateTime", model.getDateTime());
          if (model.getTip() != null) {
            json.put("tip", model.getTip());
          }
          if (model.getTransactionAmount() != null) {
            json.put("transactionAmount", model.getTransactionAmount());
          }
          cordova.getActivity().finish();
          callbackContext.success(json);
          cordova.getActivity().runOnUiThread(new Runnable() {
            @Override public void run() {
              Toast.makeText(cordova.getContext(), json.toString(), Toast.LENGTH_SHORT).show();
            }
          });
        } catch (JSONException e) {
          callbackContext.error(e.getMessage());
        }
      }

      @Override public void error() {
        callbackContext.error("Error to handle");
      }
    });
    callbackContext.error("It was not possible to parse the data.");
  }
}