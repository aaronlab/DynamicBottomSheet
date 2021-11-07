//
//  MyStackViewBottomSheetViewController.swift
//  DynamicBottomSheet_Example
//
//  Created by Aaron Lee on 2021/11/07.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import DynamicBottomSheet

class MyStackViewBottomSheetViewController: DynamicBottomSheetViewController {
    
    // MARK: - Private Properties
    
    private let stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 32
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
    
}

// MARK: - Layout

extension MyStackViewBottomSheetViewController {
    
    override func configureView() {
        super.configureView()
        layoutStackView()
    }
    
    private func layoutStackView() {
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        Array(1...5).forEach {
            
            let label = UILabel()
            label.text = "\($0)"
            stackView.addArrangedSubview(label)
            
        }
        
    }
    
}
