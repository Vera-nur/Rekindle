//
//  UIViewController.swift
//  Rekindle
//
//  Created by Vera Nur on 6.08.2025.
//

import SwiftUI

extension EnvironmentValues {
  /// Uygulamanın ana UIWindow'ını döner
  var rootWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first?
      .windows
      .first
  }
}
