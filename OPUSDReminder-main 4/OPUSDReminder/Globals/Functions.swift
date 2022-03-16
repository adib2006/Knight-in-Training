//
//  Functions.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 1/25/22.
//

import Foundation

// MARK: Async After

/// Convenience method for `DispatchQueue.main.asyncAfter(deadline: execute:)`.
public func asyncAfter(_ seconds: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        execute()
    }
}

// MARK: Prints

/// Prints the message to the console with a red "X" preceding it to denote an error.
public func printError(_ message: String) {
    print("\u{274C} \(message)")
}

/// Prints the message to the console with a green checkmark preceding it to denote a succes.
public func printSuccess(_ message: String) {
    print("\u{2705} \(message)")
}

/// Prints the message to the console with a blue circle preceding it to denote an update.
public func printUpdate(_ message: String) {
    print("\u{1F535} \(message)")
}
