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

        
        let displayName = UIDevice.currentDevice().name
        let uniqueId = "VoucherTest";
        self.client = VoucherClient(displayName: displayName, uniqueSharedId: uniqueId)
        self.client?.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)


        self.client?.startSearchingWithCompletion { [unowned self] (tokenData, displayName, error) -> Void in

            defer {
                self.client?.stop()
            }

            guard let tokenData = tokenData, let displayName = displayName else {
                if let error = error {
                    NSLog("Encountered error retrieving data: \(error)")
                }
                self.onNoDataReceived(error)
                return
            }

            self.onTokenDataReceived(tokenData, responderName: displayName)
            
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.client?.stop()
    }

    func onNoDataReceived(error: NSError?) {
        let alert = UIAlertController(title: "Authentication Failed", message: "The iOS App denied our authentication request.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Bummer!", style: .Default, handler: { [unowned self] action in
            self.delegate?.authController(self, didSucceed: false)
            }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func onTokenDataReceived(tokenData: NSData, responderName:String) {
        let tokenString = String(data: tokenData, encoding: NSUTF8StringEncoding)!
        let alert = UIAlertController(title: "Received Token!", message: "Received token, '\(tokenString)' from '\(responderName)'", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: .Default, handler: { [unowned self] action in
            self.delegate?.authController(self, didSucceed: true)
            }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - VoucherClientDelegate

    func voucherClient(client: VoucherClient, didUpdateSearching isSearching: Bool) {
        if isSearching {
            self.searchingLabel.text = "Searching for iOS App..."
        } else {
            self.searchingLabel.text = "Not Searching."
        }
    }

    func voucherClient(client: VoucherClient, didUpdateConnectionToServer isConnectedToServer: Bool, serverName: String?) {
        if isConnectedToServer {
            self.connectionLabel.text = "Connected to '\(serverName!)'"
        } else {
            self.connectionLabel.text = "Not Connected Yet."
        }
    }
}

protocol AuthViewControllerDelegate {
    func authController(controller:AuthViewController, didSucceed succeeded:Bool)
}

