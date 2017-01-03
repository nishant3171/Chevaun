//
//  ActivityReviewViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 30/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit

class ActivityReviewViewController: UIViewController {
    
    let step: Float = 20
    var funSliderValue: Float = 0
    var growthSliderValue: Float = 0
    var satisfactionSliderValue: Float = 0
    var activityReview: [Float] = [0,0,0]
    var reviewDelegate: ActivityReviewViewControllerDelegate!
    var finalReview = String()
    var newActivity: ActivityModel?

    @IBOutlet weak var funSlider: UISlider!
    @IBOutlet weak var growthSlider: UISlider!
    @IBOutlet weak var satisfactionSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newActivity != nil {
            settingUpSliders()
        }

        funSlider.value = funSliderValue
        growthSlider.value = growthSliderValue
        satisfactionSlider.value = satisfactionSliderValue
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: UIButton) {
        
        reviewLabel()
        reviewDelegate.sendValue(fun: funSliderValue, growth: growthSliderValue, satisfaction: satisfactionSliderValue, finalReview: finalReview)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func funSliderValueChanged(sender: UISlider) {
        funSliderValue = roundingSliderValues(slider: sender)
        activityReview[0] = funSliderValue
    }
    
    @IBAction func growthSliderValueChanged(sender: UISlider) {
        growthSliderValue = roundingSliderValues(slider: sender)
        activityReview[1] = growthSliderValue
    }
    
    @IBAction func satisfactionSliderValueChanged(sender: UISlider) {
        satisfactionSliderValue = roundingSliderValues(slider: sender)
        activityReview[2] = satisfactionSliderValue
    }
    
    func roundingSliderValues(slider: UISlider) -> Float {
        let roundedValue = round(slider.value / step) * step
        slider.value = roundedValue
        return slider.value
    }
    
    func reviewLabel() {
        
        let x = max(max(activityReview[0], activityReview[1]),activityReview[2])
        
        if x >= 40 {
            if activityReview[0] == activityReview[1] && activityReview[0] == activityReview[2] {
                finalReview = "Best work!"
            }else if activityReview[0] == activityReview[1] && activityReview[0] == x {
                finalReview = "Fun&Growth"
            } else if activityReview[0] == activityReview[2] && activityReview[0] == x {
                finalReview = "Fun & Satisfaction."
            } else if activityReview[1] == activityReview[2] && activityReview[1] == x {
                finalReview = "Growth & Satisfaction"
            } else {
                for y in activityReview where y == x {
                    if let index = activityReview.index(of: y) {
                        switch index {
                        case 0:
                            finalReview = "Fun"
                        case 1:
                            finalReview = "Growth"
                        case 2:
                            finalReview = "Satisfaction"
                        default:
                            finalReview = "Generic"
                        }
                    }
                    
                }
            
            }
        } else {
            finalReview = "Should not do this work."
        }
    }
    
    func settingUpSliders() {
        
        if let funValue = newActivity?.funPercentage, let growthValue = newActivity?.growthPercentage, let satisfactionValue = newActivity?.satisfactionPercentage, let review = newActivity?.review {
            funSliderValue = Float(funValue)
            growthSliderValue = Float(growthValue)
            satisfactionSliderValue = Float(satisfactionValue)
            finalReview = review
        }
        
    }
    
    
}

