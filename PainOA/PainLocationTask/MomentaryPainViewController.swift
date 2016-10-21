//
//  ViewController.swift
//  FingerTouchSegmentedControl
//
//  Created by Admin on 8/22/16.
//  Copyright Â© 2016 Shiri. All rights reserved.
//

import UIKit
import AVFoundation

class MomentaryPainViewController: UIViewController {
    
    @IBOutlet weak var bodyImageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var bodyBorderView: UIView?
    var bodyWidth: CGFloat?
    var bodyHeight: CGFloat?
    var dotsFrontArray: [String] = []
    var dotsBackArray: [String] = []
    //bodyDictionary
    //0 - start x %, 1 - start y %, 2 - width %, 3 - height %, 4 tag
    var dict = Dictionary<String, Array<CGFloat>>()
    let nameDict : [Int: String] = [0: "Head", 1: "Breasts", 2: "Arms", 3: "Abdomen", 4: "Pelvis / Vagina",
                                    5: "Hips / Thighs", 6: "Lower legs / Feet",
                                    7: "Back", 8: "Buttocks / Rectum", 9: "Chest"]
//    let painTypes: [String] = [
//        "Aching","Burning","Cramping","Deep","Dull","Pressure","Pulling","Radiating"
//        ,"Sharp","Stinging","Shocking","Shooting","Stabbing","Throbbing","Twisting"]
    
    let painTypes: [String] = ["Hurts a little", "Hurts moderately", "Hurts a lot", "Hurts like crazy"]

    override func viewDidLoad() {
        print("view did load in Momemtary pain controller")
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("viewdidappear")
        createBodyDictionary()
        createBodyBoundary()
        //addOrClearPainDots()
    }
    
//    func addOrClearPainDots() {
//        let currentDate = NSDate()
//        let defaults = NSUserDefaults.standardUserDefaults()
//        //if 24 hours have passed, need to clear pain dot data
//        if LocalNotification.getNumberOfDaysBetweenDates(
//            defaults.objectForKey(Constants.LAST_DAILY_DATE_CHECKED) as! NSDate, laterDate: currentDate) == 1 {
//            //Todo: send data to server
//            //clear local dot data
//            print("it's a new day!!")
//            dotsFrontArray.removeAll()
//            dotsBackArray.removeAll()
//            //update LAST_DAILY_DATE_CHECKED
//            defaults.setObject(currentDate, forKey: Constants.LAST_DAILY_DATE_CHECKED)
//        } else if LocalNotification.getNumberOfDaysBetweenDates( //<24 hours passed, restore dots
//            defaults.objectForKey(Constants.LAST_DAILY_DATE_CHECKED) as! NSDate, laterDate: currentDate) == 0 {
//            print("less than 24 hours")
//            dotsFrontArray = NSUserDefaults.standardUserDefaults().arrayForKey(Constants.PAIN_DOTS_FRONT) as! [String]
//            dotsBackArray = NSUserDefaults.standardUserDefaults().arrayForKey(Constants.PAIN_DOTS_BACK) as! [String]
//            print("got dots array", dotsFrontArray)
//            showBodyDots(Constants.PAIN_DOTS_FRONT)
//        }
//    }
    
    func createBodyDictionary(){
        //bodyDictionary
        //0 - start x %, 1 - start y %, 2 - width %, 3 - height %
        dict["head"] = [0.29, 0, 0.43, 0.15, 0]
        dict["breasts"] = [0.22,0.23,0.58,0.09, 1]
        dict["arms/hands-upperleft"] = [0,0.19,0.22,0.24, 2]
        dict["arms/hands-right"] = [0.80,0.19,0.20,0.24, 2]
        dict["arms/hands-lowerleft"] = [0,0.43,0.17,0.18, 2]
        dict["arms/hands-lowerright"] = [0.83,0.42,0.17,0.18, 2]
        dict["abdomen"] = [0.27,0.32,0.49,0.11, 3]
        dict["pelvis/vagina"] = [0.36,0.47,0.28,0.06, 4]
        dict["hips-left"] = [0.17,0.43,0.19,0.10, 5]
        dict["hips-right"] = [0.64,0.43,0.19,0.10, 5]
        dict["thighs"] = [0.17,0.53,0.66,0.19, 5]
        dict["lowerleg/feet"] = [0.25,0.72,0.51,0.28, 6]
        dict["back"] = [0.13,0.19,0.56,0.23, 7]
        dict["buttocks/rectum"] = [0.10,0.42,0.65,0.13, 8]
        dict["chest"] = [0.22,0.15,0.58,0.08,9]
    }
    
    func createBodyBoundary(){
        //set up body container
        let imageSizeSameAspectRatio = bodyImageView.image!.size
        let containerViewRect = CGRect(x: 0, y: 0, width: bodyImageView.frame.size.width,
                                       height: bodyImageView.frame.size.height)
        let bodyBorder = AVMakeRectWithAspectRatioInsideRect(imageSizeSameAspectRatio, containerViewRect)
        bodyBorderView = UIView(frame: bodyBorder)
        bodyWidth=bodyBorderView!.frame.size.width
        bodyHeight=bodyBorderView!.frame.size.height
        //bodyBorderView!.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
        self.bodyImageView.addSubview(bodyBorderView!)
    }
    
//    func createBodyPartBoundaries(){
//        for (bodyPart, ratios) in dict {
//            let button = UIButton(frame: CGRect(x: ratios[0]*bodyWidth!, y: ratios[1]*bodyHeight!, width: ratios[2]*bodyWidth!, height: ratios[3]*bodyHeight!))
//            //button.backgroundColor = UIColor.darkGrayColor()
//            button.addTarget(self, action: #selector(buttonAction), forControlEvents: UIControlEvents.TouchUpInside)
//            button.tag = Int(ratios[4])
//            self.bodyBorderView!.addSubview(button)
//            print("bodyPart: ", bodyPart)
//            viewDict[bodyPart] = UIView(frame:
//                CGRectMake(ratios[0]*bodyWidth!,
//                ratios[1]*bodyHeight!,
//                ratios[2]*bodyWidth!,
//                ratios[3]*bodyHeight!))
//            viewDict[bodyPart]!.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 0.9)
//            if bodyPart.lowercaseString.rangeOfString("arms/hands") != nil || bodyPart=="lowerleg/feet"{
//                print("exists")
//                viewDict[bodyPart]!.backgroundColor = UIColor(red: 0, green: 1, blue: 0.5, alpha: 0.5)
//
//            }
//            if bodyPart.lowercaseString.rangeOfString("hips") != nil {
//                viewDict[bodyPart]!.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
//            }
//            bodyBorderView!.addSubview(viewDict[bodyPart]!)
//
//        }
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(bodyBorderView)
            print(position)
            for (bodyPart, ratios) in dict {
                if bodyImageView.image == UIImage(named: "WomenBodyFront") && (bodyPart=="back" || bodyPart=="buttocks/rectum"){
                    continue
                }
                if bodyImageView.image == UIImage(named: "WomenBodyBack") && !(bodyPart=="back" || bodyPart=="buttocks/rectum"){
                    continue
                }
                let xStart = ratios[0]*bodyWidth!
                let xEnd = ratios[0]*bodyWidth! + ratios[2]*bodyWidth!
                let yStart = ratios[1]*bodyHeight!
                let yEnd = ratios[1]*bodyHeight! + ratios[3]*bodyHeight!
                if (xStart < position.x) && (position.x < xEnd) {
                    if (yStart < position.y) && (position.y < yEnd) {
                        print("in body part: ", bodyPart)
                        callPopUp(nameDict[Int(ratios[4])]!, position: position)
                        break
                    }
                }
            }
        }
    }
    
    
    func callPopUp(bodyPartString: String, position: CGPoint) {
        let alertController = UIAlertController(title: nil, message: bodyPartString, preferredStyle: .ActionSheet)

        //alertController.view.tintColor = UIColor(red:0.41, green:0.15, blue:0.22, alpha:1.0)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in }
        alertController.addAction(cancelAction)
        
        for painString in painTypes {
            let painAction = UIAlertAction(title: painString, style: .Default) { (action) in
                let dot = UIView(frame: CGRect(x: position.x, y: position.y, width: 10, height: 10))
                dot.backgroundColor = UIColor.redColor()//(red: 0.61, green: 0.15, blue: 0.22, alpha: 1)
                dot.layer.cornerRadius = 5
                self.bodyBorderView!.addSubview(dot)
                if self.bodyImageView.image == UIImage(named: "WomenBodyFront") {
                    self.dotsFrontArray.append(NSStringFromCGPoint(position))
                    print("appending dot to front array", self.dotsFrontArray)
                } else {
                    self.dotsBackArray.append(NSStringFromCGPoint(position))
                    print("appending dot to back array", self.dotsBackArray)
                }
                
            }
            alertController.addAction(painAction)
        }
        self.presentViewController(alertController, animated: true) {}
    }

    
    @IBAction func toggleSegmentedControl(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            bodyImageView.image=UIImage(named: "WomenBodyFront")
            showBodyDots(Constants.PAIN_DOTS_FRONT)
        case 1:
            bodyImageView.image=UIImage(named: "WomenBodyBack")
            showBodyDots(Constants.PAIN_DOTS_BACK)
        default:
            break;
        }
    }
    
    func showBodyDots(bodySide: String){
        var dots = [String]()
        if (bodySide == Constants.PAIN_DOTS_FRONT) {
            dots = dotsFrontArray
        } else {
            dots = dotsBackArray
        }
        print("Show Body dots", dots)
        //first: clear previous dots from other side!
        self.bodyBorderView!.subviews.forEach({ $0.removeFromSuperview() })
        //then: add dots of this side!
        for dotString in dots {
            let dotPosition = CGPointFromString(dotString)
            let dot = UIView(frame: CGRect(x: dotPosition.x, y: dotPosition.y, width: 10, height: 10))
            dot.backgroundColor = UIColor.redColor()//(red: 0.61, green: 0.15, blue: 0.22, alpha: 1)
            dot.layer.cornerRadius = 5
            self.bodyBorderView!.addSubview(dot)
        }
    }
    
    @IBAction func cancelAddingPainFeedback(sender: UIBarButtonItem) {
        print("setting pain feedback to ", dotsFrontArray)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func finishAddingPainFeedback(sender: UIBarButtonItem) {
        print("setting pain feedback to ", dotsFrontArray)
        NSUserDefaults.standardUserDefaults().setObject(dotsFrontArray, forKey: Constants.PAIN_DOTS_FRONT)
        NSUserDefaults.standardUserDefaults().setObject(dotsBackArray, forKey: Constants.PAIN_DOTS_BACK)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}

