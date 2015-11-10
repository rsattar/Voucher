//
//  ViewController.swift
//  Voucher tvOS App
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

import UIKit
import Voucher

class ViewController: UIViewController {

    var client: VoucherClient?

    deinit {
        self.client?.stopListening()
        self.client = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let displayName = UIDevice.currentDevice().name
        let uniqueId = "VoucherTest";

        self.client = VoucherClient(displayName: displayName, appId: uniqueId)
        self.client?.startListeningWithCompletion { [unowned self] (tokenData, displayName, error) -> Void in

            defer {
                self.client?.stopListening()
            }

            guard let tokenData = tokenData, let displayName = displayName else {
                if let error = error {
                    NSLog("Encountered error retrieving data: \(error)")
                }
                return
            }

            self.onTokenDataReceived(tokenData, responderName: displayName)
            
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.client?.stopListening()
    }

    func onTokenDataReceived(tokenData: NSData, responderName:String) {
        let tokenString = String(data: tokenData, encoding: NSUTF8StringEncoding)!
        let alert = UIAlertController(title: "Received Token!", message: "Received token, '\(tokenString)' from '\(responderName)'", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

