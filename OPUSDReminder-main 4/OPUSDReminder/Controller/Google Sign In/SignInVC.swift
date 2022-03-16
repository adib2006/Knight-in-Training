//
//  SignInVC.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/29/21.
//

import UIKit
import GoogleSignIn

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    @IBAction func signInBtnPressed(_ sender: GIDSignInButton) {
        GoogleSignInManager.signIn(fromVC: self) { [unowned self] accessToken in
            Classroom.singleton = Classroom(accessToken: accessToken)
            navigationController?.popViewController(animated: true)
            asyncAfter(0.5) { [navigationController] in // allow pop animation to complete
                let decisionVC = navigationController!.viewControllers[0] as! ClassworkDecisionVC
                decisionVC.fromSignInVC()
            }
        }
    }
}
