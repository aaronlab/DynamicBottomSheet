//
//  DynamicBottomSheetViewController.swift
//  DynamicBottomSheetViewController
//
//  Created by Aaron Lee on 2021/11/05.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

/// Dynamic Bottom Sheet View Controller
///
/// You can easily make a bottom-sheet-styled view controller.
///
/// You can also `override` or `set` a bunch of parameters to design your own bottom sheet view controller,
/// and see their default values respectively when you `option + left` click on the parameters.
/// - `open var backgroundColor: UIColor`
/// - `open var backgroundView: UIView`
/// - `open var contentViewBackgroundColor: UIColor`
/// - `open var height: CGFloat?`
/// - `open var contentView: UIView`
/// - `open var contentViewCornerRadius: CGFloat`
/// - `open var transitionDuration: CGFloat`
/// - `open var dismissVelocityThreshold: CGFloat`
open class DynamicBottomSheetViewController: UIViewController {
    
    // MARK: - Public Properties
    
    /// The background color of the view controller below the content view.
    ///
    /// - `UIColor.black.withAlphaComponent(0.6)` for others.
    open var backgroundColor: UIColor = {
        return .black.withAlphaComponent(0.6)
    }()
    
    /// Background view
    open var backgroundView = UIView()
    
    /// The background color of the content view.
    ///
    /// Default value
    /// - `UIColor.tertiarySystemBackground` for iOS 13 or later.
    /// - `UIColor.white` for others.
    open var contentViewBackgroundColor: UIColor = {
        if #available(iOS 13, *) {
            return .tertiarySystemBackground
        }
        
        return .white
    }()
    
    private var _height: CGFloat? = nil
    /// The height of the content view.
    ///
    /// Default value is `nil`
    ///
    /// If you set this value explicitly, the height of the content view will be fixed.
    open var height: CGFloat? {
        get {
            return _height
        }
        set {
            _height = newValue
        }
    }
    
    /// Content view
    open var contentView: UIView = UIView()
    
    /// Corner radius of the content view(top left, top right)
    ///
    /// Default value is `16.0`
    open var contentViewCornerRadius: CGFloat = 16
    
    /// Present / Dismiss transition duration
    ///
    /// Default value is 0.3
    open var transitionDuration: CGFloat = 0.3
    
    /// Dismiss velocity threshold
    ///
    /// Default value is 500
    open var dismissVelocityThreshold: CGFloat = 500
    
    // MARK: - Private Properties
    
    /// Dispose bag for Rx
    private var bag = DisposeBag()
    
    /// The origin vertical centre of the content view
    private var originCentreY: CGFloat = .zero
    
    // MARK: - Init
    
    /// Initialize with parameters below.
    ///
    /// Default values
    ///
    /// - `modalPresentationStyle = .overFullScreen`
    /// - `modalTransitionStyle = .crossDissolve`
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        initPresentationStyle()
    }
    
    /// Initialize with parameters below.
    ///
    /// Default values
    ///
    /// - `modalPresentationStyle = .overFullScreen`
    /// - `modalTransitionStyle = .crossDissolve`
    public init(modalPresentationStyle: UIModalPresentationStyle = .overFullScreen,
                modalTransitionStyle: UIModalTransitionStyle = .crossDissolve) {
        super.init(nibName: nil, bundle: nil)
        
        initPresentationStyle(modalPresentationStyle: modalPresentationStyle,
                              modalTransitionStyle: modalTransitionStyle)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        initPresentationStyle()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initPresentationStyle()
    }
    
    /// This method defines of two initial values of the view controller
    ///
    /// Default values
    ///
    /// - `modalPresentationStyle = .overFullScreen`
    /// - `modalTransitionStyle = .crossDissolve`
    open func initPresentationStyle(modalPresentationStyle: UIModalPresentationStyle = .overFullScreen,
                                    modalTransitionStyle: UIModalTransitionStyle = .crossDissolve) {
        self.modalPresentationStyle = modalPresentationStyle
        self.modalTransitionStyle = modalTransitionStyle
    }
    
    // MARK: - Lifecycle
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        curveTopCorners()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindRx()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.showBottomSheet()
        }
    }
    
    // MARK: - Helper
    
    /// This method shows the bottom sheet animation on `viewWillAppear`
    open func showBottomSheet() {
        originCentreY = contentView.center.y
        
        let contentViewHeight = contentView.frame.height
        contentView.center.y += contentViewHeight
        
        UIView.animate(withDuration: transitionDuration) {
            self.contentView.center.y -= contentViewHeight
        }
    }
    
    /// This method makes the content view curved.
    ///
    /// This is called on `viewDidLayoutSubviews`
    open func curveTopCorners() {
        let size = CGSize(width: contentViewCornerRadius, height: .zero)
        
        let path = UIBezierPath(roundedRect: contentView.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: size)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = contentView.bounds
        maskLayer.path = path.cgPath
        contentView.layer.mask = maskLayer
    }
    
}

// MARK: - Layout

extension DynamicBottomSheetViewController {
    
    /// This method configures the whole view.
    @objc
    open func configureView() {
        view.backgroundColor = .clear
        
        layoutBackgroundView()
        layoutContentView()
    }
    
    /// This method layouts the background view.
    @objc
    open func layoutBackgroundView() {
        backgroundView.backgroundColor = backgroundColor
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    /// This method layouts the content view.
    ///
    /// If the `height` property of the view controller is not `nil`, the height of the content view will be fixed.
    @objc
    open func layoutContentView() {
        contentView.backgroundColor = contentViewBackgroundColor
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.lessThanOrEqualToSuperview().priority(.low)
        }
        
        // Fixd height
        if let height = height {
            contentView.snp.makeConstraints {
                $0.height.equalTo(height)
            }
        }
    }
    
}

// MARK: - Bind

extension DynamicBottomSheetViewController {
    
    /// Bind Rx
    private func bindRx() {
        bindBackgroundViewTapGesture()
        bindContentViewPanGesture()
    }
    
    /// Bind the tap gesture on the background view.
    private func bindBackgroundViewTapGesture() {
        backgroundView
            .rx
            .gesture(.tap(configuration: { _, delegate in
                delegate.simultaneousRecognitionPolicy = .never
            }))
            .when(.recognized)
            .bind { [weak self] gesture in
                DispatchQueue.main.async {
                    self?.shouldDismissSheet()
                }
            }
            .disposed(by: bag)
    }
    
    /// This method will dismiss the bottom sheet.
    ///
    /// This is called when you tap the background view or swipe down on the content view.
    @objc
    open func shouldDismissSheet() {
        let contentViewHeight = contentView.frame.height
        
        UIView.animate(withDuration: transitionDuration) {
            self.contentView.center.y += contentViewHeight
            self.backgroundView.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: false)
        }
        
    }
    
    /// Bind the pan gesture on the content view.
    private func bindContentViewPanGesture() {
        contentView
            .rx
            .gesture(.pan(configuration: nil))
            .bind { [weak self] gesture in
                guard let self = self,
                      let gesture = gesture as? UIPanGestureRecognizer else { return }
                
                self.contentViewDidPan(gesture, in: self.contentView)
            }
            .disposed(by: bag)
    }
    
    /// When the content view is panned.
    ///
    /// This method is called when you pan the content view.
    @objc
    open func contentViewDidPan(_ gesture: UIPanGestureRecognizer, in view: UIView) {
        
        if gesture.state == .changed {
            contentViewPanGestureDidChange(gesture, in: view)
        }
        
        if gesture.state == .ended {
            contentViewPanGestureDidEnd(gesture, in: view)
        }
    }
    
    /// This method is called when the pan gesture on the content view is detected.
    @objc
    open func contentViewPanGestureDidChange(_ gesture: UIPanGestureRecognizer, in view: UIView) {
        guard gesture.view != nil else { return }
        
        let translation = gesture.translation(in: view)
        let translatedY = gesture.view!.center.y + translation.y
        
        if translatedY < originCentreY {
            
            if gesture.view!.center.y > originCentreY {
                gesture.view!.center.y = originCentreY
            }
            
            return
        }
        
        gesture.view!.center = CGPoint(x: gesture.view!.center.x, y: translatedY)
        
        gesture.setTranslation(.zero, in: view)
        
        let ratio = (view.center.y - originCentreY) / originCentreY
        let alpha = 1 - ratio
        dimBackgroundView(alpha)
        
    }
    
    
    /// This changes the alpha of the background view.
    ///
    ///
    /// - Parameter proportion: The alpha value of the background view.
    @objc
    open func dimBackgroundView(_ proportion: CGFloat) {
        UIView.animate(withDuration: transitionDuration) {
            self.backgroundView.alpha = proportion
        }
    }
    
    /// This method is called when the pan gesture is ended.
    @objc
    open func contentViewPanGestureDidEnd(_ gesture: UIPanGestureRecognizer, in view: UIView) {
        guard shouldDismiss(gesture, in: view, threshold: dismissVelocityThreshold) else {
            
            DispatchQueue.main.async {
                self.shouldRestoreSheet()
            }
            
            return
        }
        
        DispatchQueue.main.async {
            self.shouldDismissSheet()
        }
    }
    
    /// This method defines if the bottom sheet should be dismissed or not.
    @objc
    open func shouldDismiss(_ gesture: UIPanGestureRecognizer, in view: UIView, threshold: CGFloat) -> Bool {
        let verticalVelocity = verticalVelocity(gesture, in: view)
        let movedDownHalf = view.frame.minY >= originCentreY
        
        return verticalVelocity > dismissVelocityThreshold || movedDownHalf
    }
    
    /// This method returns the vertical velocity of the pan gesture in the content view.
    @objc
    open func verticalVelocity(_ gesture: UIPanGestureRecognizer, in view: UIView) -> CGFloat {
        let velocity = gesture.velocity(in: view)
        
        return velocity.y
    }
    
    /// This method restores the first position of the content view.
    @objc
    open func shouldRestoreSheet() {
        UIView.animate(withDuration: transitionDuration) {
            self.contentView.center.y = self.originCentreY
            self.backgroundView.alpha = 1
        }
        
    }
    
}
