//
//  BCChatViewController.swift
//  BleuChat
//
//  Created by Kevin Xu on 10/26/15.
//  Copyright © 2015 Kevin Xu. All rights reserved.
//

import UIKit
import CoreBluetooth
import CocoaLumberjack
import SnapKit

// MARK: - Properties

final class BCChatViewController: UIViewController {

    var centralManager: BCCentralManager!
    var peripheralManager: BCPeripheralManager!
}

// MARK: - View Lifecycle

extension BCChatViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        centralManager.delegate = self
        peripheralManager.delegate = self
    }

    override func viewWillDisappear(animated: Bool) {
        centralManager.stopScanning()
        peripheralManager.stopAdvertising()

        super.viewWillDisappear(animated)
    }

    // MARK: Setup Methods

    private func setupViewController() {
        title = "Chat"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "scanButtonTapped:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Info"), style: .Plain, target: self, action: nil)

        let sendButton = UIButton(type: .System)
        sendButton.setTitle("Send Message", forState: .Normal)
        sendButton.addTarget(self, action: "sendButtonTapped:", forControlEvents: .TouchUpInside)
        view.addSubview(sendButton)
        sendButton.snp_makeConstraints { make in
            make.center.equalTo(view)
        }

        let messagesButton = UIButton(type: .System)
        messagesButton.setTitle("View Messages", forState: .Normal)
        messagesButton.addTarget(self, action: "messagesButtonTapped:", forControlEvents: .TouchUpInside)
        view.addSubview(messagesButton)
        messagesButton.snp_makeConstraints { make in
            make.center.equalTo(view).offset(CGPointMake(0, -100))
        }
    }
}


// MARK: - User Interaction

extension BCChatViewController {

    func sendButtonTapped(sender: UIButton) {
        BCDefaults.setObject("Kevin Xu", forKey: .Name)
        peripheralManager.sendMessage("Hello World!")
    }

    func scanButtonTapped(sender: UIButton) {
        centralManager.startScanning()
        peripheralManager.startAdvertising()
    }

    func messagesButtonTapped(sender: UIButton) {
        if let messages: [BCMessage] = BCDefaults.dataObjectArrayForKey(.Messages) {
            DDLogDebug("\(messages)")
        } else {
            DDLogDebug("NIL")
        }
        BCDefaults.resetDefaults()
    }
}

// MARK: - Delegates

// MARK: BCMessageable

extension BCChatViewController: BCMessageable {
    func updateWithNewMessage(message: BCMessage) {
        if message.isSelf {
            DDLogInfo("You said: \(message.message)")
        } else {
            DDLogInfo("NEW: \(message.message) from \(message.name)")
        }
    }
}
