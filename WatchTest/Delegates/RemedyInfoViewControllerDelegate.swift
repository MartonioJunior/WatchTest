//
//  RemedyInfoViewControllerDelegate.swift
//  WatchTest
//
//  Created by Ada 2018 on 02/10/2018.
//  Copyright © 2018 ifce. All rights reserved.
//

import Foundation

protocol RemedyInfoViewControllerDelegate {
    func takeRemedyButtonPressed(forRemedy: CDRemedy)
    func delayRemedyButtonPressed(forRemedy: CDRemedy)
}
