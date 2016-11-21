//
//  WebViewController.swift
//  RKitBase
//
//  Created by Admin on 9/29/16.
//  Copyright © 2016 Neil Lakin. All rights reserved.
//

import Foundation
import UIKit

class PDFViewController: UIViewController {
    
    // We're going to show a PDF with the help of this web view.
    var webView = UIWebView()
    override func viewWillAppear(animated: Bool) {
        let nav = self.navigationController?.navigationBar
        let image = Constants.Images.BACKGROUND
        nav?.setBackgroundImage(image, forBarMetrics: .Default)
        nav?.tintColor = UIColor.whiteColor()
        nav?.translucent = false
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make sure the web view is shown fullscreen.
        webView.frame = view.frame
        webView.scalesPageToFit = true
        view.addSubview(webView)
    }

}
