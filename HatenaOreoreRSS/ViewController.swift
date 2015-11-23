//
//  ViewController.swift
//  HatenaOreoreRSS
//
//  Created by 内村祐之 on 2015/11/22.
//  Copyright © 2015年 ucuc. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    var feeds = [Feeds]()
    var HUD: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationItem.title = "Top"
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.tableview.estimatedRowHeight = 900
        self.tableview.rowHeight = UITableViewAutomaticDimension
        
        HUD = MBProgressHUD(view: self.view)
        self.view.addSubview(HUD!)
        HUD?.labelText = "Loading"
        HUD?.show(true)
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            self.loadBookmark()
            
            let fbfeeds = RealmManager.all(NewFeed)
            // print(fbfeeds)
            for fbfeed in fbfeeds {
                let content: String? = fbfeed.content
                let feed = Feeds(title: fbfeed.title, url: fbfeed.url, date: fbfeed.date, content: content)
                self.feeds.append(feed)
            }

            dispatch_async(dispatch_get_main_queue(), {
                self.tableview.reloadData()
                self.HUD?.hide(true)
            })
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = self.tableview.indexPathForSelectedRow {
            self.tableview.deselectRowAtIndexPath(selectedRow, animated: true)
        }
    }
    
    func loadBookmark() {
        MyHatenaManager.sharedInstance.parseURL(Parser.favoriteFeed, urlString: Parser.favoriteFeed.rawValue)
        MyHatenaManager.sharedInstance.parseURL(Parser.newFeed, urlString: Parser.newFeed.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feeds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomCell
        let feed = self.feeds[indexPath.row]
        cell.setCell(feed.title, url: feed.url)
        
        if let content = feed.content {
            MyHTMLParser.getContents(content, completion: { parsedURL in
                if let _ = parsedURL {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        let url = NSURL(string: parsedURL!)
                        let data = NSData(contentsOfURL: url!)
                        let image = UIImage(data: data!)
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.articleImage.image = image
                            cell.layoutSubviews()
                        })
                    })

                }
            })
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailViewController.url = NSURL(string: self.feeds[indexPath.row].url)
        detailViewController.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

