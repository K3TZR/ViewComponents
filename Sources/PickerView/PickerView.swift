//
//  PickerView.swift
//  ViewComponents/PickerView
//
//  Created by Douglas Adams on 11/13/21.
//

import SwiftUI
import Combine
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - View(s)

public struct PickerView: View {
  let store: Store<PickerState, PickerAction>
  
  public init(store: Store<PickerState, PickerAction>) {
    self.store = store
  }
  
  @State var selectedStation: String?
    
  public var body: some View {
    
    WithViewStore(store) { viewStore in
      VStack(alignment: .leading) {
        PickerHeaderView(isGui: viewStore.isGui)
        Divider()
        if viewStore.pickables.count == 0 {
          Spacer()
          HStack {
            Spacer()
            Text("----------  NO  \(viewStore.isGui ? "Radio" : "Station")s  FOUND  ----------").foregroundColor(.red)
            Spacer()
          }
          Spacer()
        } else {
          PickablesView(store: store)
        }
          Spacer()
          Divider()
          PickerFooterView(store: store)
      }
      .frame(minWidth: 600, minHeight: 250)

      // FIXME: Move out of Picker
    

//      // alert dialogs
//      .alert(
//        self.store.scope(state: \.alert),
//        dismiss: .alertCancelled
//      )
    }
  }
}

public struct PickablesView: View {
  let store: Store<PickerState, PickerAction>
  
  public var body: some View {
    
    WithViewStore(store) { viewStore in
      ForEach(viewStore.pickables, id: \.id) { pickable in
        ZStack {
          HStack(spacing: 0) {
            Group {
              Text(pickable.isLocal ? "Local" : "Smartlink")
              Text(pickable.name)
              Text(pickable.status)
              Text(pickable.station)
            }
            .font(.title3)
            .frame(minWidth: 140, alignment: .leading)
            .foregroundColor(pickable.isDefault ? .red : nil)
            .onTapGesture {
              if viewStore.selectedId == pickable.id {
                viewStore.send( .selection(nil) )
              }else {
                viewStore.send( .selection( pickable.id ))
              }
            }
          }
          Rectangle().fill(viewStore.selectedId == pickable.id ? .gray : .clear).frame(height: 20).opacity(0.2)
            .font(.title3)
            .frame(minWidth: 140, alignment: .leading)
          }
        }
      }
      .padding(.horizontal)
    }
  }

// ----------------------------------------------------------------------------
// MARK: - Preview

struct PickerView_Previews: PreviewProvider {
  static var previews: some View {
    
    PickerView(
      store: Store(
        initialState: PickerState(
          pickables: []
        ),
        reducer: pickerReducer,
        environment: PickerEnvironment()
      )
    )
      .previewDisplayName("Picker Gui (empty)")
    
    PickerView(
      store: Store(
        initialState: PickerState(
          pickables: [
            Pickable(packetId: UUID(), isLocal: true, name: "Dougs 6500", status: "Available", station: "", isDefault: false),
            Pickable(packetId: UUID(), isLocal: false, name: "Petes 6300", status: "Available", station: "", isDefault: false),
            Pickable(packetId: UUID(), isLocal: true, name: "Dougs 6700", status: "Available", station: "", isDefault: true),
            Pickable(packetId: UUID(), isLocal: false, name: "Petes 6500", status: "Available", station: "", isDefault: false)
          ]
        ),
        reducer: pickerReducer,
        environment: PickerEnvironment()
      )
    )
    .previewDisplayName("Picker Gui")

    PickerView(
      store: Store(
        initialState: PickerState(
          pickables: [ ],
          isGui: false
        ),
        reducer: pickerReducer,
        environment: PickerEnvironment()
      )
    )
      .previewDisplayName("Picker non Gui (empty)")
    
    PickerView(
      store: Store(
        initialState: PickerState(
          pickables: [
            Pickable(packetId: UUID(), isLocal: true, name: "Dougs 6500", status: "Available", station: "iPad", isDefault: false),
            Pickable(packetId: UUID(), isLocal: true, name: "Dougs 6500", status: "Available", station: "Windows", isDefault: false),
            Pickable(packetId: UUID(), isLocal: false, name: "Petes 6300", status: "Available", station: "", isDefault: false),
            Pickable(packetId: UUID(), isLocal: true, name: "Dougs 6700", status: "Available", station: "", isDefault: true),
            Pickable(packetId: UUID(), isLocal: false, name: "Petes 6500", status: "Available", station: "Windows", isDefault: false),
            Pickable(packetId: UUID(), isLocal: false, name: "Petes 6500", status: "Available", station: "Mac", isDefault: false)
          ],
          isGui: false
        ),
        reducer: pickerReducer,
        environment: PickerEnvironment()
      )
    )
      .previewDisplayName("Picker non Gui")
  }
}
