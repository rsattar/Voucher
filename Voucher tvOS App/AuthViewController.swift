//
//  AuthViewController.swift
//  Voucher tvOS App
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

import UIKit
import Voucher

class AuthViewController: UIViewController, VoucherClientDelegate {

    var delegate: AuthViewControllerDelegate?
    var client: VoucherClient?

    @IBOutlet weak var searchingLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!

    deinit {
        self.client?.stop()
        self.client?.delegate = nil
        self.client = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let uniqueId = "VoucherTest";
        self.client = VoucherClient(uniqueSharedId: uniqueId)
        self.client?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        self.client?.startSearching { [unowned self] (authData, displayName, error) -> Void in

            defer {
                self.client?.stop()
            }

            guard let authData = authData, let displayName = displayName else {
                if let error = error {
                    NSLog("Encountered error retrieving data: \(error)")
                }
                self.onNoDataReceived(error as NSError?)
                return
            }

            self.onAuthDataReceived(authData, responderName: displayName)
            
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.client?.stop()
    }

    func onNoDataReceived(_ error: NSError?) {
        let alert = UIAlertController(title: "Authentication Failed", message: "The iOS App denied our authentication request.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Bummer!", style: .default, handler: { [unowned self] action in
            self.delegate?.authController(self, didSucceed: false)
            }))
        self.present(alert, animated: true, completion: nil)
    }

    func onAuthDataReceived(_ authData: Data, responderName:String) {
        // Treat the auth data as an string-based auth token
        let tokenString = String(data: authData, encoding: String.Encoding.utf8)!
        let alert = UIAlertController(title: "Received Auth Data!", message: "Received data, '\(tokenString)' from '\(responderName)'", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default, handler: { [unowned self] action in
            self.delegate?.authController(self, didSucceed: true)
            }))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - VoucherClientDelegate

    func voucherClient(_ client: VoucherClient, didUpdateSearching isSearching: Bool) {
        if isSearching {
            self.searchingLabel.text = "📡 Searching for Voucher Servers..."
        } else {
            self.searchingLabel.text = "❌ Not Searching."
        }
    }

    func voucherClient(_ client: VoucherClient, didUpdateConnectionToServer isConnectedToServer: Bool, serverName: String?) {
        if isConnectedToServer {
            self.connectionLabel.text = "✅ Connected to '\(serverName!)'"
        } else {
            self.connectionLabel.text = "😴 Not Connected Yet."
        }
    }
}

protocol AuthViewControllerDelegate {
    func authController(_ controller:AuthViewController, didSucceed succeeded:Bool)
}

