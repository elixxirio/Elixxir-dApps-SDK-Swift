import Bindings

public struct CMixManager {
  public var hasStorage: CMixManagerHasStorage
  public var create: CMixManagerCreate
  public var load: CMixManagerLoad
  public var remove: CMixManagerRemove
}

extension CMixManager {
  public static func live(
    directoryPath: String = FileManager.default
      .urls(for: .applicationSupportDirectory, in: .userDomainMask)
      .first!
      .appendingPathComponent("xx.network.client")
      .path,
    fileManager: FileManager = .default,
    environment: Environment = .mainnet,
    downloadNDF: DownloadAndVerifySignedNdf = .live,
    generateSecret: GenerateSecret = .live,
    passwordStorage: PasswordStorage,
    newCMix: NewCMix = .live,
    getCMixParams: GetCMixParams = .liveDefault,
    loadCMix: LoadCMix = .live
  ) -> CMixManager {
    CMixManager(
      hasStorage: .live(
        directoryPath: directoryPath,
        fileManager: fileManager
      ),
      create: .live(
        environment: environment,
        downloadNDF: downloadNDF,
        generateSecret: generateSecret,
        passwordStorage: passwordStorage,
        directoryPath: directoryPath,
        fileManager: fileManager,
        newCMix: newCMix,
        getCMixParams: getCMixParams,
        loadCMix: loadCMix
      ),
      load: .live(
        directoryPath: directoryPath,
        passwordStorage: passwordStorage,
        getCMixParams: getCMixParams,
        loadCMix: loadCMix
      ),
      remove: .live(
        directoryPath: directoryPath,
        fileManager: fileManager
      )
    )
  }
}

extension CMixManager {
  public static let unimplemented = CMixManager(
    hasStorage: .unimplemented,
    create: .unimplemented,
    load: .unimplemented,
    remove: .unimplemented
  )
}