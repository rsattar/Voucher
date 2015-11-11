# Voucher

Voucher is a simple Objective C library to make authenticating tvOS apps easy via their iOS counterparts using Bonjour.


## Installation

Voucher is available through [Carthage](https://github.com/Carthage/Carthage), and [Cocoapods](https://cocoapods.org). You can also manually install it, if that's your jam.

### Carthage
```
github "rsattar/Voucher"
```

### Cocoapods
```
pod 'Voucher'
```

### Manual 
- Clone the repo to your computer
- Copy only the source files in `Voucher` subfolder over to your project


## Using Voucher

In your tvOS app, when the user wants to authenticate, you should create a `VoucherClient` instance and start it:

### tvOS (requesting auth)
When the user triggers a "Login" button, your app should display some UI instructing them to open their iOS App to finish logging in, and then start the voucher client, like below:

```swift
import Voucher

func startVoucherClient() {
    let displayName = UIDevice.currentDevice().name
    let uniqueId = "SomethingUnique";
    self.voucher = VoucherClient(displayName: displayName, uniqueSharedId: uniqueId)
    
    self.voucher.startSearchingWithCompletion { [unowned self] tokenData, displayName, error in

        if tokenData != nil {
            // User granted permission on iOS app!
            self.authenticationSucceeded(tokenData!, from: displayName)
        } else {
            self.authenticationFailed()
        }
    }
}

```


### iOS (has auth)
If your iOS app has auth credentials, it should start a Voucher Server, so it can answer any requests for a login. I'd recommend starting the server when (and if) the user is logged in.

```swift
import Voucher

func startVoucherServer() {
    let name = UIDevice.currentDevice().name
    let uniqueId = "SomethingUnique"
    self.server = VoucherServer(displayName: name, uniqueSharedId: uniqueId)

    self.server.startAdvertisingWithRequestHandler { (displayName, responseHandler) -> Void in

        let alertController = UIAlertController(title: "Allow Auth?", message: "Allow \"\(displayName)\" access to your login?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Not Now", style: .Cancel, handler: { action in
            responseHandler(nil, nil)
        }))

        alertController.addAction(UIAlertAction(title: "Allow", style: .Default, handler: { action in
            let tokenData = "THIS IS AN AUTH TOKEN".dataUsingEncoding(NSUTF8StringEncoding)!
            responseHandler(tokenData, nil)
        }))

        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
}

```

## Recommendations

Voucher works best if you pass an **OAuth** token, or better yet, generate some kind of a *single-use token* on your server, and pass that to tvOS. [Cluster](https://cluster.co), for example, uses single-use tokens to do auto-login from web to iOS app. Check out this [Medium post](https://library.launchkit.io/how-ios-9-s-safari-view-controller-could-completely-change-your-app-s-onboarding-experience-2bcf2305137f?source=your-stories) that shows how I do it!

## To do / Things I'd Love Your Help With!
* Currently Voucher *does not* encrypt any data between the server and the client, so I suppose if someone wanted your credentials (See **Recommendations** section above), they could have a packet sniffer on your local network and access your credentials.
	* Is there an easy way to encrypt the communication?
	* Is that even necessary?

* Maybe change the response to be not called `tokenData`, as it's an `NSData` object, so anything can be passed back. 

* Future proofing: Add versioning to the socket protocol. Currently only the content-length preamble and an `NSDictionary` (serialized as `NSData`) is sent back and forth.

## Requirements
* iOS 7.0 and above
* tvOS 9.0
* Xcode 7

## Feedback

## License
`Voucher` is available using an MIT license. See the LICENSE file for more info.