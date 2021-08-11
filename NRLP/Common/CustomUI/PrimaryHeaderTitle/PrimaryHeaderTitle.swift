//
//  PrimaryHeaderTitle.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class PrimaryHeaderTitle: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()

        self.textColor = .black
        self.font = UIFont.init(commonFont: CommonFont.GaramondFontStyle.bold, size: .ultraLargeFontSize)
    }
}
