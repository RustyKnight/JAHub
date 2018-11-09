//
//  Hud.swift
//  JAHud
//
//  Created by Shane Whitehead on 8/9/18.
//  Copyright © 2018 KaiZen. All rights reserved.
//

import Foundation

/*
This a "control center" intended to reduce the complexity of the actual view
*/
public struct Hud {
	
	public struct Configuration {
		public var titleColor: UIColor = UIColor.black
		public var textColor: UIColor = UIColor.black
		
		public var waitIndicatorColor: UIColor = UIColor.black
		public var waitIndicatorStyle: WaitIndicatorStyle = .iOS

		public var contentBackgroundColor: UIColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.75)
		
		public var progress: ProgressConfiguration = ProgressConfiguration()
		
		// Fail and success states
		public var state: StateConfiguration = StateConfiguration()
		
		public init() {}
	}
	
	public struct ProgressConfiguration {
		public var strokeColor: UIColor = .black
		public var strokeWidth: CGFloat = 1
		public var strokeCap: CAShapeLayerLineCap = .round
		
		public init() {}
	}
	
	public enum FillStyle {
		case outlined
		case filled
	}
	
	public struct StateConfiguration {
		public var successColor: UIColor = .black
		public var failColor: UIColor = .black
		public var fillStyle: FillStyle = .outlined
		
		public init() {}
	}
	
	public enum Style {
		case infiniteWait
		case progress
		case success
		case failure
	}
	
	public enum WaitIndicatorStyle {
		case iOS
		case material
	}
	
	// Simplified presentation styles
	// Could just typealias this :/
	public enum PresentationStyle {
		case overCurrentContext
		case overFullScreen
		
		var modalStyle: UIModalPresentationStyle {
			switch self {
			case .overCurrentContext: return UIModalPresentationStyle.overCurrentContext
			case .overFullScreen: return UIModalPresentationStyle.overFullScreen
			}
		}
	}
	
	public static var configuration: Configuration?
	
	public typealias HudThen = () -> Void

	// MARK: - Globle accessible functionality
	
	private static var registery: [UIViewController: HudViewController] = [:]
	
	internal static func present(style: Style,
															 on parent: UIViewController,
															 title: String? = nil,
															 text: String? = nil,
															 progress: Progress? = nil,
															 presentationStyle: PresentationStyle = .overCurrentContext,
															 configuration: Configuration? = nil,
															 then: HudThen? = nil) {
		
		if let hudController = registery[parent] {
			if title != nil && (hudController.title == nil || hudController.title != title) {
				hudController.hudView.title = title
			}
			if text != nil && (hudController.hudView.text == nil || hudController.hudView.text != text) {
				hudController.hudView.text = text
			}
			
			if hudController.hudView.configuration == nil && configuration != nil {
				hudController.hudView.configuration = configuration
			}
			
			hudController.hudView.set(style, then: then)
			return
		}
		
		let hudController = HudViewController()
		hudController.afterAppear = then
		hudController.modalPresentationStyle = presentationStyle.modalStyle
		
		let hudView = hudController.hudView
		hudView.configuration = configuration ?? Hud.configuration
		hudView.title = title
		hudView.text = text
		hudView.set(style)
		hudView.progressIndicatorView.progress = progress
		
		registery[parent] = hudController
		
		parent.present(hudController, animated: false, completion: nil)
		
//		parent.addSubview(hudView)
//		hudView.autoPinEdgesToSuperviewEdges()
	}
	
	// MARK: - Present infinite wait
	
	public static func presentWait(on parent: UIViewController,
																 title: String? = nil,
																 text: String? = nil,
																 presentationStyle: PresentationStyle = .overCurrentContext,
																 configuration: Configuration? = nil, then: HudThen? = nil) {
		present(style: .infiniteWait,
						on: parent,
						title: title,
						text: text,
						presentationStyle: presentationStyle,
						configuration: configuration,
						then: then)
	}
	
//	public static func presentWait(on parent: UIView, title: String? = nil, text: String? = nil,
//																 presentationStyle: PresentationStyle = .overCurrentContext,
//																 configuration: Configuration? = nil, then: HudThen? = nil) {
//		present(style: .infiniteWait,
//						on: parent,
//						title: title,
//						text: text,
//						presentationStyle: presentationStyle,
//						configuration: configuration,
//						then: then)
//	}
	
	// MARK: - Present progress
	
	public static func presentProgress(on controller: UIViewController,
																		 progress: Progress,
																		 title: String? = nil,
																		 text: String? = nil,
																		 presentationStyle: PresentationStyle = .overCurrentContext,
																		 configuration: Configuration? = nil,
																		 then: HudThen? = nil) {
		present(style: .progress,
						on: controller,
						title: title,
						text: text,
						progress: progress,
						presentationStyle: presentationStyle,
						configuration: configuration,
						then: then)
	}
	
//	public static func presentProgress(on view: UIView, progress: Progress, title: String? = nil, text: String? = nil,
//																		 presentationStyle: PresentationStyle = .overCurrentContext,
//																		 configuration: Configuration? = nil, then: HudThen? = nil) {
//		present(style: .progress,
//						on: view,
//						title: title,
//						text: text,
//						progress: progress,
//						presentationStyle: presentationStyle,
//						configuration: configuration,
//						then: then)
//	}
	
	// MARK: - Present success
	
	public static func presentSuccess(on controller: UIViewController, title: String? = nil, text: String? = nil,
																		presentationStyle: PresentationStyle = .overCurrentContext,
																		configuration: Configuration? = nil, then: HudThen? = nil) {
		present(style: .success,
						on: controller,
						title: title,
						text: text,
						presentationStyle: presentationStyle,
						configuration: configuration,
						then: then)
	}
	
//	public static func presentSuccess(on view: UIView, title: String? = nil, text: String? = nil,
//																		presentationStyle: PresentationStyle = .overCurrentContext,
//																		configuration: Configuration? = nil, then: HudThen? = nil) {
//		present(style: .success,
//						on: view,
//						title: title,
//						text: text,
//						presentationStyle: presentationStyle,
//						configuration: configuration,
//						then: then)
//	}
	
	// MARK: - Present success
	
	public static func presentFailure(on controller: UIViewController, title: String? = nil, text: String? = nil,
																		presentationStyle: PresentationStyle = .overCurrentContext,
																		configuration: Configuration? = nil, then: HudThen? = nil) {
		present(style: .failure,
						on: controller,
						title: title,
						text: text,
						presentationStyle: presentationStyle,
						configuration: configuration,
						then: then)
	}
	
//	public static func presentFailure(on view: UIView, title: String? = nil, text: String? = nil,
//																		presentationStyle: PresentationStyle = .overCurrentContext,
//																		configuration: Configuration? = nil, then: HudThen? = nil) {
//		present(style: .failure,
//						on: view,
//						title: title,
//						text: text,
//						presentationStyle: presentationStyle,
//						configuration: configuration,
//						then: then)
//	}
	
	// MARK: - Dismiss
	
	public static func dismiss(from parent: UIViewController, then: HudThen? = nil) {
//		dismiss(from: parent.view, then: then)
		guard let hudController = registery[parent] else {
			then?()
			return
		}
		hudController.dismiss(animated: false) {
			registery[parent] = nil
			then?()
		}
	}
	
//	public static func dismiss(from parent: UIView, then: HudThen? = nil) {
//		guard let hudController = registery[parent] else {
//			then?()
//			return
//		}
//		hudController.dismiss(animated: false) {
//			registery[parent] = nil
//			then?()
//		}
//	}
  
  public static func dismissAll() {
    for vc in registery.keys {
      dismiss(from: vc)
    }
  }
	
}
