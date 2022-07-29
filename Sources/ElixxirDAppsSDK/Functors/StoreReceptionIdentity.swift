import Bindings
import XCTestDynamicOverlay

public struct StoreReceptionIdentity {
  public var run: (String, ReceptionIdentity, Int) throws -> Bool

  public func callAsFunction(
    key: String,
    identity: ReceptionIdentity,
    cmixId: Int
  ) throws -> Bool {
    try run(key, identity, cmixId)
  }
}

extension StoreReceptionIdentity {
  public static let live = StoreReceptionIdentity { key, identity, cmixId in
    var error: NSError?
    let identityData = try identity.encode()
    let result = BindingsStoreReceptionIdentity(key, identityData, cmixId, &error)
    if let error = error {
      throw error
    }
    return result
  }
}

extension StoreReceptionIdentity {
  public static let unimplemented = StoreReceptionIdentity(
    run: XCTUnimplemented("\(Self.self)")
  )
}
