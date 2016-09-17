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
    var rssItems = [Read_ItRSSInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
        fetchFromCoreData()
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
        // when it gets feed item the item is saved into core data
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
        return self.rssItems.count
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
        
        let item = self.rssItems[indexPath.row] as Read_ItRSSInfo
        let con = KINWebBrowserViewController()
        let url = URL(string: item.link!)
        con.load(url)
        self.navigationController?.pushViewController(con, animated: true)
 
    }
    
    // MARK: - Utility functions
    
    func configureCell(cell: RSSTableViewCell, atIndexPath indexPath: IndexPath) {
        
        //let item = self.items[indexPath.row] as MWFeedItem - this line was used before implementing to save data in core data
        let item = self.rssItems[indexPath.row] as Read_ItRSSInfo
        // set value for title and summary
        cell.titleLabel.font = UIFont.systemFont(ofSize: 17)
        cell.titleLabel.numberOfLines = 2
        cell.summaryLabel.font = UIFont.systemFont(ofSize: 13)
        cell.summaryLabel.numberOfLines = 3
        cell.titleLabel.text = item.title
        cell.summaryLabel.text = item.summary?.components(separatedBy: "<")[0]
        
        //FIXME: - for some reason the image could not be downloaded correctly
        // tried to use http://feedreader.com/online/#/reader/category/0/feed/4051853/ but no images shown in the RSS list either
        let imageURL:URL?
        if(item.link?.contains("img"))!{
            let imageURLStr = item.link?.components(separatedBy: "img")[1]
            imageURL = URL(string: (imageURLStr?.components(separatedBy: "\"")[1])!)
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
    
    // show alert view
    private func showAlertMessage(alertTitle: String, alertMessage: String ) -> Void {
        
        // create alert controller
        let alertCtrl = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert) as UIAlertController
        
        // create action
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:
            { (action: UIAlertAction) -> Void in
        })
        
        // add ok action
        alertCtrl.addAction(okAction)
        
        // present alert view
        self.present(alertCtrl, animated: true, completion: { (void) -> Void in
        })
    }
    
    // save rss info into core data
    // currently it does not save images in rss feeds since i couldn't get any image to test
    // it does save titles and summaries locally in core data
    // reference: https://www.raywenderlich.com/115695/getting-started-with-core-data-tutorial
    func saveRSSInfo(RSSInfo: MWFeedItem) {
        // updates: https://developer.apple.com/library/content/releasenotes/General/WhatNewCoreData2016/ReleaseNotes.html
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //
        let entity =  NSEntityDescription.entity(forEntityName: "RSSInfo",
                                                 in:managedContext)
        
        let RSSItem = Read_ItRSSInfo(entity: entity!,
                                     insertInto: managedContext)
        
        //3 set values
        RSSItem.setValue(RSSInfo.identifier, forKey: "identifier")
        RSSItem.setValue(RSSInfo.link, forKey: "link")
        RSSItem.setValue(RSSInfo.summary, forKey: "summary")
        RSSItem.setValue(RSSInfo.title, forKey: "title")
        RSSItem.setValue(RSSInfo.date, forKey: "date")
        
        
        rssItems.append(RSSItem)
        appDelegate.saveContext()
    }
    
    //fetch data from core data
    
    func  fetchFromCoreData() -> Void {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Read_ItRSSInfo> = Read_ItRSSInfo.fetchRequest()
        
        
        do {
            let results =
                try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            // get new rss feeds from core data and store in local instance
            self.rssItems = results as! [Read_ItRSSInfo]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    

    
 

}

