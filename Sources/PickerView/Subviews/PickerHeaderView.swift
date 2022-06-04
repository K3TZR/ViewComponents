//
//  PickerHeaderView.swift
//  ViewComponents/PickerView
//
//  Created by Douglas Adams on 1/9/22.
//

import SwiftUI
import ComposableArchitecture

import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct PickerHeaderView: View {
  let isGui: Bool

  var body: some View {
    VStack {
      Text("Select a \(isGui ? "RADIO" : "STATION")")
        .font(.title)
        .padding(.bottom, 10)

      Text("Click on a \(isGui ? "RADIO" : "STATION") in the list below")
        .font(.title3)
        .padding(.bottom, 10)

      HStack(spacing: 0) {
        Group {
          Text("Type")
          Text("Name")
          Text("Status")
          Text("Station(s)")
        }
        .frame(width: 140, alignment: .leading)
      }
    }
    .font(.title2)
    .padding(.vertical, 10)
    .padding(.horizontal)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct PickerHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    PickerHeaderView(isGui: true)
      .previewDisplayName("Radio Picker")

    PickerHeaderView(isGui: false)
      .previewDisplayName("Station Picker")
  }
}
