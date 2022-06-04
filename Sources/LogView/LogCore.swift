//
//  LogCore.swift
//  ViewComponents/LogView
//
//  Created by Douglas Adams on 11/30/21.
//

import ComposableArchitecture
import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - Structs and Enums

public struct LogLine: Equatable {

  public init(text: String, color: Color = .primary) {
    self.text = text
    self.color = color
  }
  public var text: String
  public var color: Color
}

public enum LogViewLevel: String, CaseIterable {
  case debug = "Debug"
  case info = "Info"
  case warning = "Warning"
  case error = "Error"
}

public enum LogFilter: String, CaseIterable, Identifiable {
  case none
  case includes
  case excludes
  case prefix

  public var id: String { self.rawValue }
}

// ----------------------------------------------------------------------------
// MARK: - State, Actions & Environment

public struct LogState: Equatable {
  // State held in User Defaults
  public var logViewLevel: LogViewLevel { didSet { UserDefaults.standard.set(logViewLevel.rawValue, forKey: "logViewLevel") } }
  public var filterBy: LogFilter { didSet { UserDefaults.standard.set(filterBy.rawValue, forKey: "filterBy") } }
  public var filterByText: String { didSet { UserDefaults.standard.set(filterByText, forKey: "filterByText") } }
  public var showTimestamps: Bool { didSet { UserDefaults.standard.set(showTimestamps, forKey: "showTimestamps") } }

  // normal state
  public var logUrl: URL?
  public var fontSize: CGFloat = 12
  public var logMessages = [LogLine]()
  public var reversed = false
  public var autoRefresh = false

  public init
  (
    logViewLevel: LogViewLevel = LogViewLevel(rawValue: UserDefaults.standard.string(forKey: "logViewLevel") ?? "debug") ?? .debug,
    filterBy: LogFilter = LogFilter(rawValue: UserDefaults.standard.string(forKey: "filterBy") ?? "none") ?? .none,
    filterByText: String = UserDefaults.standard.string(forKey: "filterByText") ?? "",
    showTimestamps: Bool = UserDefaults.standard.bool(forKey: "showTimestamps"),
    fontSize: CGFloat = 12
  )
  {
    self.logViewLevel = logViewLevel
    self.filterBy = filterBy
    self.filterByText = filterByText
    self.showTimestamps = showTimestamps
    self.fontSize = fontSize
  }
}

public enum LogAction: Equatable {
  // UI actions
  case autoRefreshButton
  case clearButton
  case filterBy(LogFilter)
  case filterByText(String)
  case fontSize(CGFloat)
  case loadButton
  case logViewLevel(LogViewLevel)
  case onAppear(LogViewLevel)
  case refreshButton
  case reverseButton
  case saveButton
  case timerTicked
  case timestampsButton
  case refreshResultReceived([LogLine])
}

public struct LogEnvironment {
  public init(
    queue: @escaping () -> AnySchedulerOf<DispatchQueue> = { .main },
    uuid: @escaping () -> UUID = { .init() }
  )
  {
    self.queue = queue
    self.uuid = uuid
  }
  var queue: () -> AnySchedulerOf<DispatchQueue>
  var uuid: () -> UUID
}

// ----------------------------------------------------------------------------
// MARK: - Reducer

public let logReducer = Reducer<LogState, LogAction, LogEnvironment> {
  state, action, environment in

  struct TimerId: Hashable {}

  switch action {
    // ----------------------------------------------------------------------------
    // MARK: - Initialization
    
  case .onAppear(let logLevel):
    let info = getBundleInfo()
    state.logUrl = URL.appSupport.appendingPathComponent(info.domain + "." + info.appName + "/Logs/" + info.appName + ".log" )
    return refreshLog(state, environment)

    // ----------------------------------------------------------------------------
    // MARK: - UI actions
    
  case .autoRefreshButton:
    state.autoRefresh.toggle()
    if state.autoRefresh {
      return Effect.timer(id: TimerId(), every: 0.1, on: DispatchQueue.main)
        .receive(on: DispatchQueue.main)
        .catchToEffect()
        .map { _ in .timerTicked }
    } else {
      return .cancel(id: TimerId())
    }
    
  case .clearButton:
    state.logMessages.removeAll()
    return .none
    
  case .filterBy(let filter):
    state.filterBy = filter

    return refreshLog(state, environment)

  case .filterByText(let text):
    state.filterByText = text
    if state.filterBy != .none {
      return refreshLog(state, environment)
    } else {
      return .none
    }

  case let .fontSize(value):
    state.fontSize = value
    return .none

  case .loadButton:
    if let url = showOpenPanel() {
      state.logUrl = url
      state.logMessages.removeAll()
      return refreshLog(state, environment)
    } else {
      return .none
    }
    
  case .logViewLevel(let level):
    state.logViewLevel = level
    return refreshLog(state, environment)

  case .refreshButton:
    return refreshLog(state, environment)

  case .refreshResultReceived(let logMessages):
    state.logMessages = logMessages
    return .none

  case .reverseButton:
    state.reversed.toggle()
    return refreshLog(state, environment)

  case .saveButton:
    if let saveURL = showSavePanel() {
      let textArray = state.logMessages.map { $0.text }
      let fileTextArray = textArray.joined(separator: "\n")
      try? fileTextArray.write(to: saveURL, atomically: true, encoding: .utf8)
    }
    return .none
    
  case .timerTicked:
    return refreshLog(state, environment)
    
  case .timestampsButton:
    state.showTimestamps.toggle()
    return refreshLog(state, environment)
  }
}
//  .debug("-----> LOGVIEW")

// ----------------------------------------------------------------------------
// MARK: - Helper functions

public func getBundleInfo() -> (domain: String, appName: String) {
  let bundleIdentifier = Bundle.main.bundleIdentifier ?? "net.k3tzr.LogView"
  let separator = bundleIdentifier.lastIndex(of: ".")!
  let appName = String(bundleIdentifier.suffix(from: bundleIdentifier.index(separator, offsetBy: 1)))
  let domain = String(bundleIdentifier.prefix(upTo: separator))
  return (domain, appName)
}

func refreshLog(_ state: LogState,  _ environment: LogEnvironment) -> Effect<LogAction, Never>  {
  guard state.logUrl != nil else { fatalError("logUrl is nil") }
  
  let messages = readLogFile(at: state.logUrl!, environment: environment )
    
  return Effect(value: .refreshResultReceived(filterLog(messages, level: state.logViewLevel, filter: state.filterBy, filterText: state.filterByText, showTimeStamps: state.showTimestamps)))
}

/// Read a Log file
/// - Parameter url:    the URL of the file
/// - Returns:          an array of log entries
func readLogFile(at url: URL, environment: LogEnvironment) -> [LogLine] {
  var messages = [LogLine]()
  
  do {
    // get the contents of the file
    let logString = try String(contentsOf: url, encoding: .ascii)
    // parse it into lines
    let lines = logString.components(separatedBy: "\n").dropLast()
    for line in lines {
      messages.append(LogLine(text: line, color: logLineColor(line)))
    }
    return messages
    
  } catch {
    return messages
  }
}

/// Filter an array of Log entries
/// - Parameters:
///   - messages:       the array
///   - level:          a log level
///   - filter:         a filter type
///   - filterText:     the filter text
///   - showTimes:      whether to show timestamps
/// - Returns:          the filtered array of Log entries
func filterLog(_ messages: [LogLine], level: LogViewLevel, filter: LogFilter, filterText: String = "", showTimeStamps: Bool = true) -> [LogLine] {
  var lines = [LogLine]()
  var limitedLines = [LogLine]()

  // filter the log entries
  switch level {
  case .debug:     lines = messages
  case .info:      lines = messages.filter { $0.text.contains(" [Error] ") || $0.text.contains(" [Warning] ") || $0.text.contains(" [Info] ") }
  case .warning:   lines = messages.filter { $0.text.contains(" [Error] ") || $0.text.contains(" [Warning] ") }
  case .error:     lines = messages.filter { $0.text.contains(" [Error] ") }
  }

  switch filter {
  case .none:       limitedLines = lines
  case .prefix:     limitedLines = lines.filter { $0.text.contains(" > " + filterText) }
  case .includes:   limitedLines = lines.filter { $0.text.contains(filterText) }
  case .excludes:   limitedLines = lines.filter { !$0.text.contains(filterText) }
  }

  if !showTimeStamps {
    for (i, line) in limitedLines.enumerated() {
      limitedLines[i].text = String(line.text.suffix(from: line.text.firstIndex(of: "[") ?? line.text.startIndex))
    }
  }
  return limitedLines
}

/// Determine the color to assign to a Log entry
/// - Parameter text:     the entry
/// - Returns:            a Color
func logLineColor(_ text: String) -> Color {
  if text.contains("[Debug]") { return .gray }
  else if text.contains("[Info]") { return .primary }
  else if text.contains("[Warning]") { return .orange }
  else if text.contains("[Error]") { return .red }
  else { return .primary }
}

/// Display a SavePanel
/// - Returns:       the URL of the selected file or nil
func showSavePanel() -> URL? {
  let savePanel = NSSavePanel()
  savePanel.allowedContentTypes = [.log]
  savePanel.canCreateDirectories = true
  savePanel.isExtensionHidden = false
  savePanel.allowsOtherFileTypes = false
  savePanel.title = "Save the Log"
//  savePanel.nameFieldLabel = "File name:"

  let response = savePanel.runModal()
  return response == .OK ? savePanel.url : nil
}

/// Display an OpenPanel
/// - Returns:        the URL of the selected file or nil
func showOpenPanel() -> URL? {
  let openPanel = NSOpenPanel()
  openPanel.allowedContentTypes = [.log]
  openPanel.allowsMultipleSelection = false
  openPanel.canChooseDirectories = false
  openPanel.canChooseFiles = true
  openPanel.title = "Open an existing Log"
  let response = openPanel.runModal()
  return response == .OK ? openPanel.url : nil
}

extension URL {
  public static var appSupport : URL { return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first! }
}
