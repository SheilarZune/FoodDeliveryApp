//
//  MenuFloatingPanelController.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import FloatingPanel

@objc public protocol MenuFloatingPanelLayoutChangesDelegate: AnyObject {
    @objc optional func floatingPanelDidChangeState(to state: FloatingPanelState)
    @objc optional func floatingPanelDidMoved(y: CGFloat)
    @objc optional func floatingPanelDidEndAttracting()
}

public class MenuFloatingPanelController: FloatingPanelController, FloatingPanelControllerDelegate {
    
    var maxY: CGFloat = 0
    var minY: CGFloat = 0
    var isInitialLoad: Bool = true
    
    var backgroundColor: UIColor = .white
    
    public weak var layoutChangesDelegate: MenuFloatingPanelLayoutChangesDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        surfaceView.grabberHandleSize = .zero
        surfaceView.grabberHandle.isHidden = true
        surfaceView.backgroundColor = backgroundColor
        surfaceView.cornerRadius = 30
        backdropView.backgroundColor = .clear
        delegate = self
    }
    
    public func set(initialTopInset: CGFloat, finalTopInset: CGFloat) {
        panGestureRecognizer.isEnabled = true
        layout = MenuFloatingPanelLayout(initialTopInset: initialTopInset, finalTopInset: finalTopInset)
        invalidateLayout()
    }
  
    public func floatingPanelShouldBeginDragging(_ fpc: FloatingPanelController) -> Bool {
        return true
    }
    
    public func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        let loc = fpc.surfaceLocation
        if loc.y > maxY {
            fpc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
        }
        layoutChangesDelegate?.floatingPanelDidMoved?(y: loc.y)
    }
    
    public func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        layoutChangesDelegate?.floatingPanelDidChangeState?(to: fpc.state)
    }
    
    public func floatingPanelDidEndAttracting(_ fpc: FloatingPanelController) {
        layoutChangesDelegate?.floatingPanelDidEndAttracting?()
    }
    
    deinit {
        print("deinit: ", self)
    }
}

public class MenuFloatingPanelLayout: FloatingPanelLayout {
    private var initialTopInset: CGFloat
    private var finalTopInset: CGFloat
    
    init(initialTopInset: CGFloat, finalTopInset: CGFloat) {
        self.initialTopInset = initialTopInset
        self.finalTopInset = finalTopInset
    }
    
    public var position: FloatingPanelPosition = .bottom
    public var initialState: FloatingPanelState = .half
    public var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: finalTopInset, edge: .top, referenceGuide: .superview),
            .half: FloatingPanelLayoutAnchor(absoluteInset: initialTopInset, edge: .top, referenceGuide: .superview)
        ]
    }
    
    public func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0
    }
}
