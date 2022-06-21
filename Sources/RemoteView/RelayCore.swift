//
//  RelayCore.swift
//  ViewComponents/RemoteView
//
//  Created by Douglas Adams on 2/26/22.
//

import ComposableArchitecture
import Foundation
import SwiftUI

import LoginView

public struct RelayState: Codable, Equatable, Identifiable {
  
  public init(
    status: Bool = false,
    name: String,
    locked: Bool = false
  ) {
    self.status = status
    self.name = name
    self.locked = locked
  }
  public var id = UUID()
  public var status: Bool
  @BindableState public var name: String
  public var locked: Bool
  
  public enum CodingKeys: String, CodingKey {
    case status = "physical_state"
    case name
    case locked
  }
}

public enum RelayAction: BindableAction, Equatable {
  case binding(BindingAction<RelayState>)
  case toggleStatus
  case nameChanged
}

public struct RelayEnvironment {}

public let relayReducer = Reducer<RelayState, RelayAction, RelayEnvironment> { state, action, _ in

  return .none
}
  .binding()
//  .debug("-----> RELAYVIEW")
