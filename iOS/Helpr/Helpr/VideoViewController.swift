//
//  VideoViewController.swift
//  Helpr
//
//  Created by James Nocentini on 06/08/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

import UIKit
let topMargin: CGFloat = 60.0 + 20.0
let videoWidthMe: CGFloat = 320
let videoHeightMe: CGFloat = 480
let videoWidthThem: CGFloat = 150
let videoHeightThem: CGFloat = 100

let ApiKey = "44931602"
let SessionID = "1_MX40NDkzMTYwMn5-V2VkIEF1ZyAwNiAwODowNDo0MCBQRFQgMjAxNH4wLjk0Nzg3MTF-fg"

let Token1 = "T1==cGFydG5lcl9pZD00NDkzMTYwMiZzaWc9NjZjYjY0MmVhMzgwYzViNzcyNzRlNjg3YjY2MWU2OTYxMWQ0ZGVjODpyb2xlPXB1Ymxpc2hlciZzZXNzaW9uX2lkPTFfTVg0ME5Ea3pNVFl3TW41LVYyVmtJRUYxWnlBd05pQXdPRG93TkRvME1DQlFSRlFnTWpBeE5INHdMamswTnpnM01URi1mZyZjcmVhdGVfdGltZT0xNDA3MzM3NTA3Jm5vbmNlPTAuNDc0NDYxMTM5MjMyNTg4MTUmZXhwaXJlX3RpbWU9MTQwNzk0MDc4NQ=="

let Token2 = "T1==cGFydG5lcl9pZD00NDkzMTYwMiZzaWc9OTEwYjBhMDA1YjlmMmVmNjAyMWIxOGYxMjUyM2NjZGYwN2E5MjI1ZTpyb2xlPXB1Ymxpc2hlciZzZXNzaW9uX2lkPTFfTVg0ME5Ea3pNVFl3TW41LVYyVmtJRUYxWnlBd05pQXdPRG93TkRvME1DQlFSRlFnTWpBeE5INHdMamswTnpnM01URi1mZyZjcmVhdGVfdGltZT0xNDA3MzM3NTE2Jm5vbmNlPTAuNjIzMTE0NzYxODg4MDUxNCZleHBpcmVfdGltZT0xNDA3OTQwNzg1"

let Token3 =
"T1==cGFydG5lcl9pZD00NDkzMTYwMiZzaWc9YTZhOTg2MWE4ZWY0NDU3OTA0NmYxOGJhYWZiYmNhNTYxNjQ2N2MwODpyb2xlPXB1Ymxpc2hlciZzZXNzaW9uX2lkPTFfTVg0ME5Ea3pNVFl3TW41LVYyVmtJRUYxWnlBd05pQXdPRG93TkRvME1DQlFSRlFnTWpBeE5INHdMamswTnpnM01URi1mZyZjcmVhdGVfdGltZT0xNDA3MzY1MjY2Jm5vbmNlPTAuMzMxMDI3NzY2NDk4NDg3MSZleHBpcmVfdGltZT0xNDA3OTcwMDU3"

var Token = ""

// Change to YES to subscribe to your own stream.
let SubscribeToSelf = false

class VideoViewController: UIViewController, OTSessionDelegate, OTSubscriberKitDelegate, OTPublisherDelegate {
    
    var session: OTSession?
    var publisher: OTPublisher?
    var subscriber: OTSubscriber?
    var _product: Product?
    @IBOutlet var Image: UIImageView!
    @IBOutlet var Title: UILabel!
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        Title = UILabel(frame: CGRectZero)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    func setProduct(product: Product) {
        _product = product
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.currentDevice().name == "Petroff" {
            Token = Token1
        } else if UIDevice.currentDevice().name == "James Nocentini's iPad" {
            Token = Token2
        } else {
            Token = Token3
        }
        
        // Step 1: As the view is loaded initialize a new instance of OTSession
        session = OTSession(apiKey: ApiKey, sessionId: SessionID, delegate: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        // Step 2: As the view come into the foreground, begin the connection process
        doConnect()
        Title.text = _product!.title

        // Set the image
        var filePath = NSBundle.mainBundle().pathForResource(_product!.imageName.stringByDeletingPathExtension, ofType: _product!.imageName.pathExtension)
        println(filePath)
        var image = UIImage(contentsOfFile: filePath)
        Image.image = image
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    // MARK: - OpenTok Methods
    
    /**
    * Asynchronously begins the session connect process. Some time later, we will
    * expect a delegate method to call us back with the results of this action.
    */
    func doConnect() {
        if let session = session {
            var maybeError : OTError?
            session.connectWithToken(Token, error: &maybeError)
            if let error = maybeError {
                showAlert(error.localizedDescription)
            }
        }
    }
    
    /**
    * Sets up an instance of OTPublisher to use with this session. OTPubilsher
    * binds to the device camera and microphone, and will provide A/V streams
    * to the OpenTok session.
    */
    func doPublish() {
        publisher = OTPublisher(delegate: self)
        
        var maybeError : OTError?
        session?.publish(publisher, error: &maybeError)
        if let error = maybeError {
            showAlert(error.localizedDescription)
        }
        
        view.addSubview(publisher!.view)
        publisher!.view.frame = CGRect(x: 160, y: 370, width: videoWidthThem, height: videoHeightThem)
    }
    
    /**
    * Instantiates a subscriber for the given stream and asynchronously begins the
    * process to begin receiving A/V content for this stream. Unlike doPublish,
    * this method does not add the subscriber to the view hierarchy. Instead, we
    * add the subscriber only after it has connected and begins receiving data.
    */
    func doSubscribe(stream : OTStream) {
        if let session = self.session {
            subscriber = OTSubscriber(stream: stream, delegate: self)
            
            var maybeError : OTError?
            session.subscribe(subscriber, error: &maybeError)
            if let error = maybeError {
                showAlert(error.localizedDescription)
            }
        }
    }
    
    /**
    * Cleans the subscriber from the view hierarchy, if any.
    */
    func doUnsubscribe() {
        if let subscriber = self.subscriber {
            var maybeError : OTError?
            session?.unsubscribe(subscriber, error: &maybeError)
            if let error = maybeError {
                showAlert(error.localizedDescription)
            }
            
            subscriber.view.removeFromSuperview()
            self.subscriber = nil
        }
    }
    
    
    // MARK: - OTSession delegate callbacks
    
    func sessionDidConnect(session: OTSession) {
        NSLog("sessionDidConnect (\(session.sessionId))")
        
        // Step 2: We have successfully connected, now instantiate a publisher and
        // begin pushing A/V streams into OpenTok.
        doPublish()
    }
    
    func sessionDidDisconnect(session : OTSession) {
        NSLog("Session disconnected (\( session.sessionId))")
    }
    
    func session(session: OTSession, streamCreated stream: OTStream) {
        NSLog("session streamCreated (\(stream.streamId))")
        
        // Step 3a: (if NO == subscribeToSelf): Begin subscribing to a stream we
        // have seen on the OpenTok session.
        if subscriber == nil && !SubscribeToSelf {
            doSubscribe(stream)
        }
    }
    
    func session(session: OTSession, streamDestroyed stream: OTStream) {
        NSLog("session streamCreated (\(stream.streamId))")
        
        if subscriber?.stream.streamId == stream.streamId {
            doUnsubscribe()
        }
    }
    
    func session(session: OTSession, connectionCreated connection : OTConnection) {
        NSLog("session connectionCreated (\(connection.connectionId))")
    }
    
    func session(session: OTSession, connectionDestroyed connection : OTConnection) {
        NSLog("session connectionDestroyed (\(connection.connectionId))")
    }
    
    func session(session: OTSession, didFailWithError error: OTError) {
        NSLog("session didFailWithError (%@)", error)
    }
    
    // MARK: - OTSubscriber delegate callbacks
    
    func subscriberDidConnectToStream(subscriberKit: OTSubscriberKit) {
        NSLog("subscriberDidConnectToStream (\(subscriberKit))")
        if let view = subscriber?.view {
            view.frame = CGRect(x: 0.0, y: topMargin, width: videoWidthMe, height: videoHeightMe - topMargin)
            self.view.addSubview(view)
            self.view.bringSubviewToFront(publisher!.view)
        }
    }
    
    func subscriber(subscriber: OTSubscriberKit, didFailWithError error : OTError) {
        NSLog("subscriber %@ didFailWithError %@", subscriber.stream.streamId, error)
    }
    
    // MARK: - OTPublisher delegate callbacks
    
    func publisher(publisher: OTPublisherKit, streamCreated stream: OTStream) {
        NSLog("publisher streamCreated %@", stream)
        
        // Step 3b: (if YES == subscribeToSelf): Our own publisher is now visible to
        // all participants in the OpenTok session. We will attempt to subscribe to
        // our own stream. Expect to see a slight delay in the subscriber video and
        // an echo of the audio coming from the device microphone.
        if subscriber == nil && SubscribeToSelf {
            doSubscribe(stream)
        }
    }
    
    func publisher(publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
        NSLog("publisher streamDestroyed %@", stream)
        
        if subscriber?.stream.streamId == stream.streamId {
            doUnsubscribe()
        }
    }
    
    func publisher(publisher: OTPublisherKit, didFailWithError error: OTError) {
        NSLog("publisher didFailWithError %@", error)
    }
    
    // MARK: - Helpers
    func showAlert(message: String) {
        // show alert view on main UI
        dispatch_async(dispatch_get_main_queue()) {
            let al = UIAlertView(title: "OTError", message: message, delegate: nil, cancelButtonTitle: "OK")
        }
    }
    
    
}