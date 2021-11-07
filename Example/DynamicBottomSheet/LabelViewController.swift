//
//  LabelViewController.swift
//  DynamicBottomSheet_Example
//
//  Created by Aaron Lee on 2021/11/07.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

class LabelViewController: UIViewController {
    
    // MARK: - Public Properties
    
    public var label = UILabel()
        .then {
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Layout
    
    private func configureView() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .tertiarySystemBackground
        } else {
            view.backgroundColor = .white
        }
        
        layoutLabel()
    }
    
    private func layoutLabel() {
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
}
