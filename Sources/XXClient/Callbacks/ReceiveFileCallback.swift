import Bindings
import XCTestDynamicOverlay

public struct ReceiveFileCallback {
  public typealias Result = Swift.Result<ReceivedFile, NSError>

  public init(handle: @escaping (Result) -> Void) {
    self.handle = handle
  }

  public var handle: (Result) -> Void
}

extension ReceiveFileCallback {
  public static let unimplemented = ReceiveFileCallback(
    handle: XCTUnimplemented("\(Self.self)")
  )
}

extension ReceiveFileCallback {
  func makeBindingsReceiveFileCallback() -> BindingsReceiveFileCallbackProtocol {
    class CallbackObject: NSObject, BindingsReceiveFileCallbackProtocol {
      init(_ callback: ReceiveFileCallback) {
        self.callback = callback
      }

      let callback: ReceiveFileCallback

      func callback(_ payload: Data?) {
        guard let data = payload else {
          fatalError("BindingsReceiveFileCallback received `nil` payload and `nil` error")
        }
        do {
          callback.handle(.success(try ReceivedFile.decode(data)))
        } catch {
          callback.handle(.failure(error as NSError))
        }
      }
    }

    return CallbackObject(self)
  }
}
