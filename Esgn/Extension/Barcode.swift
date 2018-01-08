//
//  Barcode.swift
//  AppTaxiDriver
//
//  Created by Somsak Wongsinsakul on 7/17/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import CoreImage

class Barcode: NSObject {

    class func fromString(string : String) -> UIImage? {
        
        let data = string.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        return UIImage(ciImage: (filter?.outputImage)!)
    }
    
    
}

class QRCode: NSObject {
    
    class func fromString(text: String, withSize size: CGSize) -> UIImage! {
        
        let data = text.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("L", forKey: "inputCorrectionLevel")
        
        let qrcodeCIImage = filter.outputImage!
        
        let cgImage = CIContext(options:nil).createCGImage(qrcodeCIImage, from: qrcodeCIImage.extent)
        UIGraphicsBeginImageContext(CGSize(width: size.width * UIScreen.main.scale, height:size.height * UIScreen.main.scale))
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = .none
        
        context?.draw(cgImage!, in: CGRect(x: 0.0,y: 0.0,width: context!.boundingBoxOfClipPath.width,height: context!.boundingBoxOfClipPath.height))
        
        let preImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let qrCodeImage = UIImage(cgImage: (preImage?.cgImage!)!, scale: 1.0/UIScreen.main.scale, orientation: .downMirrored)
        
        return qrCodeImage
    }
    
}
