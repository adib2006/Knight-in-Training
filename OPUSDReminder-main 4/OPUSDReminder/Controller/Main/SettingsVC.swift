//
//  SettingsVC.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/31/21.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutBtnPressed(_ sender: UIButton) {
        GoogleSignInManager.signOut()
        exit()
    }
    
    @IBAction func disconnectBtnPressed(_ sender: UIButton) {
        GoogleSignInManager.disconnect()
        exit()
    }
    
    private func exit() {
//        let launchVC = presentingViewController as! LaunchVC
//        dismiss(animated: true) { [launchVC] in
//            launchVC.fromOnboardingVC()
//        }
        let decisionVC = navigationController!.viewControllers[0] as! ClassworkDecisionVC
        decisionVC.fromSignOut = true
        navigationController?.popToRootViewController(animated: true)
//        asyncAfter(0.5) { [navigationController] in // allow pop animation to complete
//            let decisionVC = navigationController!.viewControllers[0] as! ClassworkDecisionVC
////            decisionVC.fromAddScopesVC()
//        }
    }
}
