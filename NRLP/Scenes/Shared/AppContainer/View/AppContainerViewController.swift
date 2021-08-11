//
//  AppContainerViewController.swift
//  1Link-NRLP
//
//  Created by VenD on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class AppContainerViewController: UIViewController {
    private enum SlideOutState {
        case collapsed
        case leftPanelExpanded
    }

    var centerNavigationController: UINavigationController! {
        didSet {
            view.addSubview(centerNavigationController.view)
            addChild(centerNavigationController)

            centerNavigationController.didMove(toParent: self)

            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        }
    }
    var centerViewController: HomeViewController! {
        didSet {
            centerViewController.sideMenuDelegate = self
        }
    }

    private var currentState: SlideOutState = .collapsed

    private lazy var sideMenu: SideMenuViewController? = {
       return SideMenuModuleBuilder().build(with: viewModel.userModel) as? SideMenuViewController
    }()

    private var leftViewController: SideMenuViewController?
    private var navigationSideMenuActiveOverlayView: UIView!
    private let centerPanelExpandedOffset: CGFloat = UIScreen.main.bounds.width * 0.2
    var viewModel: AppContainerViewModel!
}

// MARK: CenterViewController delegate
extension AppContainerViewController: HomeSideMenuViewControllerDelegate {
    func toggleNavigationPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)

        if notAlreadyExpanded {
            addLeftPanelViewController()
        }

        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }

    private func addLeftPanelViewController() {
        guard leftViewController == nil else { return }

        if let vc = sideMenu {
            addChildSidePanelController(vc)
            vc.sideMenuNavigationDelegate = centerViewController
            leftViewController = vc
        }
    }

    private func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
        } else {
            self.navigationSideMenuActiveOverlayView?.removeFromSuperview()
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .collapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }

    func collapseSidePanel() {
        switch currentState {
        case .leftPanelExpanded:
            toggleNavigationPanel()
        default:
            break
        }
    }

    private func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut, animations: {
                        self.centerNavigationController.view.frame.origin.x = AppConstants.appLanguage == .english ? targetPosition : -targetPosition
        }, completion: completion)
    }

    private func addChildSidePanelController(_ sidePanelController: SideMenuViewController) {
        //    sidePanelController.delegate = centerViewController
        view.insertSubview(sidePanelController.view, at: 0)
        centerNavigationController.view.addSubview(getGrayContentScreenOverlay())
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }

    private func getGrayContentScreenOverlay() -> UIView {
        if navigationSideMenuActiveOverlayView != nil {
            return navigationSideMenuActiveOverlayView
        }
        navigationSideMenuActiveOverlayView = UIView(frame: centerNavigationController.view.bounds)
        navigationSideMenuActiveOverlayView.backgroundColor = UIColor.init(commonColor: .appBackgroundDarkOverlay)

        navigationSideMenuActiveOverlayView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlayView))
        navigationSideMenuActiveOverlayView.addGestureRecognizer(tapGesture)

        return navigationSideMenuActiveOverlayView
    }

    @objc
    private func didTapOverlayView() {
        collapseSidePanel()
    }

}

// MARK: Gesture recognizer

extension AppContainerViewController: UIGestureRecognizerDelegate {
    @objc
    private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        let gestureIsDraggingFromRightToLeft = (recognizer.velocity(in: view).x < 0)
        if !(centerNavigationController.visibleViewController is HomeViewController) {
            return
        }
        switch recognizer.state {
        case .began:
            if currentState == .collapsed {
                if gestureIsDraggingFromLeftToRight && AppConstants.appLanguage == .english {
                    addLeftPanelViewController()
                } else if gestureIsDraggingFromRightToLeft && AppConstants.appLanguage == .urdu {
                    addLeftPanelViewController()
                } else {
                    break
                }
            }

        case .changed:
            if !gestureIsDraggingFromLeftToRight && AppConstants.appLanguage == .english && currentState == .collapsed {
                break
            }
            if !gestureIsDraggingFromRightToLeft && AppConstants.appLanguage == .urdu && currentState == .collapsed {
                break
            }
            if let rview = recognizer.view,
            rview.frame.minX < UIScreen.main.bounds.width - centerPanelExpandedOffset {
                rview.center.x += recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }

        case .ended:
            if leftViewController != nil,
                let rview = recognizer.view,
                (
                    (gestureIsDraggingFromLeftToRight && currentState == .collapsed) ||
                        (!gestureIsDraggingFromLeftToRight && currentState != .collapsed) ||
                    (gestureIsDraggingFromRightToLeft && currentState == .collapsed) ||
                    (!gestureIsDraggingFromRightToLeft && currentState != .collapsed)
                ) {

                let hasMovedGreaterThanHalfway = AppConstants.appLanguage == .english ? rview.center.x > view.bounds.size.width : rview.center.x < view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            } else {
                animateLeftPanel(shouldExpand: false)
            }

        default:
            break
        }
    }
}
