import XXClient
import XXMessengerClient

extension Message {
  static func stub(_ stubId: Int) -> Message {
    .init(
      messageType: stubId,
      id: "id-\(stubId)".data(using: .utf8)!,
      payload: "payload-\(stubId)".data(using: .utf8)!,
      sender: "sender-\(stubId)".data(using: .utf8)!,
      recipientId: "recipientId-\(stubId)".data(using: .utf8)!,
      ephemeralId: stubId,
      timestamp: stubId,
      encrypted: stubId % 2 == 0,
      roundId: stubId,
      roundURL: "roundURL-\(stubId)"
    )
  }
}

extension ReceivedFile {
  static func stub(_ id: Int) -> ReceivedFile {
    ReceivedFile(
      transferId: "transfer-id-\(id)".data(using: .utf8)!,
      senderId: "sender-id-\(id)".data(using: .utf8)!,
      preview: "preview-\(id)".data(using: .utf8)!,
      name: "name-\(id)",
      type: "type-\(id)",
      size: id
    )
  }
}

extension MessageServiceList {
  static func stub() -> MessageServiceList {
    (1...3).map { .stub($0) }
  }
}

extension MessageServiceListElement {
  static func stub(_ id: Int) -> MessageServiceListElement {
    MessageServiceListElement(
      id: "id-\(id)".data(using: .utf8)!,
      services: (1...3).map { $0 + 10 * id }.map { .stub($0) }
    )
  }
}

extension MessageService {
  static func stub(_ id: Int) -> MessageService {
    MessageService(
      identifier: "identifier-\(id)".data(using: .utf8)!,
      tag: "tag-\(id)",
      metadata: "metadata-\(id)".data(using: .utf8)!
    )
  }
}
