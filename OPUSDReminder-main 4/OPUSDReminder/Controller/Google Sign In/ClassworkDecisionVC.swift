//
//  ClassworkDecisionVC.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 1/25/22.
//

import UIKit

class ClassworkDecisionVC: UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var fetchingLabel: UILabel!
    
    private var initialVCLoad: Bool = true
    var fromSignOut: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        fetchingLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard initialVCLoad || fromSignOut else { return }
        initialVCLoad = false
        fromSignOut = false
        
        GoogleSignInManager.restorePreviousSignIn { [weak self] signedIn, accessToken in
            guard let self = self else { return }
            if signedIn {
                Classroom.singleton = Classroom(accessToken: accessToken!)
                self.fromSignInVC()
            }
            else {
                self.presentSignInVC()
            }
        }
    }
    
    // MARK: - Public Methods
    
    func fromSignInVC() {
        if GoogleSignInManager.hasScopes {
            fetchDataThenSegue()
        }
        else {
            presentAddScopesVC()
        }
    }
    
    func fromAddScopesVC() {
        fetchDataThenSegue()
    }
    
    // MARK: - Private Methods
    
    private func fetchDataThenSegue() {
        spinner.startAnimating()
        fetchingLabel.isHidden = false
        Classroom.singleton.getClasses { [weak self] classes in
            DataManager.classes = classes
            DispatchQueue.main.async { [weak self] in
                self?.spinner.stopAnimating()
                self?.fetchingLabel.isHidden = true
                self?.presentMainInterface()
            }
        }
    }
    
    private func presentSignInVC() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "SignInVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentAddScopesVC() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "AddScopesVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentMainInterface() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "ClassworkVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
