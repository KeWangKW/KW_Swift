

import UIKit

class KWNavigationController: UINavigationController {

    // MARK: -  属性
    
    private lazy var fakeBar: KWFakeNavigationBar = {
        let fakeBar = KWFakeNavigationBar()
        return fakeBar
    }()
    
    private lazy var fromFakeBar: KWFakeNavigationBar = {
        let fakeBar = KWFakeNavigationBar()
        return fakeBar
    }()
    
    private lazy var toFakeBar: KWFakeNavigationBar = {
        let fakeBar = KWFakeNavigationBar()
        return fakeBar
    }()
    
    private var fakeSuperView: UIView? {
        get {
            return navigationBar.subviews.first
        }
    }
    
    private weak var poppingVC: UIViewController?
    private var fakeFrameObserver: NSKeyValueObservation?

    // MARK: -  override

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.addTarget(self, action: #selector(handleinteractivePopGesture(gesture:)))
        setupNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let coordinator = transitionCoordinator {
            guard let fromVC = coordinator.viewController(forKey: .from) else { return }
            if fromVC == poppingVC {
                kw_updateNavigationBar(for: fromVC)
            }
        } else {
            guard let topViewController = topViewController else { return }
            kw_updateNavigationBar(for: topViewController)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutFakeSubviews()
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        poppingVC = topViewController
        let viewController = super.popViewController(animated: animated)
        if let topViewController = topViewController {
            kw_updateNavigationBarTint(for: topViewController, ignoreTintColor: true)
        }
        return viewController
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        poppingVC = topViewController
        let vcArray = super.popToRootViewController(animated: animated)
        if let topViewController = topViewController {
            kw_updateNavigationBarTint(for: topViewController, ignoreTintColor: true)
        }
        return vcArray
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        poppingVC = topViewController
        let vcArray = super.popToViewController(viewController, animated: animated)
        if let topViewController = topViewController {
            kw_updateNavigationBarTint(for: topViewController, ignoreTintColor: true)
        }
        return vcArray
    }
    
}

// MARK: -  Private Methods
extension KWNavigationController {
    
    private func setupNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        setupFakeSubviews()
    }
    
    private func setupFakeSubviews() {
        guard let fakeSuperView = fakeSuperView else { return }
        if fakeBar.superview == nil {
            fakeFrameObserver = fakeSuperView.observe(\.frame, changeHandler: { [weak self] (obj, changed) in
                guard let `self` = self else { return }
                self.layoutFakeSubviews()
            })
            fakeSuperView.insertSubview(fakeBar, at: 0)
        }
    }
    
    private func layoutFakeSubviews() {
        guard let fakeSuperView = fakeSuperView else { return }
        fakeBar.frame = fakeSuperView.bounds
        fakeBar.setNeedsLayout()
    }
    
    @objc private func handleinteractivePopGesture(gesture: UIScreenEdgePanGestureRecognizer) {
        guard let coordinator = transitionCoordinator,
            let fromVC = coordinator.viewController(forKey: .from),
            let toVC = coordinator.viewController(forKey: .to) else {
                return
        }
        if gesture.state == .changed {
            navigationBar.tintColor = average(fromColor: fromVC.kw_tintColor, toColor: toVC.kw_tintColor, percent: coordinator.percentComplete)
        }
    }
    
    private func average(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        let red = fromRed + (toRed - fromRed) * percent
        let green = fromGreen + (toGreen - fromGreen) * percent
        let blue = fromBlue + (toBlue - fromBlue) * percent
        let alpha = fromAlpha + (toAlpha - fromAlpha) * percent
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private func showViewController(_ viewController: UIViewController, coordinator: UIViewControllerTransitionCoordinator) {
        guard let fromVC = coordinator.viewController(forKey: .from),
            let toVC = coordinator.viewController(forKey: .to) else {
                return
        }
        resetButtonLabels(in: navigationBar)
        coordinator.animate(alongsideTransition: { (context) in
            self.kw_updateNavigationBarTint(for: viewController, ignoreTintColor: context.isInteractive)
            if viewController == toVC {
                self.showTempFakeBar(fromVC: fromVC, toVC: toVC)
            } else {
                self.kw_updateNavigationBarBackground(for: viewController)
                self.kw_updateNavigationBarShadow(for: viewController)
            }
        }) { (context) in
            if context.isCancelled {
                self.kw_updateNavigationBar(for: fromVC)
            } else {
                self.kw_updateNavigationBar(for: viewController)
            }
            if viewController == toVC {
                self.clearTempFakeBar()
            }
        }
    }
    
    private func showTempFakeBar(fromVC: UIViewController, toVC: UIViewController) {
        UIView.setAnimationsEnabled(false)
        fakeBar.alpha = 0
        // from
        fromVC.view.addSubview(fromFakeBar)
        fromFakeBar.frame = fakerBarFrame(for: fromVC)
        fromFakeBar.setNeedsLayout()
        fromFakeBar.kw_updateFakeBarBackground(for: fromVC)
        fromFakeBar.kw_updateFakeBarShadow(for: fromVC)
        // to
        toVC.view.addSubview(toFakeBar)
        toFakeBar.frame = fakerBarFrame(for: toVC)
        toFakeBar.setNeedsLayout()
        toFakeBar.kw_updateFakeBarBackground(for: toVC)
        toFakeBar.kw_updateFakeBarShadow(for: toVC)
        UIView.setAnimationsEnabled(true)
    }
    
    private func clearTempFakeBar() {
        fakeBar.alpha = 1
        fromFakeBar.removeFromSuperview()
        toFakeBar.removeFromSuperview()
    }
    
    private func fakerBarFrame(for viewController: UIViewController) -> CGRect {
        guard let fakeSuperView = fakeSuperView else {
            return navigationBar.frame
        }
        var frame = navigationBar.convert(fakeSuperView.frame, to: viewController.view)
        frame.origin.x = viewController.view.frame.origin.x
        return frame
    }
    
    private func resetButtonLabels(in view: UIView) {
        let viewClassName = view.classForCoder.description().replacingOccurrences(of: "_", with: "")
        if viewClassName == "UIButtonLabel" {
            view.alpha = 1
        } else {
            if view.subviews.count > 0 {
                for subview in view.subviews {
                    resetButtonLabels(in: subview)
                }
            }
        }
    }

}

// MARK: -  UINavigationControllerDelegate
extension KWNavigationController: UINavigationControllerDelegate {
 
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let coordinator = transitionCoordinator {
            showViewController(viewController, coordinator: coordinator)
        } else {
            if !animated && viewControllers.count > 1 {
                let lastButOneVC = viewControllers[viewControllers.count - 2]
                showTempFakeBar(fromVC: lastButOneVC, toVC: viewController)
                return
            }
            kw_updateNavigationBar(for: viewController)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if !animated {
            kw_updateNavigationBar(for: viewController)
            clearTempFakeBar()
        }
        poppingVC = nil
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}

// MARK: -  UIGestureRecognizerDelegate
extension KWNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 {
            return false
        }
        if let topViewController = topViewController {
            return topViewController.kw_enablePopGesture
        }
        return true
    }
    
}

// MARK: -  Public
extension KWNavigationController {
    
    func kw_updateNavigationBar(for viewController: UIViewController) {
        setupFakeSubviews()
        kw_updateNavigationBarTint(for: viewController)
        kw_updateNavigationBarBackground(for: viewController)
        kw_updateNavigationBarShadow(for: viewController)
    }
    
    func kw_updateNavigationBarTint(for viewController: UIViewController, ignoreTintColor: Bool = false) {
        if viewController != topViewController {
            return
        }
        UIView.setAnimationsEnabled(false)
        navigationBar.barStyle = viewController.kw_barStyle
        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: viewController.kw_titleColor,
            NSAttributedString.Key.font: viewController.kw_titleFont
        ]
        navigationBar.titleTextAttributes = titleTextAttributes
        if !ignoreTintColor {
            navigationBar.tintColor = viewController.kw_tintColor
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func kw_updateNavigationBarBackground(for viewController: UIViewController) {
        if viewController != topViewController {
            return
        }
        fakeBar.kw_updateFakeBarBackground(for: viewController)
    }
    
    func kw_updateNavigationBarShadow(for viewController: UIViewController) {
        if viewController != topViewController {
            return
        }
        fakeBar.kw_updateFakeBarShadow(for: viewController)
    }

}
