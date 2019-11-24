//
//  AppDelegate.swift
//  Test
//
//  Created by Johannes Lund on 2019-11-16.
//  Copyright © 2019 Johannes Lund. All rights reserved.
//

import UIKit

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadExplorer()
        attempt()
    }
    
    func loadExplorer() {
        let myURL = URL(string:"http://127.0.0.1:8080/explorer/graphiql")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func attempt() {
        fetchStake {
            switch $0 {
            case .none: self.attempt()
            case .some(_):
                self.loadExplorer()
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        loadExplorer()
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        // Override point for customization after application launch.
        
        let dispatchQueue = DispatchQueue(label: "jormungandr", qos: .background)
        dispatchQueue.async{
            let r = jormungandrWithConfig
            print(r)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


func jormungandrWithConfig() -> Int32 {
    // Add the program's path to the arguments
    
    let config = Bundle.main.path(forResource: "testnet", ofType: "yml", inDirectory: nil, forLocalization: nil)
    let storage = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("jormungandr").relativePath
    try! FileManager.default.createDirectory(atPath: storage, withIntermediateDirectories: true, attributes: nil)
    let arg1 = "--genesis-block-hash 0f9d564199ad7f71af3daaff4b6997cb7f2e3d7c422fa29097f5d6a018c440d1"
    let arg2 = "--rest-listen 127.0.0.1:8080 --enable-explorer"
    let arg3 = "--config " + config!
    let arg4 = "--storage " + storage
    let argsIncludingPath = ["",arg1,arg2,arg3,arg4].joined(separator: " ")
    print("starting jormungandr with arguments:")
    print(argsIncludingPath)
    return argsIncludingPath.withCString { p in
        jormungandr_main(p)
    }
        
}
