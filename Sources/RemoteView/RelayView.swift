//
//  RelayView.swift
//  ViewComponents/RemoteView
//
//  Created by Douglas Adams on 3/11/22.
//

import ComposableArchitecture
import SwiftUI

public struct RelayView: View {
  let store: Store<RelayState, RelayAction>

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack {
        TextField("", text: viewStore.binding(\.$name), onCommit: { viewStore.send(.nameChanged) }).frame(width: 300)
        Group {
          
          Button(action: { viewStore.send(.toggleStatus) }, label: { Text("\(viewStore.status ? "ON" : "OFF")").frame(width: 40) })
            .foregroundColor(viewStore.locked ? .gray : viewStore.status ? .green : .red)
            .disabled(viewStore.locked)
          Text("\(viewStore.locked ? "YES" : "NO")").foregroundColor(viewStore.locked ? .yellow : .gray)
        }
        .frame(width: 100, alignment: .center)
      }
      .font(.title2)
    }
  }
}


// ----------------------------------------------------------------------------
// MARK: - Preview

struct RelayView_Previews: PreviewProvider {
  static var previews: some View {
    RelayView(
      store: Store(
        initialState: RelayState(status: false, name: "Relay n", locked: false),
        reducer: relayReducer,
        environment: RelayEnvironment()
      )
    )
    RelayView(
      store: Store(
        initialState: RelayState(status: true, name: "Relay n", locked: true),
        reducer: relayReducer,
        environment: RelayEnvironment()
      )
    )
  }
}
