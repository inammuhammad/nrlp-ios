//
//  NotificationBellView.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 16/05/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class NotificationBellView: UIView {
    private static let BUFFER = 4.0
    
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
    
    init(title: String, frame: CGRect) {
        // Workaround to get Text Width
        titleLabel.text = title.localized
        
        super.init(
            frame:
                CGRect(
                    origin: frame.origin,
                    size: CGSize(
                        width: frame.width + titleLabel.intrinsicContentSize.width + Self.BUFFER,
                        height: frame.height
                    )
                )
        )
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private var bellLayer = CALayer()
    private var countTextLayer = CATextLayer()
    private var titleTextLayer = VerticalCenterTextLayer()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)
        return label
    }()
    
    private func setupUI() {
        let layoutDir = UIView.appearance().semanticContentAttribute
        
        let height = self.bounds.height
        var width = self.titleLabel.intrinsicContentSize.width
        
        titleTextLayer.frame = CGRect(
            origin: CGPoint(
                x: layoutDir == .forceRightToLeft ? self.frame.width - width : 0,
                y: 0
            ),
            size: CGSize(
                width: layoutDir == .forceRightToLeft ? self.frame.width : width,
                height: height
            )
        )
        titleTextLayer.string = titleLabel.text
        titleTextLayer.alignmentMode = layoutDir == .forceRightToLeft ? .left : .right
        titleTextLayer.backgroundColor = UIColor.clear.cgColor
        titleTextLayer.foregroundColor = UIColor.black.cgColor
        titleTextLayer.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)
        titleTextLayer.fontSize = CommonFontSizes.largeFontSize.rawValue
        titleTextLayer.contentsScale = UIScreen.main.scale
        
        var x = width
        width = self.frame.width - width
        
        bellLayer.frame = CGRect(
            origin: CGPoint(
                x: layoutDir == .forceRightToLeft ? width * 0.4 : x + Self.BUFFER,
                y: height * 0.2
            ),
            size: CGSize(
                width: width * 0.6,
                height: height * 0.8
            )
        )
        
        bellLayer.contents = UIImage(named: "bell")?.cgImage
        
        x += width * 0.6
        
        countTextLayer.frame = CGRect(
            origin: CGPoint(
                x: layoutDir == .forceRightToLeft ? 0 : x + Self.BUFFER,
                y: 0
            ),
            size: CGSize(
                width: width * 0.4,
                height: height
            )
        )
        countTextLayer.string = "\(count)"
        countTextLayer.alignmentMode = layoutDir == .forceRightToLeft ? .right : .left
        countTextLayer.backgroundColor = UIColor.clear.cgColor
        countTextLayer.foregroundColor = UIColor.black.cgColor
        countTextLayer.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize)
        countTextLayer.fontSize = CommonFontSizes.smallFontSize.rawValue
        countTextLayer.contentsScale = UIScreen.main.scale
        
        // titleTextLayer.
        
        self.layer.addSublayer(bellLayer)
        self.layer.addSublayer(countTextLayer)
        self.layer.addSublayer(titleTextLayer)
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(bellTapped))
        )
    }
    
    @objc func bellTapped() {
        onTap?()
    }
}
