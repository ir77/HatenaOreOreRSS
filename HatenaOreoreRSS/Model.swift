//
//  Model.swift
//  HatenaOreoreRSS
//
//  Created by 内村祐之 on 2015/11/22.
//  Copyright © 2015年 ucuc. All rights reserved.
//

import RealmSwift

struct Feeds {
    var title: String
    var url: String
    var date: NSDate
    var content: String?
}

class NewFeed: Object {
    dynamic var title: String = ""
    dynamic var url: String = ""
    dynamic var date: NSDate = NSDate()
    dynamic var content: String? = nil
    
    convenience init(title: String, url: String, date: NSDate, content: String?) {
        self.init()
        self.title = title
        self.url = url
        self.date = date
        self.content = content
    }
}

class FavoriteFeed: Object {
    dynamic var title: String = ""
    dynamic var url: String = ""
    dynamic var date: NSDate = NSDate()
    
    convenience init(title: String, url: String, date: NSDate) {
        self.init()
        self.title = title
        self.url = url
        self.date = date
    }
}
