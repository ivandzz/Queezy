//
//  QButton.swift
//  Queezy
//
//  Created by Іван Джулинський on 17/09/24.
//

import UIKit

class QButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        setTitleColor(.label, for: .normal)
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
    }
}
