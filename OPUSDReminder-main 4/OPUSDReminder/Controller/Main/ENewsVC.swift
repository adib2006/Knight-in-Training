//
//  ENewsVC.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 1/2/22.
//

import UIKit
import WebKit

class ENewsVC: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    let homePageURLString = "https://sites.google.com/opusd.org/college-and-career/enews?authuser=0"
    let eNewsURLString = "https://sites.google.com/opusd.org/college-and-career/enews?authuser=0"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let myURL = URL(string: eNewsURLString) else {
            print("\u{274C} Invalid URL.")
            return
        }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
}
