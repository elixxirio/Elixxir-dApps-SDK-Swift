import Bindings
import XCTestDynamicOverlay

public struct E2EGetAllPartnerIds {
  public var run: () throws -> [Data]

  public func callAsFunction() throws -> [Data] {
    try run()
  }
}

extension E2EGetAllPartnerIds {
  public static func live(_ bindingsE2E: BindingsE2e) -> E2EGetAllPartnerIds {
    E2EGetAllPartnerIds {
      let listData = try bindingsE2E.getAllPartnerIDs()
      return try JSONDecoder().decode([Data].self, from: listData)
    }
  }
}

extension E2EGetAllPartnerIds {
  public static let unimplemented = E2EGetAllPartnerIds(
    run: XCTUnimplemented("\(Self.self)")
  )
}
