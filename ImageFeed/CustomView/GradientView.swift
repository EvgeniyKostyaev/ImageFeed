//
//  GradientView.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 07.02.2025.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()

    @IBInspectable var startColor: UIColor = UIColor.clear {
        didSet { updateGradient() }
    }

    @IBInspectable var endColor: UIColor = UIColor.black.withAlphaComponent(0.2) {
        didSet { updateGradient() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.frame = bounds
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
