/*
Copyright (c) 2015, Apple Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1.  Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2.  Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3.  Neither the name of the copyright holder(s) nor the names of any contributors
may be used to endorse or promote products derived from this software without
specific prior written permission. No license is granted to the trademarks of
the copyright holders even if such marks are included in this software.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit
import ResearchKit

class ResearchContainerViewController: UIViewController {
    // MARK: HealthClientType
    
    var healthStore: HKHealthStore?
    
    // MARK: Propertues
    
    var contentHidden = false {
        didSet {
            guard contentHidden != oldValue && isViewLoaded() else { return }
            childViewControllers.first?.view.hidden = contentHidden
        }
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if let defaults = standardDefaults.objectForKey(Constants.HAS_REGISTERED) as? Bool where defaults == true{
        print("onboarding")
        toOnboarding()
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }
    
    // MARK: Unwind segues
    
    @IBAction func unwindToStudy(segue: UIStoryboardSegue) {
        toStudy()
    }
    
    @IBAction func unwindToWithdrawl(segue: UIStoryboardSegue) {
        toWithdrawl()
    }
    
    // MARK: Transitions
    
    func toOnboarding() {
        performSegueWithIdentifier("toOnboarding", sender: self)
        
    }
    
    func toStudy() {
        performSegueWithIdentifier("toStudy", sender: self)
    }
    
    func toWithdrawl() {
        
        let viewController = WithdrawViewController()
        viewController.delegate = self
        
        presentViewController(viewController, animated: true, completion: nil)
    }
}

extension ResearchContainerViewController: ORKTaskViewControllerDelegate {
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        // Check if the user has finished the `WithdrawViewController`.
        if taskViewController is WithdrawViewController {
            if reason == .Completed {
                //ORKPasscodeViewController.removePasscodeFromKeychain()
                toOnboarding()
            }
            
            // Dismiss the `WithdrawViewController`.
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        //if taskViewController is OnboardingViewController
    }
    
}
