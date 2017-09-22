//
//  ViewController.swift
//  DemoTodayWidget
//
//  Created by mehulmac on 18/09/17.
//  Copyright © 2017 mehulmac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class ViewController: UIViewController {
    let sharedAppDelegate  =   UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var txtVTemp: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Launched...")
        
        //Add observer, so we can get shared data when user click on widget cell.
        //Write this method, wherever you want shared data..
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(doThisWhenNotify),
                                               name: NSNotification.Name(rawValue: sharedNotificationKey),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //You can call method, as per requirement
    @objc func doThisWhenNotify(notification: NSNotification?) {
        if (notification?.object as? JSON) != nil {
            //Convert json to model and you can use that model as per requirement.
            let jsonData : JSON = notification?.object! as! JSON
            let model = ModelManager.sharedInstance.getListModel(jsonData.rawString()!)
            
            //Display data to screen, which we have taken from Widget
            self.txtVTemp.text = model.toJSONString(prettyPrint: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
