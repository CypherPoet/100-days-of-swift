//
//  CoreImageFilterName.swift
//  Instafilter
//
//  Created by Brian Sipple on 4/5/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

enum CoreImageFilterName: String, CaseIterable {
    case bumpDistortion = "CIBumpDistortion"
    case gaussianBlur = "CIGaussianBlur"
    case pixellate = "CIPixellate"
    case motionBlur = "CIMotionBlur"
    case sepiaTone = "CISepiaTone"
    case twirlDistortion = "CITwirlDistortion"
    case unsharpMask = "CIUnsharpMask"
    case vignette = "CIVignette"
    case colorInvert = "CIColorInvert"
    case crystallize = "CICrystallize"
}
