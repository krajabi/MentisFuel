//
//  PainStepViewController.swift
//  RKitBase
//
//  Created by Admin on 9/2/16.
//  Copyright © 2016 Shiri Avni. All rights reserved.
//

import UIKit
import ResearchKit
import AVFoundation


//class DemoView: UIView {
//    
//}


class PainStepViewController : ORKActiveStepViewController {
    
    let painView = UIStackView()
    let painImageView = UIImageView(image: UIImage(named: "WomenBodyFront"))
    let segment: UISegmentedControl = UISegmentedControl(items: ["Front", "Back"])
    
    var bodyBorderView: UIView?
    var bodyWidth: CGFloat?
    var bodyHeight: CGFloat?
    var dotsFrontArray: [String] = []
    var dotsBackArray: [String] = []
    var dict = Dictionary<String, Array<CGFloat>>()
    let painTypes: [String] = ["Intense", "Moderate", "Mild"]
    let nameDict : [Int: String] = [0: "Head", 1: "Breasts", 2: "Arms", 3: "Abdomen", 4: "Pelvis / Vagina",
                                    5: "Hips / Thighs", 6: "Lower legs / Feet", 7: "Back", 8: "Buttocks / Rectum", 9: "Chest"]
    let dotColors : [String: UIColor] = ["Mild":UIColor.yellowColor(),"Moderate": UIColor.orangeColor(), "Intense": UIColor.redColor()]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.sizeToFit()
        segment.tintColor = UIColor(red:0.99, green:0.00, blue:0.25, alpha:1.00)
        segment.selectedSegmentIndex = 0;
        segment.addTarget(self, action: #selector(self.toggleSegmentedControl), forControlEvents: .ValueChanged)
        painImageView.heightAnchor.constraintEqualToConstant(view.frame.size.height-167-segment.frame.height).active = true
        painImageView.contentMode = .ScaleAspectFit
        painView.axis = .Vertical
        painView.distribution = .EqualSpacing
        painView.alignment = .Center
        painView.addArrangedSubview(segment)
        painView.addArrangedSubview(painImageView)
        painView.spacing = 15

        painView.translatesAutoresizingMaskIntoConstraints = false
        self.customView = painView
        self.customView?.superview!.translatesAutoresizingMaskIntoConstraints = false
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.customView?.addGestureRecognizer(gestureRecognizer)
        

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[painView]|", options: NSLayoutFormatOptions(rawValue: 3), metrics: nil, views: ["painView": painView]))
        createBodyDictionary()
        createBodyBoundary()
        showBodyDots(Constants.PAIN_DOTS_FRONT)
    }
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let position = gestureRecognizer.locationInView(bodyBorderView)
        //print(position)
        for (bodyPart, ratios) in dict {
            if painImageView.image == UIImage(named: "WomenBodyFront") && (bodyPart=="back" || bodyPart=="buttocks/rectum"){
                continue
            }
            if painImageView.image == UIImage(named: "WomenBodyBack") && !(bodyPart=="back" || bodyPart=="buttocks/rectum"){
                continue
            }
            let xStart = ratios[0]*bodyWidth!
            let xEnd = ratios[0]*bodyWidth! + ratios[2]*bodyWidth!
            let yStart = ratios[1]*bodyHeight!
            let yEnd = ratios[1]*bodyHeight! + ratios[3]*bodyHeight!
            if (xStart < position.x) && (position.x < xEnd) {
                if (yStart < position.y) && (position.y < yEnd) {
                    //print("in body part: ", bodyPart)
                    callPopUp(nameDict[Int(ratios[4])]!, position: position)
                    break
                }
            }
        }
    }
   func toggleSegmentedControl() {
        switch segment.selectedSegmentIndex
        {
        case 0:
            painImageView.image=UIImage(named: "WomenBodyFront")
            showBodyDots(Constants.PAIN_DOTS_FRONT)
        case 1:
            painImageView.image=UIImage(named: "WomenBodyBack")
            showBodyDots(Constants.PAIN_DOTS_BACK)
        default:
            break;
        }
    }
    override func finish() {
        super.finish()
        //print("setting pain feedback to ", dotsFrontArray)
        NSUserDefaults.standardUserDefaults().setObject(dotsFrontArray, forKey: Constants.PAIN_DOTS_FRONT)
        NSUserDefaults.standardUserDefaults().setObject(dotsBackArray, forKey: Constants.PAIN_DOTS_BACK)
    }
    
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
        let imageSizeSameAspectRatio = painImageView.image!.size
        let containerViewRect = CGRect(x: 0, y: 0, width: view.frame.size.height-167-segment.frame.height, height: view.frame.size.height-167-segment.frame.height)
        let bodyBorder = AVMakeRectWithAspectRatioInsideRect(imageSizeSameAspectRatio, containerViewRect)
        bodyBorderView = UIView(frame: bodyBorder)
        bodyWidth=bodyBorderView!.frame.size.width
        bodyHeight=bodyBorderView!.frame.size.height
        //print(String(bodyHeight)+"vs"+String(painImageView.frame.size.height))
        //bodyBorderView!.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
        self.painImageView.addSubview(bodyBorderView!)
        let xConstraint = NSLayoutConstraint(item: bodyBorderView!, attribute: .CenterX, relatedBy: .Equal, toItem: painImageView, attribute: .CenterX, multiplier: 1, constant: 0)
        view.addConstraint(xConstraint)
        self.painImageView.clipsToBounds = true

    }
    
    func callPopUp(bodyPartString: String, position: CGPoint) {
        let alertController = UIAlertController(title: nil, message: bodyPartString, preferredStyle: .ActionSheet)
        
        alertController.view.tintColor = UIColor(red:0.41, green:0.15, blue:0.22, alpha:1.0)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in }
        alertController.addAction(cancelAction)
        
        for painString in painTypes {
            let painAction = UIAlertAction(title: painString, style: .Default) { (action) in
                let dot = UIView(frame: CGRect(x: position.x, y: position.y, width: 10, height: 10))
                dot.backgroundColor = self.dotColors[painString]
                dot.layer.cornerRadius = 5
                self.bodyBorderView!.addSubview(dot)
                if self.painImageView.image == UIImage(named: "WomenBodyFront") {
                    self.dotsFrontArray.append(NSStringFromCGPoint(position))
                    //print("appending dot to front array", self.dotsFrontArray)
                    NSUserDefaults.standardUserDefaults().setObject(self.dotsFrontArray, forKey: Constants.PAIN_DOTS_FRONT)
                } else {
                    self.dotsBackArray.append(NSStringFromCGPoint(position))
                    //print("appending dot to back array", self.dotsBackArray)
                    NSUserDefaults.standardUserDefaults().setObject(self.dotsBackArray, forKey: Constants.PAIN_DOTS_BACK)
                }
                
            }
            alertController.addAction(painAction)
        }
        self.presentViewController(alertController, animated: true) {}

    }
    func showBodyDots(bodySide: String){
        var dots = [String]()
        if (bodySide == Constants.PAIN_DOTS_FRONT) {
            dots = dotsFrontArray
        } else {
            dots = dotsBackArray
        }
        //print("Show Body dots", dots)
        //first: clear previous dots from other side!
        self.bodyBorderView!.subviews.forEach({ $0.removeFromSuperview() })
        //then: add dots of this side!
        for dotString in dots {
            let dotPosition = CGPointFromString(dotString)
            let dot = UIView(frame: CGRect(x: dotPosition.x, y: dotPosition.y, width: 10, height: 10))
            dot.backgroundColor = UIColor(red:0.83, green:0.40, blue:0.43, alpha:1.0)
            dot.layer.cornerRadius = 5
            self.bodyBorderView!.addSubview(dot)
        }
    }


}


class PainStep : ORKActiveStep {
    static func stepViewControllerClass() -> PainStepViewController.Type {
        return PainStepViewController.self
    }
}

