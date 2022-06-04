//
//  PickerEffects.swift
//  ViewComponents/PickerView
//
//  Created by Douglas Adams on 3/21/22.
//

import Foundation
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - Subscriptions to publishers

// cancellation IDs
//struct TestSubscriptionId: Hashable {}

//func subscribeToTest() -> Effect<PickerAction, Never> {
//  Effect(
//    Discovered.shared.testPublisher
//      .receive(on: DispatchQueue.main)
//      .map { result in .testResult(result) }
//      .eraseToEffect()
//      .cancellable(id: TestSubscriptionId())
//  )
//}

//func subscribeToTest() -> Effect<PickerAction, Never> {
//  Effect(
//    NotificationCenter.default
//      .publisher(for: NSNotification.Name(rawValue: "TestResult"), object: nil)
//      .receive(on: DispatchQueue.main)
//      .map { note in .testResult(note.object as! Bool) }
//      .eraseToEffect()
//      .cancellable(id: TestSubscriptionId())
//  )
//}
