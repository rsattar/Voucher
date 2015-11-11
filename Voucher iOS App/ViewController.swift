//
//  ViewController.swift
//  Voucher iOS App
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

import UIKit
import Voucher

class ViewController: UIViewController, VoucherServerDelegate {

    var server: VoucherServer?

    @IBOutlet var serverStatusLabel: UILabel!
    @IBOutlet var connectionStatusLabel: UILabel!

    deinit {
        self.server?.stop()
        self.server?.delegate = nil
        self.server = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let uniqueId = "VoucherTest"
        self.server = VoucherServer(uniqueSharedId: uniqueId)
        self.server?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.server?.startAdvertisingWithRequestHandler { (displayName, responseHandler) -> Void in

            let alertController = UIAlertController(title: "Allow Auth?", message: "Allow \"\(displayName)\" access to your login?", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Not Now", style: .Cancel, handler: { action in
                responseHandler(nil, nil)
            }))

            alertController.addAction(UIAlertAction(title: "Allow", style: .Default, handler: { action in
                // For our authData, use a token string (to simulate an OAuth token, for example)
                let authData = "THIS IS AN AUTH TOKEN".dataUsingEncoding(NSUTF8StringEncoding)!
                responseHandler(authData, nil)
            }))

            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        self.server?.stop()
    }

    // MARK: - VoucherServerDelegate

    func voucherServer(server: VoucherServer, didUpdateAdvertising isAdvertising: Bool) {
        var text = "❌ Server Offline."
        if (isAdvertising) {
            text = "✅ Server Online."
        }
        self.serverStatusLabel.text = text
        self.connectionStatusLabel.hidden = !isAdvertising
    }

    func voucherServer(server: VoucherServer, didUpdateConnectionToClient isConnectedToClient: Bool) {
        var text = "📡 Waiting for Connection..."
        if (isConnectedToClient) {
            text = "✅ Connected."
        }
        self.connectionStatusLabel.text = text
    }

}

