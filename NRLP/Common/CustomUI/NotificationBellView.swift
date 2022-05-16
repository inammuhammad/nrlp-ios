//
//  NotificationBellView.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 16/05/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class NotificationBellView: UIView {
    var onTap: (() -> Void)?
    var count: Int = 0 {
        didSet {
            self.countTextLayer.string = "\(count)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private var bellLayer = CALayer()
    private var countTextLayer = VerticalCenterTextLayer()

    private func setupUI() {
        let height = self.bounds.height
        let width = self.bounds.width
        
        let bellMultiplier = 0.9
        bellLayer.frame = CGRect(
            origin: CGPoint(
                x: 0,
                y: width * (1 - bellMultiplier)
            ),
            size: CGSize(
                width: width * bellMultiplier,
                height: height * bellMultiplier
            )
        )
        
        bellLayer.contents = UIImage(named: "bell")?.cgImage
        
        self.layer.addSublayer(bellLayer)
        
        let countMultiplier = 0.6
        countTextLayer.frame = CGRect(
            origin: CGPoint(
                x: width * (1 - countMultiplier),
                y: 0
            ),
            size: CGSize(
                width: width * countMultiplier,
                height: height * countMultiplier
            )
        )
        countTextLayer.string = "\(count)"
        countTextLayer.alignmentMode = .center
        countTextLayer.backgroundColor = UIColor.red.cgColor
        countTextLayer.cornerRadius = width * countMultiplier * 0.5
        countTextLayer.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.bold, size: .smallFontSize)
        countTextLayer.fontSize = CommonFontSizes.smallFontSize.rawValue
        self.layer.addSublayer(countTextLayer)
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(bellTapped))
        )
    }
    
    @objc func bellTapped() {
        onTap?()
    }
}
