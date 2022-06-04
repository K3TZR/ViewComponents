//
//  ClientView.swift
//  ViewComponents/ClientView
//
//  Created by Douglas Adams on 1/19/22.
//

import ComposableArchitecture
import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - View(s)

// assumes that the number of GuiClients is 1 or 2

public struct ClientView: View {
  let store: Store<ClientState,ClientAction>

  public init(store: Store<ClientState,ClientAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        Text(viewStore.heading).font(.title)
        Divider()
        Button( action: { viewStore.send(.connect(viewStore.selectedId, viewStore.handles[0])) })
        { Text("Close " + viewStore.stations[0].uppercased() + " Station").frame(width: 150) }

        if viewStore.handles.count == 1 {
          Button( action: { viewStore.send(.connect(viewStore.selectedId, nil)) })
          { Text("MultiFlex connect").frame(width: 150) }
        }

        if viewStore.handles.count == 2 {
          Button( action: { viewStore.send(.connect(viewStore.selectedId, viewStore.handles[0])) })
          { Text("Close " + viewStore.stations[1].uppercased() + " Station").frame(width: 150) }
        }

        Divider()

        Button( action: { viewStore.send(.cancelButton) })
        { Text("Cancel") }
        .keyboardShortcut(.cancelAction)
      }
      .frame(maxWidth: 200)
      .padding()
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview(s)

struct ClientView_Previews: PreviewProvider {
  static var previews: some View {
    ClientView(
      store: Store(
        initialState: ClientState(
          selectedId: UUID(),
          stations: ["iPad"],
          handles: [UInt32(1)]
        ),
        reducer: clientReducer,
        environment: ClientEnvironment()
      )
    )
      .previewDisplayName("Gui connect (disconnect not required)")

    ClientView(
      store: Store(
        initialState: ClientState(
          selectedId: UUID(),
          stations: ["iPad","Windows"],
          handles: [UInt32(1),UInt32(2)]
          ),
        reducer: clientReducer,
        environment: ClientEnvironment()
      )
    )
      .previewDisplayName("Gui connect (disconnect required)")
  }
}
