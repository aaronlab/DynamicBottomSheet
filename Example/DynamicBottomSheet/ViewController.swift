//
//  ViewController.swift
//  DynamicBottomSheet
//
//  Created by aaronLab on 11/07/2021.
//  Copyright (c) 2021 aaronLab. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var bag = DisposeBag()
    
    private let stackView: UIStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 16
            $0.alignment = .fill
            $0.distribution = .fill
        }
    
    private let buttonOpenBottomSheet1: UIButton = UIButton(type: .system)
        .then {
            $0.setTitle("Open Bottom Sheet", for: .normal)
        }
    
    private let buttonOpenBottomSheet2: UIButton = UIButton(type: .system)
        .then {
            $0.setTitle("Open Bottom Sheet2", for: .normal)
        }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindRx()
    }

}

// MARK: - Layout

extension ViewController {
    
    private func configureView() {
        
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        layoutStackView()
        layoutButtonOpenBottomSheet()
    }
    
    private func layoutStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide).priority(.low)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).priority(.low)
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutButtonOpenBottomSheet() {
        stackView.addArrangedSubview(buttonOpenBottomSheet1)
        stackView.addArrangedSubview(buttonOpenBottomSheet2)
    }
    
}

// MARK: - Bind

extension ViewController {
    
    private func bindRx() {
        bindButtons()
    }
    
    private func bindButtons() {
        bindButtonOpenBottomSheet1()
        bindButtonOpenBottomSheet2()
    }
    
    private func bindButtonOpenBottomSheet1() {
        buttonOpenBottomSheet1
            .rx
            .tap
            .bind { [weak self] in
                let bottomSheetViewController = MyBottomSheetViewController()
                
                DispatchQueue.main.async {
                    self?.present(bottomSheetViewController, animated: true)
                }
            }
            .disposed(by: bag)
    }
    
    private func bindButtonOpenBottomSheet2() {
        buttonOpenBottomSheet2
            .rx
            .tap
            .bind { [weak self] in
                let bottomSheetViewController = MyStackViewBottomSheetViewController()
                bottomSheetViewController.contentViewBackgroundColor = .orange
                
                DispatchQueue.main.async {
                    self?.present(bottomSheetViewController, animated: true)
                }
            }
            .disposed(by: bag)
    }
    
}
