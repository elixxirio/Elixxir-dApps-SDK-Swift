import CustomDump
import XCTest
import XCTestDynamicOverlay
import XXClient
@testable import XXMessengerClient

final class MessengerGetNotificationReportsTests: XCTestCase {
  func testGetReport() throws {
    let serviceList = MessageServiceList.stub()
    let notificationCSV = "notification-csv"
    let notificationReports = [NotificationReport].stub()

    struct GetNotificationsReportParams: Equatable {
      var notificationCSV: String
      var serviceList: MessageServiceList
    }
    var didGetNotificationsReport: [GetNotificationsReportParams] = []

    var env: MessengerEnvironment = .unimplemented
    env.serviceList.get = {
      serviceList
    }
    env.getNotificationsReport.run = { notificationCSV, serviceList in
      didGetNotificationsReport.append(.init(
        notificationCSV: notificationCSV,
        serviceList: serviceList
      ))
      return notificationReports
    }
    let getReports: MessengerGetNotificationReports = .live(env)

    let reports = try getReports(notificationCSV: notificationCSV)

    XCTAssertNoDifference(didGetNotificationsReport, [
      .init(
        notificationCSV: notificationCSV,
        serviceList: serviceList
      )
    ])
    XCTAssertNoDifference(reports, notificationReports)
  }

  func testGetReportWhenServiceListMissing() {
    var env: MessengerEnvironment = .unimplemented
    env.e2e.get = { .unimplemented }
    env.serviceList.get = { nil }
    let getReports: MessengerGetNotificationReports = .live(env)

    XCTAssertThrowsError(try getReports(notificationCSV: "")) { error in
      XCTAssertNoDifference(
        error as? MessengerGetNotificationReports.Error,
        .serviceListMissing
      )
    }
  }
}

private extension Array where Element == NotificationReport {
  static func stub() -> [NotificationReport] {
    [.stub(), .stub(), .stub()]
  }
}

private extension NotificationReport {
  static func stub() -> NotificationReport {
    NotificationReport(
      forMe: .random(),
      type: ReportType.allCases.randomElement()!,
      source: "source-\(Int.random(in: 100...999))".data(using: .utf8)!
    )
  }
}
