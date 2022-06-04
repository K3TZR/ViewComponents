//
//  PickerFooterView.swift
//  ViewComponents/PickerView
//
//  Created by Douglas Adams on 1/9/22.
//

import SwiftUI
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - View

struct PickerFooterView: View {
  let store: Store<PickerState, PickerAction>

  var body: some View {
    WithViewStore(store) { viewStore in

      HStack(){
        Button("Test") {viewStore.send(.testButton(viewStore.selectedId!, viewStore.pickables[id: viewStore.selectedId!]!.packetId))}
          .disabled(viewStore.selectedId == nil || viewStore.pickables[id: viewStore.selectedId!]!.isLocal)
        Circle()
          .fill(viewStore.testResult ? Color.green : Color.red)
          .frame(width: 20, height: 20)

        Spacer()
        Button("Default") {viewStore.send(.defaultButton(viewStore.selectedId!, viewStore.pickables[id: viewStore.selectedId!]!.packetId, viewStore.pickables[id: viewStore.selectedId!]!.station)) }
        .disabled(viewStore.selectedId == nil)
        .keyboardShortcut(.cancelAction)

        Spacer()
        Button("Cancel") {viewStore.send(.cancelButton) }
        .keyboardShortcut(.cancelAction)

        Spacer()
        Button("Connect") {viewStore.send(.connectButton(viewStore.selectedId!, viewStore.pickables[id: viewStore.selectedId!]!.packetId, viewStore.pickables[id: viewStore.selectedId!]!.station))}
        .keyboardShortcut(.defaultAction)
        .disabled(viewStore.selectedId == nil)
      }
    }
    .padding(.vertical, 10)
    .padding(.horizontal)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

//struct PickerFooterView_Previews: PreviewProvider {
//  static var previews: some View {
//    
//    PickerFooterView(store: Store(
//      initialState: PickerState(connectionType: .gui, testResult: testResultFail, discovery: LanDiscovery()),
//      reducer: pickerReducer,
//      environment: PickerEnvironment() )
//    )
//      .previewDisplayName("Test false")
//    
//    PickerFooterView(store: Store(
//      initialState: PickerState(connectionType: .nonGui, testResult: testResultSuccess1, discovery: LanDiscovery()),
//      reducer: pickerReducer,
//      environment: PickerEnvironment() )
//    )
//      .previewDisplayName("Test true (FORWARDING)")
//
//    PickerFooterView(store: Store(
//      initialState: PickerState(connectionType: .nonGui, testResult: testResultSuccess2, discovery: LanDiscovery()),
//      reducer: pickerReducer,
//      environment: PickerEnvironment() )
//    )
//      .previewDisplayName("Test true (UPNP)")
//  }
//}
//
//
//var testResultFail: SmartlinkTestResult {
//  SmartlinkTestResult()
//}
//
//var testResultSuccess1: SmartlinkTestResult {
//  var result = SmartlinkTestResult()
//  result.forwardTcpPortWorking = true
//  result.forwardUdpPortWorking = true
//  return result
//}
//
//var testResultSuccess2: SmartlinkTestResult {
//  var result = SmartlinkTestResult()
//  result.upnpTcpPortWorking = true
//  result.upnpUdpPortWorking = true
//  return result
//}
