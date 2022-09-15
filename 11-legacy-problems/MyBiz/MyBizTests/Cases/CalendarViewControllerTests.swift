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

import XCTest
@testable import MyBiz

final class CalendarViewControllerTests: XCTestCase {

  var sut: CalendarViewController!
  var mockApi: MockApi!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Calendar") as? CalendarViewController
    mockApi = MockApi()
    sut.api = mockApi
    sut.loadViewIfNeeded()
  }
  
  override func tearDownWithError() throws {
    mockApi = nil
    sut = nil
    try super.tearDownWithError()
  }
  
  func mockEmployees() -> [Employee] {
    let employees = [
        Employee(
          id: "Cap",
          givenName: "Steve",
          familyName: "Rogers",
          location: "Brooklyn",
          manager: nil,
          directReports: [],
          birthday: "07-04-1920"),
        Employee(
          id: "Surfer",
          givenName: "Norrin",
          familyName: "Radd",
          location: "Zenn-La",
          manager: nil,
          directReports: [],
          birthday: "03-01-1966"),
        Employee(
          id: "Wasp",
          givenName: "Hope",
          familyName: "van Dyne",
          location: "San Francisco",
          manager: nil,
          directReports: [],
          birthday: "01-02-1979")
      ]
      return employees
  }
  
  func mockBirthdayEvents() -> [Event] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Employee.birthdayFormat
    return [
      Event(
        name: "Steve Rogers Birthday",
        date: dateFormatter.date(from: "07-04-1920")!.next()!,
        type: .birthday,
        duration: 0),
      Event(
        name: "Norrin Radd Birthday",
        date: dateFormatter.date(from: "03-01-1966")!.next()!,
        type: .birthday,
        duration: 0),
      Event(
        name: "Hope van Dyne Birthday",
        date: dateFormatter.date(from: "01-02-1979")!.next()!,
        type: .birthday,
        duration: 0)
    ]
  }
  
  func testLoadEvents_getsBirthdays() {
    // given
    mockApi.mockEmployess = mockEmployees()
    let expectedEvents = mockBirthdayEvents()
    
    // when
    let predicate = NSPredicate { _, _ -> Bool in
      !self.sut.events.isEmpty
    }
    let exp = expectation(for: predicate, evaluatedWith: sut)
    sut.loadEvents()
    
    // then
    waitForExpectations(timeout: 1)
    XCTAssertEqual(sut.events, expectedEvents)
  }

}
