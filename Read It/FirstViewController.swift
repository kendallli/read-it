//
//  FirstViewController.swift
//  Read It
//
//  Created by Rui Li on 10/11/16.
//  Copyright © 2016 Smart Pollen. All rights reserved.
//

import UIKit

/**
 Top Stories		http://rss.cnn.com/rss/cnn_topstories.rss
 
 World		http://rss.cnn.com/rss/cnn_world.rss
 U.S.		http://rss.cnn.com/rss/cnn_us.rss
 Business (CNNMoney.com)		http://rss.cnn.com/rss/money_latest.rss
 Politics		http://rss.cnn.com/rss/cnn_allpolitics.rss
 Technology		http://rss.cnn.com/rss/cnn_tech.rss
 Health		http://rss.cnn.com/rss/cnn_health.rss
 Entertainment		http://rss.cnn.com/rss/cnn_showbiz.rss
 Travel		http://rss.cnn.com/rss/cnn_travel.rss
 Living		http://rss.cnn.com/rss/cnn_living.rss
 Video		http://rss.cnn.com/rss/cnn_freevideo.rss
 CNN Student News		http://rss.cnn.com/services/podcasting/studentnews/rss.xml
 Most Recent		http://rss.cnn.com/rss/cnn_latest.rss
 **/

struct rssLinks {
    var names: [String]
    var urls: [String]
    
    init() {
        names = [""]
        urls = [""]
    }
}

class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate{

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var feedLinkPickerView: UIPickerView!
    @IBOutlet weak var feedLinkTextView: UITextView!
    @IBOutlet weak var goButton: UIButton!

    var pickerData: rssLinks?
    var feedURLselected: String?
    
    override func viewWillAppear(_ animated: Bool) {
        self.stackView.isHidden = true
        self.stackView.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        self.stackView.isHidden = false
        UIView.animate(withDuration: 0.5, animations:{
            self.stackView.alpha = 1
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //add data for feed link picker view
        self.setupPickerViewData()
        
        // Connect data:
        self.feedLinkPickerView.delegate = self
        self.feedLinkPickerView.dataSource = self
    }
    
    // create data for picker view
    func setupPickerViewData(){
        pickerData = rssLinks()
        pickerData?.names = [
            "CNN Top Stories",
            "CNN World",
            "CNN U.S.",
            "CNN Business (CNNMoney.com)",
            "CNN Politics",
            "CNN Technology",
            "CNN Health",
            "CNN Entertainment",
            "CNN Travel",
            "CNN Living",
            "CNN Video",
            "CNN Student News",
            "CNN Most Recent"]
        
        pickerData?.urls = [
            "http://rss.cnn.com/rss/cnn_topstories.rss",
            "http://rss.cnn.com/rss/cnn_world.rss",
            "http://rss.cnn.com/rss/cnn_us.rss",
            "http://rss.cnn.com/rss/money_latest.rss",
            "http://rss.cnn.com/rss/cnn_allpolitics.rss",
            "http://rss.cnn.com/rss/cnn_tech.rss",
            "http://rss.cnn.com/rss/cnn_health.rss",
            "http://rss.cnn.com/rss/cnn_showbiz.rss",
            "http://rss.cnn.com/rss/cnn_travel.rss",
            "http://rss.cnn.com/rss/cnn_living.rss",
            "http://rss.cnn.com/rss/cnn_freevideo.rss",
            "http://rss.cnn.com/services/podcasting/studentnews/rss.xml",
            "http://rss.cnn.com/rss/cnn_latest.rss"]
    }
    // Mark: - picker view delegate
    // The number of columns of data
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (pickerData?.names.count)!
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData?.names[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        RSS_FEED_URL  = (pickerData?.urls[row])!
        print("RSS_FEED_URL = "+RSS_FEED_URL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
