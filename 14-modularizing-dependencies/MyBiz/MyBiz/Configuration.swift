/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import UIHelpers

//swiftlint:disable type_name identifier_name
struct Configuration: Codable {
  struct UI: Codable {
    struct Button: Codable {
      let cornerRadius: Double
      let borderWidth: Double
    }

    let button: Button
  }

  struct BusinessRules: Codable {
    let maxPOExpense: Double
  }

  let server: String
  let debug: Bool
  let ui: UIConfiguration
  let rules: BusinessRules
}

// MARK: - Local Settings

extension Configuration {
  var firstDayOfWeek: DaysOfWeek {
    if UserDefaults.standard.object(forKey: "firstDayOfWeek") != nil {
      return DaysOfWeek(rawValue: UserDefaults.standard.integer(forKey: "firstDayOfWeek"))!
    }
    return .sunday
  }
}

extension Configuration {
  //swiftlint:disable force_try
  static func load() -> Configuration {
    let url = Bundle.main.url(forResource: "configuration", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try! decoder.decode(Configuration.self, from: data)
  }
}
