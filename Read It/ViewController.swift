//
//  ViewController.swift
//  Read It
//
//  Created by Rui Li on 9/15/16.
//  Copyright © 2016 Smart Pollen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {

    
    // outlets
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    
    // xml parser
    var myParser: XMLParser = XMLParser()
    
    // rss records
    var rssRecordList : [RSSInfo] = [RSSInfo]()
    var rssRecord : RSSInfo?
    var isTagFound = [ "item": false , "title":false, "date": false ,"link":false]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set tableview delegate
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        //if empty then load data
        if self.rssRecordList.isEmpty {
            self.loadRSSData()
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view dataSource and Delegate
    
    // return number of section within a table
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // return row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // return how may records in a table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rssRecordList.count
    }
    
    // return cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // collect reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "rssCell", for: indexPath as IndexPath)
        
        // find record for current cell
        let thisRecord : RSSInfo  = self.rssRecordList[indexPath.row]
        
        // set value for main title and detail tect
        cell.textLabel?.text = thisRecord.title
        cell.detailTextLabel?.text = thisRecord.date
        
        // return cell
        return cell
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
       // self.performSegue(withIdentifier: "segueShowDetails", sender: self)
    }
    
   
    // MARK: - NSXML Parse delegate function
    
    // start parsing document
    private func parserDidStartDocument(parser: XMLParser) {
        // start parsing
    }
    
    // element start detected
    private func parser(parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "item" {
            self.isTagFound["item"] = true
            self.rssRecord = RSSInfo()
            
        }else if elementName == "title" {
            self.isTagFound["title"] = true
            
        }else if elementName == "link" {
            self.isTagFound["link"] = true
            
        }else if elementName == "date" {
            self.isTagFound["date"] = true
        }
        
    }
    
    // characters received for some element
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if isTagFound["title"] == true {
            self.rssRecord?.title += string
            
        }else if isTagFound["link"] == true {
            self.rssRecord?.link += string
            
        }else if isTagFound["date"] == true {
            self.rssRecord?.date += string
        }
        
    }
    
    // element end detected
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            self.isTagFound["item"] = false
            self.rssRecordList.append(self.rssRecord!)
            
        }else if elementName == "title" {
            self.isTagFound["title"] = false
            
        }else if elementName == "link" {
            self.isTagFound["link"] = false
            
        }else if elementName == "date" {
            self.isTagFound["date"] = false
        }
    }
    
    // end parsing document
    func parserDidEndDocument(_ parser: XMLParser) {
        
        //reload table view
        self.myTableView.reloadData()
        
        // stop spinner
        self.spinner.stopAnimating()
    }
    
    // if any error detected while parsing.
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        
        //  stop animation
        self.spinner.stopAnimating()
        
        // show error message
        self.showAlertMessage(alertTitle: "Error", alertMessage: "Error while parsing xml.")
    }
    
    
    
    
    // MARK: - Utility functions
    
    // load rss and parse it
    private func loadRSSData(){
        
        if let rssURL = NSURL(string: RSS_FEED_URL) {
            
            // start spinner
            self.spinner.startAnimating()
            
            // fetch rss content from url
            self.myParser = XMLParser(contentsOf: rssURL as URL)!
            
            // set parser delegate
            self.myParser.delegate = self
            self.myParser.shouldResolveExternalEntities = false
            
            // start parsing
            self.myParser.parse()
        }
        
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
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /**
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueShowDetails" {
            
            // find index path for selected row
            let selectedIndexPath : [NSIndexPath] = self.myTableView.indexPathsForSelectedRows! as [NSIndexPath]
            
            // deselect the selected row
            self.myTableView.deselectRowAtIndexPath(selectedIndexPath[0], animated: true)
            
            // create destination view controller
            let destVc = segue.destinationViewController as! DetailsViewController
            
            // set title for next screen
            destVc.navigationItem.title = self.rssRecordList[selectedIndexPath[0].row].title
            
            // set link value for destination view controller
            destVc.link = self.rssRecordList[selectedIndexPath[0].row].link
            
        }

        
    }
 **/
}

