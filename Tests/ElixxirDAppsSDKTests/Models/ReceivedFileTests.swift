import CustomDump
import XCTest
@testable import ElixxirDAppsSDK

final class ReceivedFileTests: XCTestCase {
  func testCoding() throws {
    let transferIdB64 = "B4Z9cwU18beRoGbk5xBjbcd5Ryi9ZUFA2UBvi8FOHWo="
    let senderIdB64 = "emV6aW1hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD"
    let previewB64 = "aXQncyBtZSBhIHByZXZpZXc="
    let name = "testfile.txt"
    let type = "text file"
    let size: Int = 2048
    let jsonString = """
    {
      "TransferID": "\(transferIdB64)",
      "SenderID": "\(senderIdB64)",
      "Preview": "\(previewB64)",
      "Name": "\(name)",
      "Type": "\(type)",
      "Size": \(size)
    }
    """
    let jsonData = jsonString.data(using: .utf8)!
    let receivedFile = try ReceivedFile.decode(jsonData)

    XCTAssertNoDifference(receivedFile, ReceivedFile(
      transferId: Data(base64Encoded: transferIdB64)!,
      senderId: Data(base64Encoded: senderIdB64)!,
      preview: Data(base64Encoded: previewB64)!,
      name: name,
      type: type,
      size: size
    ))

    let encodedReceivedFile = try receivedFile.encode()
    let decodedReceivedFile = try ReceivedFile.decode(encodedReceivedFile)

    XCTAssertNoDifference(decodedReceivedFile, receivedFile)
  }
}
