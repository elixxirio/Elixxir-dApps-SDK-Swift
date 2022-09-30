import AppCore
import Combine
import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay
import XXClient
import XXMessengerClient
import XXModels

public struct SendRequestState: Equatable {
  public init(
    contact: XXClient.Contact,
    myContact: XXClient.Contact? = nil,
    sendUsername: Bool = true,
    sendEmail: Bool = true,
    sendPhone: Bool = true,
    isSending: Bool = false,
    failure: String? = nil
  ) {
    self.contact = contact
    self.myContact = myContact
    self.sendUsername = sendUsername
    self.sendEmail = sendEmail
    self.sendPhone = sendPhone
    self.isSending = isSending
    self.failure = failure
  }

  public var contact: XXClient.Contact
  public var myContact: XXClient.Contact?
  @BindableState public var sendUsername: Bool
  @BindableState public var sendEmail: Bool
  @BindableState public var sendPhone: Bool
  public var isSending: Bool
  public var failure: String?
}

public enum SendRequestAction: Equatable, BindableAction {
  case start
  case sendTapped
  case sendSucceeded
  case sendFailed(String)
  case binding(BindingAction<SendRequestState>)
  case myContactFetched(XXClient.Contact)
  case myContactFetchFailed(NSError)
}

public struct SendRequestEnvironment {
  public init(
    messenger: Messenger,
    db: DBManagerGetDB,
    mainQueue: AnySchedulerOf<DispatchQueue>,
    bgQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.messenger = messenger
    self.db = db
    self.mainQueue = mainQueue
    self.bgQueue = bgQueue
  }

  public var messenger: Messenger
  public var db: DBManagerGetDB
  public var mainQueue: AnySchedulerOf<DispatchQueue>
  public var bgQueue: AnySchedulerOf<DispatchQueue>
}

#if DEBUG
extension SendRequestEnvironment {
  public static let unimplemented = SendRequestEnvironment(
    messenger: .unimplemented,
    db: .unimplemented,
    mainQueue: .unimplemented,
    bgQueue: .unimplemented
  )
}
#endif

public let sendRequestReducer = Reducer<SendRequestState, SendRequestAction, SendRequestEnvironment>
{ state, action, env in
  switch action {
  case .start:
    return Effect.run { subscriber in
      do {
        var contact = try env.messenger.e2e.tryGet().getContact()
        let facts = try env.messenger.ud.tryGet().getFacts()
        try contact.setFacts(facts)
        subscriber.send(.myContactFetched(contact))
      } catch {
        subscriber.send(.myContactFetchFailed(error as NSError))
      }
      subscriber.send(completion: .finished)
      return AnyCancellable {}
    }
    .receive(on: env.mainQueue)
    .subscribe(on: env.bgQueue)
    .eraseToEffect()

  case .myContactFetched(let contact):
    state.myContact = contact
    state.failure = nil
    return .none

  case .myContactFetchFailed(let failure):
    state.myContact = nil
    state.failure = failure.localizedDescription
    return .none

  case .sendTapped:
    state.isSending = true
    state.failure = nil
    return .result { [state] in
      func updateAuthStatus(_ authStatus: XXModels.Contact.AuthStatus) throws {
        try env.db().bulkUpdateContacts(
          .init(id: [try state.contact.getId()]),
          .init(authStatus: authStatus)
        )
      }
      do {
        try updateAuthStatus(.requesting)
        let myFacts = try state.myContact?.getFacts() ?? []
        var includedFacts: [Fact] = []
        if state.sendUsername, let fact = myFacts.get(.username) {
          includedFacts.append(fact)
        }
        if state.sendEmail, let fact = myFacts.get(.email) {
          includedFacts.append(fact)
        }
        if state.sendPhone, let fact = myFacts.get(.phone) {
          includedFacts.append(fact)
        }
        _ = try env.messenger.e2e.tryGet().requestAuthenticatedChannel(
          partner: state.contact,
          myFacts: includedFacts
        )
        try updateAuthStatus(.requested)
        return .success(.sendSucceeded)
      } catch {
        try? updateAuthStatus(.requestFailed)
        return .success(.sendFailed(error.localizedDescription))
      }
    }
    .subscribe(on: env.bgQueue)
    .receive(on: env.mainQueue)
    .eraseToEffect()

  case .sendSucceeded:
    state.isSending = false
    state.failure = nil
    return .none

  case .sendFailed(let failure):
    state.isSending = false
    state.failure = failure
    return .none

  case .binding(_):
    return .none
  }
}
.binding()
