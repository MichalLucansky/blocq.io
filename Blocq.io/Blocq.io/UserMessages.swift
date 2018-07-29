//
//  UserMessages.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 29.7.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import SwiftMessages
import UIKit

enum UserMessage {
    
    case success
    case error
    
    public func show(message: String, layout: MessageView.Layout = .cardView, presentationContext: SwiftMessages.PresentationContext? = nil, time: Double = 8.0, presentationStyle: SwiftMessages.PresentationStyle = .top, buttonHandler: (() -> Void)? = nil, tapHandler: (() -> Void)? = nil) {
        
        var config =  self.config(self,time,presentationStyle)
        
        if let pc = presentationContext {
            config.presentationContext = pc
        }
        
        SwiftMessages.show(config: config, view: self.view(self, message: message, layout: layout, buttonHandler: buttonHandler, tapHandler: tapHandler))
    }
    
    private func config(_ type: UserMessage, _ time: Double, _ presentationStyle: SwiftMessages.PresentationStyle) -> SwiftMessages.Config {
        
        var config = SwiftMessages.Config()
        config.presentationStyle = presentationStyle
        config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        config.duration = .seconds(seconds: time)
        
        return config
    }
    
    private func view(_ type: UserMessage, message: String, layout: MessageView.Layout = .cardView, buttonHandler: (() -> Void)? = nil, tapHandler: (() -> Void)? = nil) -> UIView {
        
        let view = MessageView.viewFromNib(layout: layout)
        
        switch type {
        case .success: view.configureTheme(backgroundColor: UIColor.green, foregroundColor:.white)
        view.button?.isHidden = true
        case .error: view.configureTheme(backgroundColor: UIColor.red, foregroundColor:.white)
        view.button?.isHidden = true
        }
        
        let stackViews:[UIStackView] = view.getSubviewsOf(view: view) as [UIStackView]
        for view in stackViews {
            view.alignment = .center
        }
        view.buttonTapHandler = { _ in
            buttonHandler?()
            SwiftMessages.hide()
        }
        
        view.configureContent(title: message, body: "")
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.numberOfLines = -1
        view.bodyLabel?.isHidden = true
        
        view.tapHandler = (tapHandler != nil) ? { _ in tapHandler?() } : { _ in SwiftMessages.hide() }
        
        return view
    }
    
    public func hide() {
        SwiftMessages.hide()
    }
}
