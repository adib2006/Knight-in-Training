//
//  BulletinVC.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 1/3/22.
//

import UIKit
import WebKit

class BulletinVC: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    let bulletinURLString = "https://www.oakparkusd.org/Page/1284"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let myURL = URL(string: bulletinURLString) else {
            print("\u{274C} Invalid URL.")
            return
        }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
}
