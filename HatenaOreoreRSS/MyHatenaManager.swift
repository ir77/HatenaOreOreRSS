//
//  MyHatenaManager.swift
//  HatenaOreoreRSS
//
//  Created by 内村祐之 on 2015/11/22.
//  Copyright © 2015年 ucuc. All rights reserved.
//

enum Parser: String {
    case favoriteFeed = "http://b.hatena.ne.jp/iridium77/favorite.rss?of=25&with_me=1"
    // case newFeed = "http://b.hatena.ne.jp/entrylist/it?sort=hot&threshold=5&mode=rss"
    case newFeed = "http://b.hatena.ne.jp/entrylist/fun.rss"
}

import MWFeedParser

private let _sharedInstance = MyHatenaManager()

class MyHatenaManager: NSObject {
    var favoriteParser: MWFeedParser? = nil
    var feedParser: MWFeedParser? = nil
    var parseMode: Parser = Parser.favoriteFeed
    
    override init() {
        super.init()
        reinitParser(.favoriteFeed, url: NSURL(string: Parser.favoriteFeed.rawValue)!)
        reinitParser(.newFeed, url: NSURL(string: Parser.newFeed.rawValue)!)
    }
    
    
    func reinitParser(parser: Parser, url: NSURL) {
        switch parser {
        case .newFeed:
            feedParser = MWFeedParser(feedURL: url)
            feedParser?.delegate = self
            feedParser?.feedParseType = ParseTypeFull
            feedParser?.connectionType = ConnectionTypeSynchronously;
        case .favoriteFeed:
            favoriteParser = MWFeedParser(feedURL: url)
            favoriteParser?.delegate = self
            favoriteParser?.feedParseType = ParseTypeFull
            favoriteParser?.connectionType = ConnectionTypeSynchronously;
        }
    }
    
    class var sharedInstance: MyHatenaManager {
        return _sharedInstance
    }
    
    class func dateUnix() -> Int {
        // 日時文字列をNSDate型に変換するためのNSDateFormatterを生成
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // NSDateFormatterを使って日時文字列 "dateStr" をNSDate型 "date" に変換
        let dateStr: String = "2015-02-04 12:34:56"
        let date: NSDate? = formatter.dateFromString(dateStr)
        
        // NSDate型 "date" をUNIX時間 "dateUnix" に変換
        return Int(date!.timeIntervalSince1970)
    }
    
    func parseURL(parser: Parser, urlString: String) {
        reinitParser(parser, url: NSURL(string: urlString)!)
        switch parser {
        case .favoriteFeed:
            self.parseMode = .favoriteFeed
            favoriteParser?.parse()
        case .newFeed:
            self.parseMode = .newFeed
            feedParser?.parse()
        }
    }
   
}

extension MyHatenaManager: MWFeedParserDelegate {
    @objc func feedParserDidStart(parser: MWFeedParser!) {
        print("start, mode: ", parseMode)
    }
    
    @objc func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        // print("didParseFeedInfo: ", info.title, info.link, info.summary)
    }
    
    @objc func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        print("FeedItem: " + item.title, item.link, item.date)
        switch parseMode {
        case .favoriteFeed:
            RealmManager.insertFavoriteFeed(item.title, url: item.link, date: item.date)
        case .newFeed:
            let content: String? = item.content
            RealmManager.insertNewFeed(item.title, url: item.link, date: item.date, content: content )
        }
    }
    
    @objc func feedParserDidFinish(parser: MWFeedParser!) {
        print("----------- DidFinish -----------")
    }
    
    @objc func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        print("fail")
    }

}