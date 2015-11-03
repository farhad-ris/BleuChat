//
//  BCAppDelegate.swift
//  BleuChat
//
//  Created by Kevin Xu on 10/25/15
//  Copyright (c) 2015 Kevin Xu. All rights reserved.
//

import UIKit
import CocoaLumberjack

// MARK: - Properties

@UIApplicationMain
class BCAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
}

// MARK: - Application Lifecycle

extension BCAppDelegate {

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        setupApplication()
        configureApplication()
        return true
    }
}

// MARK: - Setup Methods

extension BCAppDelegate {

    private func setupApplication() {
        setupRootViewController()
    }

    private func setupRootViewController() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            let chatViewController = BCChatViewController()
            chatViewController.centralManager = BCCentralManager()
            chatViewController.peripheralManager = BCPeripheralManager()
            window.rootViewController = UINavigationController(rootViewController: chatViewController)
            window.backgroundColor = UIColor.whiteColor()
            window.makeKeyAndVisible()
        }
    }
}

// MARK: - Configuration Methods

extension BCAppDelegate {

    private func configureApplication() {
        configureLogger()
        logAppInformation()
    }

    private func configureLogger() {
        let sharedLogger = DDTTYLogger.sharedInstance()
        sharedLogger.logFormatter = BCLogFormatter()
        DDLog.addLogger(sharedLogger)
    }

    private func logAppInformation() {
        DDLogDebug("BleuChat Version \(UIApplication.APP_VERSION) (Build \(UIApplication.APP_BUILD))")
        DDLogDebug("\(BCDevice.CURRENT_DEVICE) \(BCDevice.SIMULATOR_OR_DEVICE) (iOS \(BCDevice.CURRENT_VERSION))")
        DDLogInfo("App Successfully Launched (\(BCDevice.CONFIGURATION) Mode)")
    }
}