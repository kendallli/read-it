//
//  ViewController.swift
//  Read It
//
//  Created by Rui Li on 9/15/16.
//  Copyright © 2016 Smart Pollen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MWFeedParserDelegate {
    

    
    // outlets
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    
    var items = [MWFeedItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func request() {
        let url = URL(string: RSS_FEED_URL)
        let feedParser = MWFeedParser(feedURL: url);
        feedParser?.delegate = self
        feedParser?.parse()
    }
    
    // MARK: -  MWFeed delegates
    func feedParserDidStart(_ parser: MWFeedParser!) {
        SVProgressHUD.show()
        self.items = [MWFeedItem]()
    }
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        SVProgressHUD.dismiss()
    }
    func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        print(info)
        self.title = info.title
    }
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        print(item)
        self.items.append(item)
    }
    
    // MARK: - Table View delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rssCell", for: indexPath)
        
        // find record for current cell
        let thisRecord : MWFeedItem  = self.items[indexPath.row]
        
        // set value for main title and detail tect
        cell.textLabel?.text = thisRecord.title
        cell.detailTextLabel?.text = thisRecord.summary
        self.configureCell(cell: cell, atIndexPath: indexPath as IndexPath)
        // return cell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row] as MWFeedItem
        let con = KINWebBrowserViewController()
        let url = URL(string: item.link)
        con.load(url)
        self.navigationController?.pushViewController(con, animated: true)
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        /**
        let item = self.items[indexPath.row] as MWFeedItem
        cell.textLabel?.text = item.title
        cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
        cell.textLabel?.numberOfLines = 0
     
        let projectURL = item.link.componentsSeparatedByString("?")[0]
        let imgURL: URL? = URL(string: projectURL + "/cover_image?style=200x200#")
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        cell.imageView?.setImageWithURL(imgURL, placeholderImage: UIImage(named: "logo.png"))
 **/
 
    }
 

}

