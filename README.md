# Voucher

The new Apple TV is amazing but the keyboard input leaves a lot to be desired. Instead of making your users type credentials into their TV, you can use Voucher to let them easily sign into the TV app using your iOS app.

### How Does It Work?

Voucher uses [Bonjour](https://developer.apple.com/bonjour/), which is a technology to discover other devices on your network, and what they can do. When active, Voucher on tvOS starts looking in your local network and over [AWDL (Apple Wireless Direct Link)](http://stackoverflow.com/questions/19587701/what-is-awdl-apple-wireless-direct-link-and-how-does-it-work) for any Voucher Server, on iOS. 

Once it finds a Voucher Server, it asks it for authentication. Here's the demo app:
<p align="center"><img src="http://cl.ly/image/0H1p2p3i281H/Screen%20Shot%202015-11-11%20at%2011.14.46%20AM.png" width="600" alt="Sample tvOS App"/></p>

The demo iOS app can then show a notification to the user (you can show whatever UI you want, or even no UI):
<p align="center"><img src="http://cl.ly/image/3d0L3P310C3w/IMG_0636.PNG" width="320" alt="iOS app shows a dialog"/></p>

If the user accepts, then the iOS app can send some authentication data back to the tvOS app (in this case, an auth token string)
<p align="center"><img src="http://cl.ly/image/1f2g3G3q3625/Screen%20Shot%202015-11-11%20at%2011.15.07%20AM.png" width="600" alt="Sample tvOS App"/></p>

## Installation

Voucher is available through [Carthage](https://github.com/Carthage/Carthage) and [CocoaPods](https://cocoapods.org). You can also manually install it, if that's your jam.

### Carthage
```
github "rsattar/Voucher"
```

### CocoaPods
```
pod 'Voucher'
```

### Manual 
- Clone the repo to your computer
- Copy only the source files in `Voucher` subfolder over to your project


## Using Voucher

In your tvOS app, when the user wants to authenticate, you should create a `VoucherClient` instance and start it:

### tvOS (Requesting Auth)
When the user triggers a "Login" button, your app should display some UI instructing them to open their iOS App to finish logging in, and then start the voucher client, like below:

```swift
import Voucher

func startVoucherClient() {
    let uniqueId = "SomethingUnique";
    self.voucher = VoucherClient(uniqueSharedId: uniqueId)
    
    self.voucher.startSearchingWithCompletion { [unowned self] authData, displayName, error in

        // (authData is of type NSData)
        if authData != nil {
            // User granted permission on iOS app!
            self.authenticationSucceeded(authData!, from: displayName)
        } else {
            self.authenticationFailed()
        }
    }
}

```


### iOS (Providing Auth)
If your iOS app has auth credentials, it should start a Voucher Server, so it can answer any requests for a login. I'd recommend starting the server when (and if) the user is logged in.

```swift
import Voucher

func startVoucherServer() {
    let uniqueId = "SomethingUnique"
    self.server = VoucherServer(uniqueSharedId: uniqueId)

    self.server.startAdvertisingWithRequestHandler { (displayName, responseHandler) -> Void in

        let alertController = UIAlertController(title: "Allow Auth?", message: "Allow \"\(displayName)\" access to your login?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Not Now", style: .Cancel, handler: { action in
            responseHandler(nil, nil)
        }))

        alertController.addAction(UIAlertAction(title: "Allow", style: .Default, handler: { action in
            let authData = "THIS IS AN AUTH TOKEN".dataUsingEncoding(NSUTF8StringEncoding)!
            responseHandler(authData, nil)
        }))

        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
}

```

## Recommendations

### Use tokens, not passwords
While you can send whatever data you like back to tvOS, you should you pass back an **OAuth** token, or better yet, generate some kind of a *single-use token* on your server and send that. [Cluster](https://cluster.co), for example, uses single-use tokens to do auto-login from web to iOS app. Check out this [Medium post](https://library.launchkit.io/how-ios-9-s-safari-view-controller-could-completely-change-your-app-s-onboarding-experience-2bcf2305137f?source=your-stories) that shows how I do it! The same model can apply for iOS to tvOS logins.

### Voucher can't be the only login option
In your login screen, you must still show the manual entry UI according to the [App Store Submission Guidelines](http://www.appstorereviewguidelineshistory.com/articles/2015-10-21-guidelines-updated-for-tvos-apps/) (Section 2.27). Add messaging that, in addition to the on screen form, the user can simply open the iOS app to login.

## Todo / Things I'd Love Your Help With!
* Encryption? Currently Voucher *does not* encrypt any data between the server and the client, so I suppose if someone wanted your credentials (See **Recommendations** section above), they could have a packet sniffer on your local network and access your credentials.

* Make Voucher Server work on `OS X`, and even `tvOS`! Would probably just need new framework targets, and additional test apps.

## Further Reading
Check out [Benny Wong](https://github.com/bdotdub)'s post on [why Apple TV sign in sucks](https://medium.com/@bdotdub/signing-into-apps-on-apple-tv-sucks-d36fd00e6712). He also has a [demo tvOS Authing project](https://github.com/bdotdub/TriplePlay), which you should check out!


## Requirements
* iOS 7.0 and above
* tvOS 9.0
* Xcode 8


## License
`Voucher` is available using an MIT license. See the LICENSE file for more info.

## I'd Love to Know If You're Using Voucher!
[Post to this Github "issue" I made to help us track who's using Voucher](https://github.com/rsattar/Voucher/issues/2) :+1:
