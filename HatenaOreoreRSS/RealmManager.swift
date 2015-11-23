//
//  RealmManager.swift
//  IlluminanceLifelog
//
//  Created by 内村祐之 on 2015/10/19.
//  Copyright © 2015年 ucuc. All rights reserved.
//

import RealmSwift

class RealmManager {
    static let realm = try! Realm()

    class func insertNewFeed(title: String, url: String, date: NSDate, content: String?) {
        if let _ = articleExitIsInFavoriteFeed(url) {
            print("他の人が読んだ記事")
        } else {
            let feed = NewFeed(title: title, url: url, date: date, content: content)
            try! realm.write {
                realm.add(feed)
            }
        }
    }
    
    class func insertFavoriteFeed(title: String, url: String, date: NSDate) {
        let feed = FavoriteFeed(title: title, url: url, date: date)
        try! realm.write {
            realm.add(feed)
        }
    }
    
    class func all<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    class func count<T: Object>(type: T.Type) -> Int {
        return realm.objects(type).count
    }
    
    class func first<T: Object>(type: T.Type) -> T? {
        return realm.objects(type).first
    }
    
    class func last<T: Object>(type: T.Type) -> T? {
        return realm.objects(type).last
    }
    
    class func articleExitIsInFavoriteFeed(url: String) -> FavoriteFeed? {
        let predicate = NSPredicate(format: "url = %@", url)
        let article = realm.objects(FavoriteFeed).filter(predicate)
        return article.first
    }
    
    class func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}