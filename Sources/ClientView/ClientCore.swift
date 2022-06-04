//
//  ClientCore.swift
//  ViewComponents/ClientView
//
//  Created by Douglas Adams on 1/19/22.
//

import Foundation
import ComposableArchitecture

public struct ClientState: Equatable {
  var selectedId: UUID
  var stations: [String]
  var handles: [UInt32?]
  var heading: String
  public init
  (
    selectedId: UUID,
    stations: [String],
    handles: [UInt32?],
    heading: String = "Choose an action"
  )
  {
    self.selectedId = selectedId
    self.stations = stations
    self.handles = handles
    self.heading = heading
  }
}

public enum ClientAction: Equatable {
  // UI controls
  case cancelButton
  case connect(UUID, UInt32?)
}

public struct ClientEnvironment {
  public init() {}
}

public let clientReducer = Reducer<ClientState, ClientAction, ClientEnvironment>
  { state, action, environment in
      return .none
  }
//  .debug("-----> CLIENTVIEW")
