//
//  PickerCore.swift
//  ViewComponents/PickerView
//
//  Created by Douglas Adams on 11/13/21.
//

import Combine
import ComposableArchitecture
import Dispatch
import AppKit

public struct Pickable: Identifiable, Equatable {
  public var id: UUID
  public var packetId: UUID
  public var isLocal: Bool
  public var name: String
  public var status: String
  public var station: String
  public var isDefault: Bool
  
  public init(
    id: UUID = UUID(),
    packetId: UUID,
    isLocal: Bool,
    name: String,
    status: String,
    station: String,
    isDefault: Bool
  )
  {
    self.id = id
    self.packetId = packetId
    self.isLocal = isLocal
    self.name = name
    self.status = status
    self.station = station
    self.isDefault = isDefault
  }
}

// ----------------------------------------------------------------------------
// MARK: - State, Actions & Environment

public struct PickerState: Equatable {
  public init(pickables: IdentifiedArrayOf<Pickable>,
              isGui: Bool = true,
              defaultId: UUID? = nil,
              selectedId: UUID? = nil,
              testResult: Bool = false)
  {
    self.pickables = pickables
    self.isGui = isGui
    self.defaultId = defaultId
    self.selectedId = selectedId
    self.testResult = testResult
  }
  public var pickables: IdentifiedArrayOf<Pickable>
  public var isGui: Bool
  public var defaultId: UUID?
  public var selectedId: UUID?
  public var testResult: Bool

//  public var alert: AlertState<PickerAction>?
  public var forceUpdate = false
}

public enum PickerAction: Equatable {
  // UI controls
  case cancelButton
  case connectButton(UUID, UUID, String?)
  case defaultButton(UUID, UUID, String?)
  case selection(UUID?)
  case testButton(UUID, UUID)
  
  // sheet/alert related
//  case alertCancelled
  
  // effect related
  case testResult(Bool)
}

public struct PickerEnvironment {
  public init(
    queue: @escaping () -> AnySchedulerOf<DispatchQueue> = { .main }
    //    discoverySubscription: @escaping () -> Effect<PickerAction, Never> = { subscribeToDiscoveryPackets() }
  )
  {
    self.queue = queue
    //    self.discoverySubscription = discoverySubscription
  }
  
  var queue: () -> AnySchedulerOf<DispatchQueue>
  //  var discoverySubscription: () -> Effect<PickerAction, Never>
}

// ----------------------------------------------------------------------------
// MARK: - Reducer

public let pickerReducer = Reducer<PickerState, PickerAction, PickerEnvironment>
{ state, action, environment in
  
  switch action {
    // ----------------------------------------------------------------------------
    // MARK: - UI actions
    
  case .cancelButton:
    // additional processing upstream
    return .none
    
  case .connectButton(let id, let packetId, let station):
    return .none
    
  case .defaultButton(let id, let packetId, let station):
    if state.defaultId == id {
      state.defaultId = nil
    } else {
      state.defaultId = id
    }
    state.pickables[id: id]?.isDefault.toggle()
    for pickable in state.pickables where pickable.id != id {
      state.pickables[id: pickable.id]!.isDefault = false
    }
    // additional processing upstream
    return .none
    
  case .selection(let id):
    state.selectedId = id
    
    // FIXME: Move out of Picker
    
//    if let id = id {
//      if Shared.kVersionSupported < Version(selection.packet.version)  {
//        // NO, return an Alert
//        state.alert = .init(title: TextState(
//                                """
//                                Radio may be incompatible:
//
//                                Radio is v\(Version(selection.packet.version).string)
//                                App supports v\(kVersionSupported.string) or lower
//                                """
//        )
//        )
//      }
//    }
    return .none
    
  case .testButton(let id, let packetId):
    state.testResult = false

    return .none
    // ----------------------------------------------------------------------------
    // MARK: - Alert actions
    
//  case .alertCancelled:
//    state.alert = nil
//    return .none
    
    // ----------------------------------------------------------------------------
    // MARK: - Actions sent by publishers
    
  case .testResult(let result):
    state.testResult = result

      // FIXME: Move out of Picker
    
//    if state.testResult == false {
//      state.alert = .init(
//        title: TextState(
//                    """
//                    Smartlink test FAILED:
//                    """
//        )
//      )
//    }
//    return .cancel(id: [TestSubscriptionId()])
    return .none
  }
}
//  .debug("-----> PICKERVIEW ")
