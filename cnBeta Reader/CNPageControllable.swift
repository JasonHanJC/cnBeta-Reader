//
//  CNPageControllable.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 3/31/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

protocol CNPagaControllable: class {
    var numberOfPages: Int { get set }
    var currentPage: Int { get }
    var progress: Double { get set }
    var hideForSinglePage: Bool { get set }
    var borderWidth: CGFloat { get set }
    
    func set(progress: Int, animated: Bool)
}
