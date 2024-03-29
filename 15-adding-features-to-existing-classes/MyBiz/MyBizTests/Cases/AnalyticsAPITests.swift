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

final class AnalyticsAPITests: XCTestCase {
  
  var sut: AnalyticsAPI { return sutImplementation }
  var sutImplementation: API!
  var mockSender: MockSender!
  
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sutImplementation = API(server: "test")
    mockSender = MockSender()
    sutImplementation.sender = mockSender
  }
  
  override func tearDownWithError() throws {
    sutImplementation = nil
    mockSender = nil
    try super.tearDownWithError()
  }
  
  
  func testAPI_whenReportSent_thenReportIsSent() {
    // given
    let date = Date()
    let interval: TimeInterval = 20.0
    let report = Report(name: "name",
                        recordedDate: date,
                        type: "type",
                        duration: interval,
                        device: "device",
                        os: "os",
                        appVersion: "appVersion")
    
    // when
    sut.sendReport(report: report)
    
    // then
    XCTAssertNotNil(mockSender.lastSent)
    XCTAssertEqual(report.name, "name")
    XCTAssertEqual((mockSender.lastSent as? Report)?.name, "name")
  }
   
}
