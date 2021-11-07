//
//  MyBottomSheetViewController.swift
//  DynamicBottomSheet_Example
//
//  Created by Aaron Lee on 2021/11/07.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import DynamicBottomSheet

class MyBottomSheetViewController: DynamicBottomSheetViewController {
    
    // MARK: - Private Properties
    
    override open var height: CGFloat? {
        get {
            return view.frame.height / 2
        }
        set {
            super.height = newValue
        }
    }
    
}

// MARK: - Layout

extension MyBottomSheetViewController {
    
    override func configureView() {
        super.configureView()
        embedContentViewController()
    }
    
    private func embedContentViewController() {
        let subViewController = MyViewController()
        
        let navigationViewController = UINavigationController(rootViewController: subViewController)
        navigationViewController.setNavigationBarHidden(false, animated: false)
        
        addChildViewController(navigationViewController)
        
        contentView.addSubview(navigationViewController.view)
        navigationViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        navigationViewController.didMove(toParentViewController: self)
        
    }
    
}
