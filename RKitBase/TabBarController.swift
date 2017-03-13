//
//  TabBarController.swift
//  RKitBase
//
//  Created by Admin on 8/30/16.
//  Copyright © 2016 Neil Lakin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        //set the appearance of the TabBar
        self.tabBar.translucent = false
        self.tabBar.clipsToBounds = true
        self.tabBar.backgroundImage = Constants.Images.BACKGROUND

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, .Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage!)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
