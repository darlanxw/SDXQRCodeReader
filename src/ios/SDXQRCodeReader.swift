//
//  SDXQRCodeReader.swift

import SDXPaymentConsumer

@objc(SDXQRCodeReader) class SDXQRCodeReader : CDVPlugin {
    
  var paymentConsumer: SDXPaymentConsumerInterface?
  var fullScannerView: UIView!
  var callbackId: String!
    
  @objc(scanQRCode:)
  func scanQRCode(_ command: CDVInvokedUrlCommand) {
    self.callbackId = command.callbackId
    paymentConsumer = SDXPaymentConsumerInterface(delegate: self)
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

extension SDXQRCodeReader: SDXPaymentConsumerDelegate {
    
    func didFoundPayload(payload: SDXPaymentConsumerPayload) {
        fullScannerView.isHidden = true
        
        let sdxTransaction = SDXTransaction(merchantName: payload.merchantName, merchantId: payload.merchantId, merchantUserId: payload.merchantUserId, merchantBranchCode: payload.merchantBranchCode, transactionValue: payload.transactionValue, transactionId: payload.transactionId, currency: payload.currency, dateTime: payload.dateTime, tip: payload.tip)
        
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
                messageAs: "It was not possible parse the data."
            )
            
            self.commandDelegate.send(result, callbackId: self.callbackId)
        }
        
       
    }
    
    func didFailToReadCode(error: SDXPaymentConsumerError) {
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
    var transactionValue: Double?
    var transactionId: String?
    var currency: String
    var dateTime: Date
    var tip: Double?
}
