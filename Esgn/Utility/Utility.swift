//
//  Utility.swift
//  EasyBuy
//
//  Created by Somsak Wongsinsakul on 9/19/16.
//  Copyright © 2016 Maya Wizard. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

typealias ThumbnailImageFromVideoURLCompletion = (_ image: UIImage?, _ error: NSError?) -> Void

var GlobalMainQueue: DispatchQueue {
    return DispatchQueue.main
}

var GlobalUserInteractiveQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
}

var GlobalUserInitiatedQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
}

var GlobalUtilityQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
}

var GlobalBackgroundQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
}


struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer        
    }
    
}

class Utility: NSObject {
    
    
    static func bundleIdentifier() -> String! {
        return Bundle.main.bundleIdentifier
    }
    
    static func appVersion() -> String! {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    static func buildVersion() -> String! {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
    
    static func appUUID() -> String! {
        
        if (Platform.isSimulator == true) {
            return "130D0ABE-C2AC-573D-B73B-3FE934DC9CE6"
        }
        else {
            return UIDevice.current.identifierForVendor?.uuidString
        }
    }
    
    static func stringFromDate( _ date: Date, format: String, locale: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: locale)
        
        return dateFormatter.string(from: date)        
    }
    
    static func stringFromTimeInterval( _ timeinterval: TimeInterval, format: String, locale: String) -> String {
                
        return Utility.stringFromDate(Date(timeIntervalSince1970: timeinterval), format: format, locale: locale)
    }
    
    static func dateFromString( _ datestr: String, format: String, locale: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: locale)
        
        return dateFormatter.date(from: datestr)
    }

    static func alertLog( _ message: String ) {
        
        let alert = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    static func pathForDocumentDirectory() -> Any {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: Any = paths[0]
        return documentsDirectory
    }
    
    static func getFileURL(fileName: String) -> URL! {
        let documentsDirectory: NSString = Utility.pathForDocumentDirectory() as! NSString
        let dataPath = documentsDirectory.appendingPathComponent(fileName)
        
        return URL(fileURLWithPath: dataPath)
    }
    
    static func deleteFileInDocumentDirectory( _ filePath: String) {
        let documentsDirectory: NSString = Utility.pathForDocumentDirectory() as! NSString
        let dataPath = documentsDirectory.appendingPathComponent(filePath)
        
        do {
            try FileManager.default.removeItem(atPath: dataPath)
        }
        catch{
            
        }
    }
    
    static func deleteFileAtURL( _ url: URL ) {
        do {
            try FileManager.default.removeItem(at: url)
        }
        catch {
            
        }
    }
    
    static func createFolder( _ folder: String ) {
        
        let documentDirectory: NSString = self.pathForDocumentDirectory() as! NSString
        let folderPath = documentDirectory.appendingPathComponent(folder)
        
        do {
            try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    static func isFileExistsInDirectory( _ filename: String! ) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: NSString = paths[0] as NSString
        let dataPath = documentsDirectory.appendingPathComponent(filename)
        
        return FileManager.default.fileExists(atPath: dataPath)
    }
    
    static func storeImageToDisk( _ image: UIImage!, forKey key: String! ) {
        let cache: SDImageCache = SDImageCache.shared()
        cache.shouldCacheImagesInMemory = false
        cache.store(image, forKey: key)
    }
    
    static func clearImageFromDisk( _ key: String! ) {
        let cache: SDImageCache = SDImageCache.shared()
        cache.removeImage(forKey: key)
    }
    
    static func getImageFromDisk( _ key: String! ) -> UIImage? {
        if key.isEmpty {
            return nil
        }
        
        let cache: SDImageCache = SDImageCache.shared()
        if cache.diskImageExists(withKey: key) {
            cache.shouldCacheImagesInMemory = false
            return cache.imageFromDiskCache(forKey: key)
        }
        return nil
    }
    
    static func resigeImage( _ image: UIImage, targetSize: CGSize ) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func scaledImage (_ sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    static func generateThumnailFromLocalURL(_ url : URL!, completion: ThumbnailImageFromVideoURLCompletion? ) {
        
        GlobalUtilityQueue.async {
            let asset : AVURLAsset = AVURLAsset(url: url)
            let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time        : CMTime = CMTimeMakeWithSeconds(0, 1)
            
            do {
                let imageRef = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                if(completion != nil) {
                    completion!(Utility.scaledImage(UIImage(cgImage: imageRef), scaledToWidth: 150) ,nil)
                }
                //return UIImage(CGImage: imageRef)
            }
            catch let error as NSError
            {
                print("Image generation failed with error \(error)")
                if(completion != nil) {
                    completion!(nil,error)
                }
            }
        }
    }
    
    static func imageFromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    
    static func phoneCall( _ number: String ) {
        if let url = URL(string: number) {
            UIApplication.shared.openURL(url)
        }
    }
    
    static func openBrowser( _ uri: String ) {
        if let url = URL(string: uri) {
            UIApplication.shared.openURL(url)
        }
    }
    
    static func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
    static func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }
    
    
    static func attributeString( withString string: String, font: UIFont, color: UIColor ) -> NSAttributedString {
        
        return attributeString(withString: string, font: font, color: color, alignment: .left)
    }
    
    static func attributeString( withString string: String, font: UIFont, color: UIColor, alignment: NSTextAlignment ) -> NSAttributedString {
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 0.8
        paragraph.alignment = alignment
        
        let attribute = [NSFontAttributeName : font,
                         NSForegroundColorAttributeName : color,
                         NSParagraphStyleAttributeName : paragraph]
        
        return NSAttributedString(string: string, attributes: attribute)
    }
}
