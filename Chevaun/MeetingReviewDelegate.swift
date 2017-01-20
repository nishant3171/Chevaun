//
//  MeetingReviewDelegate.swift
//  Chevaun
//
//  Created by Nishant Punia on 20/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import Foundation

protocol ReviewMeetingViewControllerDelegate {
    
    func sendValue(fun:Float, intellectual: Float, emotional: Float, finalReview: String)
    
}
