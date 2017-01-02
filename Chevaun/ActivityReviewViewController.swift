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

    @IBOutlet weak var funSlider: UISlider!
    @IBOutlet weak var growthSlider: UISlider!
    @IBOutlet weak var satisfactionSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        funSlider.value = funSliderValue
        growthSlider.value = growthSliderValue
        satisfactionSlider.value = satisfactionSliderValue
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: UIButton) {
        

        reviewDelegate.sendValue(fun: funSliderValue, growth: growthSliderValue, satisfaction: satisfactionSliderValue)
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
    
}

