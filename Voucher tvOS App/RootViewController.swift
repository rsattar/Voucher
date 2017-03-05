//
//  RootViewController.swift
//  Voucher
//
//  Created by Rizwan Sattar on 11/9/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, AuthViewControllerDelegate {

    var isAuthenticated: Bool = false {
        didSet {
            self.authenticationUI.isHidden = self.isAuthenticated
            self.clearAuthenticationButton.isHidden = !self.isAuthenticated
            if (isAuthenticated) {
                self.authenticationLabel.text = "Authenticated!"
            } else {
                self.authenticationLabel.text = "Not Authenticated"
            }
            self.view.setNeedsLayout()
        }
    }

    @IBOutlet weak var authenticationLabel: UILabel!
    @IBOutlet weak var clearAuthenticationButton: UIButton!
    @IBOutlet weak var authenticationUI: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.isAuthenticated = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let segueIdentifier = segue.identifier else {
            return
        }

        if segueIdentifier == "showVoucher" {
            let viewController = segue.destination as! AuthViewController
            viewController.delegate = self

        }
    }

    @IBAction func onClearDataTriggered(_ sender: UIButton) {
        self.isAuthenticated = false
    }

    // MARK: - AuthViewControllerDelegate
    func authController(_ controller: AuthViewController, didSucceed succeeded: Bool) {
        self.isAuthenticated = succeeded
        self.dismiss(animated: true, completion: nil)
    }
}
