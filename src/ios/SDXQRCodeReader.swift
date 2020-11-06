//
//  SDXQRCodeReader.swift

import SDXQRCode

@objc(SDXQRCodeReader) class SDXQRCodeReader : CDVPlugin {
    
  var paymentConsumer: SDXQRCodeInterface?
  var fullScannerView: UIView!
  var callbackId: String!
    
  @objc(scanQRCode:)
  func scanQRCode(_ command: CDVInvokedUrlCommand) {
    self.callbackId = command.callbackId
    paymentConsumer = SDXQRCodeInterface(delegate: self)
    fullScannerView = UIView(frame: self.viewController.view.frame)
    self.viewController.view.addSubview(fullScannerView)
    
    let width = CGFloat(self.viewController.view.frame.width)
    let height = CGFloat(self.viewController.view.frame.height)
    
    fullScannerView.translatesAutoresizingMaskIntoConstraints = false
    fullScannerView.centerXAnchor.constraint(equalTo: self.viewController.view.centerXAnchor).isActive = true
    fullScannerView.centerYAnchor.constraint(equalTo: self.viewController.view.centerYAnchor).isActive = true
    fullScannerView.heightAnchor.constraint(equalToConstant: height).isActive = true
    fullScannerView.widthAnchor.constraint(equalToConstant: width).isActive = true
    
    paymentConsumer?.scan(inView: fullScannerView)
  }
}

extension SDXQRCodeReader: SDXQRCodeDelegate {
    
    func didFoundPayload(payload: SDXQRCodePayload) {
        fullScannerView.isHidden = true
        
        let sdxTransaction = SDXTransaction(merchantName: payload.merchantName, merchantId: payload.merchantId, merchantUserId: payload.merchantUserId, merchantBranchCode: payload.merchantBranchCode, nationalIdentifier: payload.nationalIdentifier ,transactionValue: payload.transactionValue, transactionId: payload.transactionId, currency: payload.currency, dateTime: "\(payload.dateTime)", tip: payload.fee)
        
        do {
            let data = try JSONEncoder().encode(sdxTransaction)
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            let result = CDVPluginResult(
              status: CDVCommandStatus_OK,
                messageAs: dataString
            )
            
            self.commandDelegate.send(result, callbackId: self.callbackId)
        } catch {
            let result = CDVPluginResult(
              status: CDVCommandStatus_ERROR,
                messageAs: "There was an error trying to open the camera."
            )
            
            self.commandDelegate.send(result, callbackId: self.callbackId)
        }
    }
    
    func didFailToReadCode(error: SDXQRCodeError) {
        fullScannerView.isHidden = true
        let result = CDVPluginResult(
          status: CDVCommandStatus_ERROR,
            messageAs: error.message
        )
        
        self.commandDelegate.send(result, callbackId: self.callbackId)
    }
}

func JSONStringify(value: AnyObject, prettyPrinted: Bool = true) -> String {
       let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : nil
       if JSONSerialization.isValidJSONObject(value) {
           do {
               let data = try JSONSerialization.data(withJSONObject: value, options: options!)
               if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                   return string as String
               }
           }  catch {
               return "It was not possible parse the data."
           }
       }
       return "It was not possible parse the data."
   }


struct SDXTransaction: Codable {
    var merchantName: String
    var merchantId: String
    var merchantUserId: String
    var merchantBranchCode: String?
    var nationalIdentifier: String?
    var transactionValue: String?
    var transactionId: String?
    var currency: String
    var dateTime: String
    var tip: String?
}