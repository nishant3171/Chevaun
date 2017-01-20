//
//  ReviewMeetingViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 20/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class ReviewMeetingViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var funSlider: UISlider!
    @IBOutlet weak var intellectualSlider: UISlider!
    @IBOutlet weak var emotionalSlider: UISlider!
    
    //MARK: Constans&Variables
    let step: Float = 20
    var funSliderValue: Float = 0
    var intellectualSliderValue: Float = 0
    var emotionalSliderValue: Float = 0
    var activityReview: [Float] = [0,0,0]
    var reviewDelegate: ReviewMeetingViewControllerDelegate!
    var finalReview = String()
    var newFriend: FriendModel?
    
    enum FinalReview: String {
        case Fun = "Fascinating hobby for sure"
        case Growth = "Awesome! An interesting talent"
        case Satisfaction = "Oh! That was indeed fulfilling"
        case FunAndGrowth = "Let's make that a hobby!"
        case FunAndSatisfaction = "Joyfully productive activity"
        case GrowthAndSatisfaction = "Wow! A potentially rewarding skill"
        case GreaterThanForty = "A Benchmark Model"
        case LessThanForty = "Oh!Let's keep this activity aside."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newFriend != nil {
            settingUpSliders()
            reviewLabel.text = newFriend?.review
        } else {
            reviewLabel.isHidden = true
        }
        
        funSlider.value = funSliderValue
        intellectualSlider.value = intellectualSliderValue
        emotionalSlider.value = emotionalSliderValue
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: UIButton) {
        
        addingReviewLabelString()
        reviewDelegate.sendValue(fun: funSliderValue, intellectual: intellectualSliderValue, emotional: emotionalSliderValue, finalReview: finalReview)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func funSliderValueChanged(sender: UISlider) {
        funSliderValue = roundingSliderValues(slider: sender)
        activityReview[0] = funSliderValue
        addingReviewLabelString()
    }
    
    @IBAction func intellectualSliderValueChanged(sender: UISlider) {
        intellectualSliderValue = roundingSliderValues(slider: sender)
        activityReview[1] = intellectualSliderValue
        addingReviewLabelString()
    }
    
    @IBAction func emotionalSliderValueChanged(sender: UISlider) {
        emotionalSliderValue = roundingSliderValues(slider: sender)
        activityReview[2] = emotionalSliderValue
        addingReviewLabelString()
    }
    
    func roundingSliderValues(slider: UISlider) -> Float {
        let roundedValue = round(slider.value / step) * step
        slider.value = roundedValue
        return slider.value
    }
    
    func addingReviewLabelString() {
        
        reviewLabel.isHidden = false
        
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
        
        if let funValue = newFriend?.funPercentage, let growthValue = newFriend?.intellectualPercentage, let satisfactionValue = newFriend?.emotionalPercentage, let review = newFriend?.review {
            funSliderValue = Float(funValue)
            intellectualSliderValue = Float(growthValue)
            emotionalSliderValue = Float(satisfactionValue)
            finalReview = review
        }
        
    }


}
