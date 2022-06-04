//
//  SwiftUIView.swift
//  ViewComponents/LogView
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - View

struct LogHeader: View {
  let store: Store<LogState, LogAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack(spacing: 10) {
        Toggle("Show Timestamps", isOn: viewStore.binding(get: \.showTimestamps, send: .timestampsButton))
        Spacer()

        Picker("Show Level", selection: viewStore.binding(
          get: \.logViewLevel,
          send: { value in .logViewLevel(value) } )) {
          ForEach(LogViewLevel.allCases, id: \.self) {
            Text($0.rawValue)
          }
        }
          .frame(width: 175)

        Spacer()
        Picker("Filter by", selection: viewStore.binding(
          get: \.filterBy,
          send: { value in .filterBy(value) } )) {
          ForEach(LogFilter.allCases, id: \.self) {
            Text($0.rawValue)
          }
        }
          .frame(width: 175)

        Image(systemName: "x.circle").foregroundColor(viewStore.filterByText == "" ? .gray : nil)
          .onTapGesture {
            viewStore.send(.filterByText(""))
          }
        TextField("Filter text", text: viewStore.binding(
          get: \.filterByText,
          send: { value in .filterByText(value) } ))
          .frame(maxWidth: 300, alignment: .leading)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct LogHeader_Previews: PreviewProvider {
  static var previews: some View {
    LogHeader(
      store: Store(
        initialState: LogState(),
        reducer: logReducer,
        environment: LogEnvironment()
      )
    )
      .frame(minWidth: 975)
  }
}
