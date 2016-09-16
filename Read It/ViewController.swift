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
    
    
    // Available details from http://feeds.reuters.com/reuters/MostRead
    // summary
    // date
    // id
    // link
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rssCell", for: indexPath) as! RSSTableViewCell
        
        //configure cell
        self.configureCell(cell: cell, atIndexPath: indexPath as IndexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row] as MWFeedItem
        let con = KINWebBrowserViewController()
        let url = URL(string: item.link)
        con.load(url)
        self.navigationController?.pushViewController(con, animated: true)
    }
    
    func configureCell(cell: RSSTableViewCell, atIndexPath indexPath: IndexPath) {
        
        let item = self.items[indexPath.row] as MWFeedItem
        
        // set value for title and summary
        cell.titleLabel.text = item.title
        cell.titleLabel.font = UIFont.systemFont(ofSize: 17)
        cell.titleLabel.numberOfLines = 2
        cell.summaryLabel.text = item.summary.components(separatedBy: "<")[0]
        cell.summaryLabel.font = UIFont.systemFont(ofSize: 13)
        cell.summaryLabel.numberOfLines = 3
        // for some reason the image could not be downloaded correctly
        // tried to use http://feedreader.com/online/#/reader/category/0/feed/4051853/
        // no images shown in RSS list either
        let imageURL:URL?
        if(item.link.contains("img")){
            let imageURLStr = item.link.components(separatedBy: "img")[1]
            imageURL = URL(string: imageURLStr.components(separatedBy: "\"")[1])
            print("item link contains img: \(imageURL)")
        }else{
            imageURL = nil
        }
        
        cell.pictureImageView.contentMode = UIViewContentMode.scaleAspectFit
        if imageURL != nil {
            cell.pictureImageView.setImageWith(imageURL!, placeholderImage: UIImage(named: "loadingImage"))
        }else{
            cell.pictureImageView.image = UIImage(named: "loadingImage")
        }
 
    }
 

}

