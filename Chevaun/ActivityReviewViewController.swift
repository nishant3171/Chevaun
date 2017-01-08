//
//  ActivityReviewViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 30/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit

class ActivityReviewViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var funSlider: UISlider!
    @IBOutlet weak var growthSlider: UISlider!
    @IBOutlet weak var satisfactionSlider: UISlider!
    
    //MARK: Constans&Variables
    let step: Float = 20
    var funSliderValue: Float = 0
    var growthSliderValue: Float = 0
    var satisfactionSliderValue: Float = 0
    var activityReview: [Float] = [0,0,0]
    var reviewDelegate: ActivityReviewViewControllerDelegate!
    var finalReview = String()
    var newActivity: ActivityModel?
    
    enum FinalReview: String {
        case Fun = "Fascinating hobby for sure"
        case Growth = "Awesome! An interesting talent"
        case Satisfaction = "Oh! That was indeed fulfilling"
        case FunAndGrowth = "Let's make that a hobby!"
        case FunAndSatisfaction = "Joyfully productive activity"
        case GrowthAndSatisfaction = "Promising potential and reward"
        case GreaterThanForty = "A Benchmark Model"
        case LessThanForty = "Oh!Let's keep this activity aside."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newActivity != nil {
            settingUpSliders()
        }

        funSlider.value = funSliderValue
        growthSlider.value = growthSliderValue
        satisfactionSlider.value = satisfactionSliderValue
        
//        if finalReview == "Nice Growth Factor" {
//            reviewLabel.isHidden = true
//        } else {
//            reviewLabel.isHidden = false
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: UIButton) {
        
        addingReviewLabelString()
        reviewDelegate.sendValue(fun: funSliderValue, growth: growthSliderValue, satisfaction: satisfactionSliderValue, finalReview: finalReview)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func funSliderValueChanged(sender: UISlider) {
        funSliderValue = roundingSliderValues(slider: sender)
        activityReview[0] = funSliderValue
        addingReviewLabelString()
    }
    
    @IBAction func growthSliderValueChanged(sender: UISlider) {
        growthSliderValue = roundingSliderValues(slider: sender)
        activityReview[1] = growthSliderValue
        addingReviewLabelString()
    }
    
    @IBAction func satisfactionSliderValueChanged(sender: UISlider) {
        satisfactionSliderValue = roundingSliderValues(slider: sender)
        activityReview[2] = satisfactionSliderValue
        addingReviewLabelString()
    }
    
    func roundingSliderValues(slider: UISlider) -> Float {
        let roundedValue = round(slider.value / step) * step
        slider.value = roundedValue
        return slider.value
    }
    
    func addingReviewLabelString() {
        
//        reviewLabel.isHidden = false
        
        let x = max(max(activityReview[0], activityReview[1]),activityReview[2])
        
        if x >= 40 {
            if activityReview[0] == activityReview[1] && activityReview[0] == activityReview[2] {
                reviewLabel.text = FinalReview.GreaterThanForty.rawValue
            }else if activityReview[0] == activityReview[1] && activityReview[0] == x {
                reviewLabel.text = FinalReview.FunAndGrowth.rawValue
            } else if activityReview[0] == activityReview[2] && activityReview[0] == x {
                reviewLabel.text = FinalReview.FunAndSatisfaction.rawValue
            } else if activityReview[1] == activityReview[2] && activityReview[1] == x {
                reviewLabel.text = FinalReview.GrowthAndSatisfaction.rawValue
            } else {
                for y in activityReview where y == x {
                    if let index = activityReview.index(of: y) {
                        switch index {
                        case 0:
                            reviewLabel.text = FinalReview.Fun.rawValue
                        case 1:
                            reviewLabel.text = FinalReview.Growth.rawValue
                        case 2:
                            reviewLabel.text = FinalReview.Satisfaction.rawValue
                        default:
                            reviewLabel.text = "Generic"
                        }
                    }
                    
                }
            
            }
        } else {
            print(FinalReview.LessThanForty.hashValue)
            print(FinalReview.LessThanForty.rawValue)
            reviewLabel.text = FinalReview.LessThanForty.rawValue
        }
        
        if let reviewLabelText = reviewLabel.text {
            finalReview = reviewLabelText
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

