//
//  API+CDN.swift
//  EasyBuy
//
//  Created by Somsak Wongsinsakul on 11/1/16.
//  Copyright © 2016 Maya Wizard. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


typealias SuccessBlock = (_ json: JSON?,_ success: Bool?,_ fileurl: String?, _ error: Error?) -> Void
typealias HandlerProgress = (_ progress: Double) -> Void

let CDN_URL = "http://skylane.appmanager.biz/api/image/upload"

class API_CDN: NSObject {
    
    static func uploadFile( data: Data, fileName: String!, progressblock: HandlerProgress? , handler: SuccessBlock? ) {
        
        let parameters : [String:String] = [
            "appid" : "apptaxi",
            "pwd": "Dragonquest11"
        ]
        
        // example image data
        // CREATE AND SEND REQUEST ----------
        
        Alamofire.upload(multipartFormData: { (multipartdata) in
            
            multipartdata.append(data, withName: "file", fileName: fileName, mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartdata.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to: CDN_URL) { (result) in
                            switch result {
                                
                            case .success(let upload, _, _):
                                
                                upload.uploadProgress(closure: { (Progress) in
                                    print("Upload Progress: \(Progress.fractionCompleted)")
                                    if (progressblock != nil) {
                                        progressblock!(Progress.fractionCompleted)
                                    }
                                })
                                
                                upload.responseData(completionHandler: { (response) in
                                    
                                    if let value = response.result.value {
                                        let json = JSON(value)
                                        
                                        print("JSON: \(json)")
                                        
                                        if json["status"].intValue == 1 {
                                            let url = json["data"]["img_path"].stringValue
                                            if handler != nil {
                                                handler!( json, true, url, nil)
                                            }
                                        }
                                        else {
                                            if (handler != nil ) {
                                                handler!( json , false, nil, nil)
                                            }
                                        }
                                    }
                                })
                                
                            case .failure(let encodingError):
                                //self.delegate?.showFailAlert()
                                print(encodingError)
                                if (handler != nil ) {
                                    handler!(nil,false,nil,encodingError)
                                }
                            }
        }
        
    }
}
