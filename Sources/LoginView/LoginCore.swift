//
//  LoginCore.swift
//  ViewComponents/LoginCore
//
//  Created by Douglas Adams on 12/28/21.
//

import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - Structs and Enums

public struct LoginResult: Equatable {
  
  public init(_ user: String, pwd: String) {
    self.user = user
    self.pwd = pwd
  }
  public var user = ""
  public var pwd = ""
}

// ----------------------------------------------------------------------------
// MARK: - State, Actions & Environment

public struct LoginState: Equatable {
  var heading: String
  var message: String?
  @BindableState var user: String
  @BindableState var pwd: String
  var userLabel: String
  var pwdLabel: String
  var labelWidth: CGFloat
  var overallWidth: CGFloat

  public init(
    heading: String = "Please Login",
    message: String? = nil,
    user: String = "",
    pwd: String = "",
    userLabel: String = "User",
    pwdLabel: String = "Password",
    labelWidth: CGFloat = 100,
    overallWidth: CGFloat = 350
  )
  {
    self.heading = heading
    self.message = message
    self.user = user
    self.pwd = pwd
    self.userLabel = userLabel
    self.pwdLabel = pwdLabel
    self.labelWidth = labelWidth
    self.overallWidth = overallWidth
  }
}

public enum LoginAction: BindableAction, Equatable {
  
  // UI controls
  case cancelButton
  case loginButton(String, String)
  case binding(BindingAction<LoginState>)
}

public struct LoginEnvironment {
  
  public init() {}
}

// ----------------------------------------------------------------------------
// MARK: - Reducer

public let loginReducer = Reducer<LoginState, LoginAction, LoginEnvironment>
  { state, action, environment in
    
//    switch action {
//
//    case .cancelButton:
//      return .none
//
//    case .loginButton(let user, let pwd):
//      return .none
//
//    case .binding(_):
//      return .none
//    }
    return .none
  }
  .binding()
//  .debug("-----> LOGINVIEW")
