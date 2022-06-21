//
//  LoginModel.swift
//  
//
//  Created by Douglas Adams on 6/15/22.
//

import Foundation

public struct LoginParams {
  public var user: String
  public var pwd: String
  public var heading: String
  public var message: String?
  public var userLabel: String
  public var pwdLabel: String
  public var labelWidth: CGFloat
  public var overallWidth: CGFloat

  public init(
    user: String = "",
    pwd: String = "",
    heading: String = "Please Login",
    message: String? = nil,
    userLabel: String = "User",
    pwdLabel: String = "Password",
    labelWidth: CGFloat = 100,
    overallWidth: CGFloat = 100
  )
  {
    self.user = user
    self.pwd = pwd
    self.heading = heading
    self.message = message
    self.userLabel = userLabel
    self.pwdLabel = pwdLabel
    self.labelWidth = labelWidth
    self.overallWidth = overallWidth
  }
}

public class LoginModel: ObservableObject {

  @Published public var params: LoginParams!

  public var cancelAction: (() -> Void)?
  public var loginAction: ((String, String) -> Void)?

  public init(params: LoginParams = LoginParams(), cancelAction: @escaping () -> Void, loginAction: @escaping (String, String) -> Void) {
    self.params = params
    self.cancelAction = cancelAction
    self.loginAction = loginAction
  }  
}
