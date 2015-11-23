//
//  DetailViewController.swift
//  HatenaOreoreRSS
//
//  Created by 内村祐之 on 2015/11/22.
//  Copyright © 2015年 ucuc. All rights reserved.
//

import UIKit
import MBProgressHUD

class DetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url: NSURL!
    var HUD: MBProgressHUD?
    var progress = [0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationItem.title = "Detail"

        HUD = MBProgressHUD(view: self.view)
        self.view.addSubview(HUD!)
        HUD?.labelText = "Loading"
        HUD?.mode = MBProgressHUDMode.Determinate
        HUD?.show(true)
        HUD?.labelText = "Loading";

        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DetailViewController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        print("start")
        if progress[0] == 0 {
            progress[1]++
            HUD!.progress = Float(progress[0])/Float(progress[1])
        }
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        print("finish")
        progress[0]++
        HUD!.progress = Float(progress[0])/Float(progress[1])
        if progress[0] == progress[1] {
            HUD?.hide(true)
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        HUD?.labelText = "fuck"
        HUD?.hide(true)
    }

}
