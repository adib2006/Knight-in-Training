//
//  OnboardingVC.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/5/21.
//

import UIKit

class OnboardingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getStartedBtnPressed(_ sender: UIButton) {
        UserDefaultsManager.hasViewedOnboardingScreen = true
        let vc = storyboard!.instantiateViewController(withIdentifier: "tabbar")
        self.present(vc, animated: true, completion: nil)
    }
}
