//
//  ViewController.swift
//  Read It
//
//  Created by Rui Li on 9/15/16.
//  Copyright © 2016 Smart Pollen. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MWFeedParserDelegate {
    

    
    // outlets
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    let CELL_HIGHT = 120
    
    // Available details from http://feeds.reuters.com/reuters/MostRead
    // { summary
    //  date
    //  id
    //  link }
    //  gonna use webview to display the content of the rss news since content variable contains nothing after pulling
    //var items = [MWFeedItem]()
    var items = [NSManagedObject]()
    
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
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        let url = URL(string: RSS_FEED_URL)
        let feedParser = MWFeedParser(feedURL: url);
        feedParser?.delegate = self
        feedParser?.parse()
    }
    
    // MARK: -  MWFeed delegates
    func feedParserDidStart(_ parser: MWFeedParser!) {
        //SVProgressHUD.show()
        
        // stop spinner
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        //self.items = [MWFeedItem]()
    }
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        //SVProgressHUD.dismiss()
        
        // stop spinner
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        print(info)
        self.title = info.title
    }
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        print(item)
        //self.items.append(item)
        self.saveRSSInfo(RSSInfo: item)
    }
    func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
        
        // stop spinner
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        self.showAlertMessage(alertTitle: "Error", alertMessage: "Failed to get news. Please check the Internet connection")
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
        return CGFloat(self.CELL_HIGHT)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /**
        let item = self.items[indexPath.row] as MWFeedItem
        let con = KINWebBrowserViewController()
        let url = URL(string: item.link)
        con.load(url)
        self.navigationController?.pushViewController(con, animated: true)
 **/
    }
    
    // MARK: - Utility functions
    func configureCell(cell: RSSTableViewCell, atIndexPath indexPath: IndexPath) {
        
        //let item = self.items[indexPath.row] as MWFeedItem
        
        // set value for title and summary
        cell.titleLabel.font = UIFont.systemFont(ofSize: 17)
        cell.titleLabel.numberOfLines = 2
        cell.summaryLabel.font = UIFont.systemFont(ofSize: 13)
        cell.summaryLabel.numberOfLines = 3
        //cell.titleLabel.text = item.title
        //cell.summaryLabel.text = item.summary.components(separatedBy: "<")[0]
        // for some reason the image could not be downloaded correctly
        // tried to use http://feedreader.com/online/#/reader/category/0/feed/4051853/
        // no images shown in RSS list either
        /**
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
        **/
    }
    
    // show alert with ok button
    private func showAlertMessage(alertTitle: String, alertMessage: String ) -> Void {
        
        // create alert controller
        let alertCtrl = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert) as UIAlertController
        
        // create action
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:
            { (action: UIAlertAction) -> Void in
                // you can add code here if needed
        })
        
        // add ok action
        alertCtrl.addAction(okAction)
        
        // present alert
        self.present(alertCtrl, animated: true, completion: { (void) -> Void in
            // you can add code here if needed
        })
    }
    
    // save rss info into core data
    func saveRSSInfo(RSSInfo: MWFeedItem) {
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "RSSInfo",
                                                 in:managedContext)
        
        let RSSItem = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        //3
        RSSItem.setValue(RSSInfo.identifier, forKey: "identifier")
        RSSItem.setValue(RSSInfo.link, forKey: "link")
        RSSItem.setValue(RSSInfo.summary, forKey: "summary")
        RSSItem.setValue(RSSInfo.title, forKey: "title")
        RSSItem.setValue(RSSInfo.date, forKey: "date")
        
        
            
        items.append(RSSItem)
        appDelegate.saveContext()
    }
    
    

    
 

}

