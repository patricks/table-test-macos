//
//  AppDelegate.swift
//  TableTest
//
//  Created by Patrick Steiner on 20.02.17.
//  Copyright © 2017 Patrick Steiner. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("Starting app...")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print("Stopping app...")
    }
}

