//
//  StoopViewController.swift
//  RKitBase
//
//  Created by Ran Godrich on 3/11/17.
//  Copyright © 2017 Neil Lakin. All rights reserved.
//

import UIKit
import Foundation

class StroopViewController: UIViewController {

    @IBOutlet weak var stimulus: UIImageView!
    @IBOutlet weak var endTask: UIButton!
    
    @IBAction func Button1(sender: UIButton) {
        buttonPressed.append("Green")
        trial()
    }
    @IBAction func Button2(sender: UIButton) {
        buttonPressed.append("Red")
        trial()
    }
    
    @IBAction func Button3(sender: UIButton) {
        buttonPressed.append("Blue")
        trial()
    }
    
    @IBAction func Button4(sender: UIButton) {
        buttonPressed.append("Yellow")
        trial()
    }
    
    var count = 0;
    var stimuli : [String] = ["red_text_green_color"]
    var buttonPressed = [String]()

    let dict = [1: "red_text_green_color", 2: "red_text_red_color", 3: "green_text_green_color", 4: "green_text_red_color",5: "blue_text_blue_color", 6: "blue_text_yellow_color", 7: "yellow_text_blue_color", 8: "yellow_text_yellow_color"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func trial () {
    
        let randNum = Int(arc4random_uniform(8)) + 1
        
        stimuli.append(dict[randNum]!)
        
        switch randNum {
        case 1:
            stimulus.image = Constants.Images.red_text_green_color
        case 2:
            stimulus.image = Constants.Images.red_text_red_color
        case 3:
            stimulus.image = Constants.Images.green_text_green_color
        case 4:
            stimulus.image = Constants.Images.green_text_red_color
        case 5:
            stimulus.image = Constants.Images.blue_text_blue_color
        case 6:
            stimulus.image = Constants.Images.blue_text_yellow_color
        case 7:
            stimulus.image = Constants.Images.yellow_text_blue_color
        case 8:
            stimulus.image = Constants.Images.yellow_text_yellow_color
        default:
            stimulus.image = nil
        }
        
        count += 1
        if count == 20 {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(buttonPressed, forKey: "button_presses")
            defaults.setObject(stimuli, forKey: "stimuli_presented")
            defaults.synchronize()
            print(buttonPressed)
            print(stimuli)
            endTask.sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
