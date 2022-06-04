//
//  ProgressView.swift
//  ViewComponents/ProgressView
//
//  Created by Douglas Adams on 3/23/22.
//
import ComposableArchitecture
import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - View(s)

public struct ProgressView: View {
  let store: Store<ProgressState, ProgressAction>
  
  public init(store: Store<ProgressState, ProgressAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        Group {
          Text(viewStore.heading).font(.title2)
          if viewStore.message != nil { Text(viewStore.message!).font(.subheadline) }
          Divider()
        }
        .multilineTextAlignment(.center)
        if viewStore.duration != nil { ProgressBar(value: viewStore.value) }
        Button("Cancel") { viewStore.send(.cancel) }
      }
      .onAppear() { if viewStore.duration != nil { viewStore.send(.startTimer) } }
      .border(.red)
    }
    .frame(width: 200)
    .padding()
  }
}

public struct ProgressBar: View {
  var value: Float
  
  public var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
          .opacity(0.3)
          .foregroundColor(.gray)
        
        Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
          .foregroundColor(.blue)
          .animation(.linear, value: value)
      }
      .cornerRadius(45.0)
    }
    .frame(width: 200, height: 10)
    .padding(.horizontal, 10)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview(s)

public struct ProgressView_Previews: PreviewProvider {
  public static var previews: some View {
    ProgressView(
      store: Store(
        initialState: ProgressState(heading: "Wait for the Bar", message: "Test Bar", duration: 10.0, value: 0.1),
        reducer: progressReducer,
        environment: ProgressEnvironment()
      )
    )
  }
}

public struct ProgressBar_Previews: PreviewProvider {
  public static var previews: some View {
    ProgressBar(value: 0.5)
      .frame(width: 200, height: 10)
  }
}
