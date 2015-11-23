//
//  MyHTMLParser.swift
//  HatenaOreoreRSS
//
//  Created by 内村祐之 on 2015/11/22.
//  Copyright © 2015年 ucuc. All rights reserved.
//

import Alamofire
import HTMLReader

class MyHTMLParser {
    class func getContentsFromURL (url: String, completion: (String? -> Void)){
        let url = NSURL(string: url)
        
        Alamofire.request(.GET, url!).responseString(completionHandler: { response in
            if let data = response.data {
                if let encodedString = String(data: data, encoding:NSUTF8StringEncoding) {
                    let html = HTMLDocument(string: encodedString)
                
                    var image = ""
                    let imgTags = html.nodesMatchingSelector("img")
                    for img in imgTags {
                        if(img.attributes?["data-src"] != nil){
                            image = (img.attributes?["data-src"] as? String)!
                            completion(image)
                            return
                        }
                    }
                    
                }
            }
            completion(nil)
        })
        
    }
    
    class func getContents (content: String, completion: (String? -> Void)){
        let html = HTMLDocument(string: content)
        
        let imgTags = html.nodesMatchingSelector("img")
        for img in imgTags {
            if img.attributes?["src"] != nil {
                if let imgString = img.attributes?["src"] as? String {
                    if imgString.rangeOfString("jpg") != nil {
                        completion(imgString)
                        return
                    }
                
                }
            }
        }
        completion(nil)        
    }
}