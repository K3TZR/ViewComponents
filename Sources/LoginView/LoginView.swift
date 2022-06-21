//
//  LoginView.swift
//  ViewComponents/LoginCore
//
//  Created by Douglas Adams on 12/28/21.
//

import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - View(s)

public struct LoginView: View {
  @ObservedObject var model: LoginModel

  public init(model:  LoginModel) {
    self.model = model
  }
  
  public var body: some View {
    VStack(spacing: 10) {
      Text( model.params.heading ).font( .title2 )
      if model.params.message != nil { Text(model.params.message!).font(.subheadline) }
      Divider()
      HStack {
        Text( model.params.userLabel ).frame( width: model.params.labelWidth, alignment: .leading)
        TextField( "", text: $model.params.user )
      }
      HStack {
        Text( model.params.pwdLabel ).frame( width: model.params.labelWidth, alignment: .leading)
        SecureField( "", text: $model.params.pwd )
      }
      
      HStack( spacing: 60 ) {
        Button( "Cancel", action: { model.cancelAction!()})
          .keyboardShortcut( .cancelAction )
        
        Button( "Log in" ) { model.loginAction!(model.params.user, model.params.pwd) }
          .keyboardShortcut( .defaultAction )
          .disabled( model.params.user.isEmpty || model.params.pwd.isEmpty )
      }
    }
    .frame( minWidth: model.params.overallWidth )
    .padding(10)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview(s)

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView( model:
                LoginModel(
                  params: LoginParams(
                    heading: "Enter Credentials",
                    userLabel: "Email",
                    pwdLabel: "Passcode"),
                  cancelAction: cancelAction,
                  loginAction: loginAction
                )
    )
    .frame( width: 350 )
    .padding(10)
    
    LoginView( model:
                LoginModel(
                  cancelAction: cancelAction,
                  loginAction: loginAction
                )
    )
    .frame( width: 350 )
    .padding(10)
  }
}

let cancelAction = {
  print("TEST Cancel button clicked")
}

let loginAction = { (user: String, pwd: String) in
  print("TEST Login button clicked: user = \(user), pwd = \(pwd)")
}
