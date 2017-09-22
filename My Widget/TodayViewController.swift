//
//  TodayViewController.swift
//  My Widget
//
//  Created by mehulmac on 18/09/17.
//  Copyright © 2017 mehulmac. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var table: UITableView!
    var strStaticMessage = "Please wait, while loading data"
    
    var arrList = [ListModel]()

    // MARK:
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.tableFooterView = UIView()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        let count = self.arrList.count * 44
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: CGFloat(count)) : maxSize
    }
    
    //Use below method to set data
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        switch  NetworkManagerExtension().checkInternetConnection() {
        case .available:
            APIService().getQuestions({ (response) in
                if let arrDict = response.array {
                    self.arrList = ModelManager.sharedInstance.getListModelArray(arrDict)
                    completionHandler(.newData)
                }
                else {
                    completionHandler(.noData)
                }
                
                self.table.reloadData()
            }) { (error) in
                print(error as Any)
                self.table.reloadData()
                completionHandler(.failed)
            }
            break
                
        case .notAvailable:
            strStaticMessage = "No internet connection"
            self.table.reloadData()
            break
        }
    }
}

// MARK:
// MARK: UITableViewCell, UITableViewDataSource, UITableViewDelegate
class WidgetCell: UITableViewCell {
    @IBOutlet weak var lblGameName: UILabel!
    @IBOutlet weak var lblWinningNumber: UILabel!
    @IBOutlet weak var lblDrawNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension TodayViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrList.count > 0 {
            return self.arrList.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetCell", for: indexPath) as! WidgetCell
        
        cell.lblGameName.text = strStaticMessage
        cell.lblWinningNumber.text = ""
        cell.lblDrawNumber.text = ""
        
        if self.arrList.count > 0 {
            let dataWidget = self.arrList[indexPath.row]
            if let data = dataWidget.strQuestion {
                cell.lblGameName.text = data
            }
            
            if let data = dataWidget.arrChoices?.first?.strChoices {
                cell.lblWinningNumber.text = data
            }
            
            if let data = dataWidget.arrChoices?.first?.strVotes {
                cell.lblDrawNumber.text = data
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : WidgetCell = tableView.cellForRow(at: indexPath) as! WidgetCell
        if cell.lblGameName.text != strStaticMessage {
            if self.arrList.count > 0 {
                let dataWidget = self.arrList[indexPath.row]
                if let strData : String = dataWidget.toJSONString() {
                    //Save data to application
                    if let defaults = UserDefaults(suiteName: "group.Sooryen.DemoTodayWidget") {
                        defaults.set(strData, forKey: "extensionSharedDataString")
                        defaults.synchronize()
                        
                        //Redirect to application
                        if let myAppUrl = URL(string: "MyWidget://") {
                            self.extensionContext?.open(myAppUrl, completionHandler: { (success) in
                                if !success {
                                    print("error: failed to open app from Today Extension")
                                }
                                else {
                                    print("data sending done")
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}
