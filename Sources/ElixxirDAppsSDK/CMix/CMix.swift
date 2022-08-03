import Bindings

public struct CMix {
  public var getId: CMixGetId
  public var getReceptionRegistrationValidationSignature: CMixGetReceptionRegistrationValidationSignature
  public var makeReceptionIdentity: CMixMakeReceptionIdentity
  public var makeLegacyReceptionIdentity: CMixMakeLegacyReceptionIdentity
  public var isHealthy: CMixIsHealthy
  public var hasRunningProcesses: CMixHasRunningProcesses
  public var networkFollowerStatus: CMixNetworkFollowerStatus
  public var startNetworkFollower: CMixStartNetworkFollower
  public var stopNetworkFollower: CMixStopNetworkFollower
  public var waitForNetwork: CMixWaitForNetwork
  public var registerClientErrorCallback: CMixRegisterClientErrorCallback
  public var addHealthCallback: CMixAddHealthCallback
  public var waitForMessageDelivery: CMixWaitForMessageDelivery
  public var connect: CMixConnect
}

extension CMix {
  public static func live(_ bindingsCMix: BindingsCmix) -> CMix {
    CMix(
      getId: .live(bindingsCMix),
      getReceptionRegistrationValidationSignature: .live(bindingsCMix),
      makeReceptionIdentity: .live(bindingsCMix),
      makeLegacyReceptionIdentity: .live(bindingsCMix),
      isHealthy: .live(bindingsCMix),
      hasRunningProcesses: .live(bindingsCMix),
      networkFollowerStatus: .live(bindingsCMix),
      startNetworkFollower: .live(bindingsCMix),
      stopNetworkFollower: .live(bindingsCMix),
      waitForNetwork: .live(bindingsCMix),
      registerClientErrorCallback: .live(bindingsCMix),
      addHealthCallback: .live(bindingsCMix),
      waitForMessageDelivery: .live(bindingsCMix),
      connect: .live(bindingsCMix)
    )
  }
}

extension CMix {
  public static let unimplemented = CMix(
    getId: .unimplemented,
    getReceptionRegistrationValidationSignature: .unimplemented,
    makeReceptionIdentity: .unimplemented,
    makeLegacyReceptionIdentity: .unimplemented,
    isHealthy: .unimplemented,
    hasRunningProcesses: .unimplemented,
    networkFollowerStatus: .unimplemented,
    startNetworkFollower: .unimplemented,
    stopNetworkFollower: .unimplemented,
    waitForNetwork: .unimplemented,
    registerClientErrorCallback: .unimplemented,
    addHealthCallback: .unimplemented,
    waitForMessageDelivery: .unimplemented,
    connect: .unimplemented
  )
}