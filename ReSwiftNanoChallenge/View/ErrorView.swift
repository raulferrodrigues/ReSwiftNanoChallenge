//
//  ErrorView.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 19/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        // MARK: - Initializing Xib
        Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // MARK: - Customizing Try Again Button
        tryAgainButton.layer.borderWidth = 1
        tryAgainButton.layer.borderColor = UIColor(named: "VeryDarkGray")?.cgColor
        tryAgainButton.layer.cornerRadius = 5
        tryAgainButton.layer.masksToBounds = true
    }
    
}
