/// Copyright (c) 2022 Razeware LLC
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

@testable import MyBiz
import Foundation

class MockApi: API {
  var mockEvents = [Event]()
  var mockEmployess = [Employee]()
  var mockError: Error?
  
  override func getEvents() {
    DispatchQueue.main.async {
      if let error = self.mockError {
        self.delegate?.eventsFailed(error: error)
      } else {
        self.delegate?.eventsLoaded(events: self.mockEvents)
      }
    }
  }
  
  // MARK: - Org
  override func getOrgChart() {
    DispatchQueue.main.async {
      if let error = self.mockError {
        self.delegate?.orgFailed(error: error)
      } else {
        self.delegate?.orgLoaded(org: self.mockEmployess)
      }
    }
  }
  
//  func mockEvents() -> [Event] {
//    let events = [
//      Event(
//        name: "Event 1",
//        date: Date(),
//        type: .appointment,
//        duration: .hours(1)),
//      Event(
//        name: "Event 2",
//        date: Date(timeIntervalSinceNow: .days(20)),
//        type: .meeting,
//        duration: .minutes(30)),
//      Event(
//        name: "Event 3",
//        date: Date(timeIntervalSinceNow: -.days(1)),
//        type: .domesticHoliday,
//        duration: .days(1))
//    ]
//    return events
//  }
  
}
