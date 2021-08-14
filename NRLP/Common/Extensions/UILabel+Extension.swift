//
//  UILable+SemanticExtension.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 30/12/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// This function ensures RightToLeft Semantic for urdu language
    /// and LeftToRight Semantic for english langauge
    func languageEnforcedSemantics () {
        self.semanticContentAttribute = AppConstants.isAppLanguageUrdu ? UISemanticContentAttribute.forceRightToLeft : UISemanticContentAttribute.forceLeftToRight
    }
}
