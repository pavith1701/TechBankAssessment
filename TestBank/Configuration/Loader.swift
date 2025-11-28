//
//  Loader.swift
//  TestBank
//
//  Created by Pavithran P K on 28/11/25.
//

import Foundation
import UIKit

class Loader {
    private static var spinner: UIActivityIndicatorView?

    private static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    static func show() {
        DispatchQueue.main.async {
            guard let window = keyWindow else { return }

            let spinner = UIActivityIndicatorView(style: .large)
            spinner.color = .black
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()

            // Full overlay view
            let overlay = UIView(frame: window.bounds)
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            overlay.tag = 9999 // identifier
            overlay.addSubview(spinner)

            // Center the spinner in overlay
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
            ])

            window.addSubview(overlay)
            self.spinner = spinner
        }
    }

    static func hide() {
        DispatchQueue.main.async {
            guard let window = keyWindow else { return }

            if let overlay = window.viewWithTag(9999) {
                overlay.removeFromSuperview()
            }
            spinner = nil
        }
    }
}
