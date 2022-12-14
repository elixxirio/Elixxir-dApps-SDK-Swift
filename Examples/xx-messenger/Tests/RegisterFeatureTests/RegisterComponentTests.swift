import ComposableArchitecture
import CustomDump
import XCTest
import XXClient
import XXMessengerClient
import XXModels
@testable import RegisterFeature

final class RegisterComponentTests: XCTestCase {
  func testRegister() throws {
    let now = Date()
    let username = "registering-username"
    let myContactId = "my-contact-id".data(using: .utf8)!
    let myContactData = "my-contact-data".data(using: .utf8)!
    let myContactUsername = username
    let myContactEmail = "my-contact-email"
    let myContactPhone = "my-contact-phone"
    let myContactFacts = [
      Fact(type: .username, value: myContactUsername),
      Fact(type: .email, value: myContactEmail),
      Fact(type: .phone, value: myContactPhone),
    ]

    var messengerDidRegisterUsername: [String] = []
    var didGetMyContact: [MessengerMyContact.IncludeFacts?] = []
    var dbDidSaveContact: [XXModels.Contact] = []

    let store = TestStore(
      initialState: RegisterComponent.State(),
      reducer: RegisterComponent()
    )
    store.dependencies.app.now = { now }
    store.dependencies.app.mainQueue = .immediate
    store.dependencies.app.bgQueue = .immediate
    store.dependencies.app.messenger.register.run = { username in
      messengerDidRegisterUsername.append(username)
    }
    store.dependencies.app.messenger.myContact.run = { includeFacts in
      didGetMyContact.append(includeFacts)
      var contact = XXClient.Contact.unimplemented(myContactData)
      contact.getIdFromContact.run = { _ in myContactId }
      contact.getFactsFromContact.run = { _ in myContactFacts }
      return contact
    }
    store.dependencies.app.dbManager.getDB.run = {
      var db: Database = .unimplemented
      db.saveContact.run = { contact in
        dbDidSaveContact.append(contact)
        return contact
      }
      return db
    }

    store.send(.set(\.$focusedField, .username)) {
      $0.focusedField = .username
    }

    store.send(.set(\.$username, myContactUsername)) {
      $0.username = myContactUsername
    }

    store.send(.registerTapped) {
      $0.focusedField = nil
      $0.isRegistering = true
    }

    XCTAssertNoDifference(messengerDidRegisterUsername, [username])
    XCTAssertNoDifference(dbDidSaveContact, [
      XXModels.Contact(
        id: myContactId,
        marshaled: myContactData,
        username: myContactUsername,
        email: myContactEmail,
        phone: myContactPhone,
        createdAt: now
      )
    ])

    store.receive(.finished) {
      $0.isRegistering = false
    }
  }

  func testGetDbFailure() throws {
    struct Error: Swift.Error, Equatable {}
    let error = Error()

    let store = TestStore(
      initialState: RegisterComponent.State(),
      reducer: RegisterComponent()
    )

    let mainQueue = DispatchQueue.test
    let bgQueue = DispatchQueue.test

    store.dependencies.app.mainQueue = mainQueue.eraseToAnyScheduler()
    store.dependencies.app.bgQueue = bgQueue.eraseToAnyScheduler()
    store.dependencies.app.dbManager.getDB.run = { throw error }

    store.send(.registerTapped) {
      $0.isRegistering = true
    }

    bgQueue.advance()
    mainQueue.advance()

    store.receive(.failed(error.localizedDescription)) {
      $0.isRegistering = false
      $0.failure = error.localizedDescription
    }
  }

  func testMessengerRegisterFailure() throws {
    struct Error: Swift.Error, Equatable {}
    let error = Error()

    let store = TestStore(
      initialState: RegisterComponent.State(),
      reducer: RegisterComponent()
    )

    let mainQueue = DispatchQueue.test
    let bgQueue = DispatchQueue.test

    store.dependencies.app.mainQueue = mainQueue.eraseToAnyScheduler()
    store.dependencies.app.bgQueue = bgQueue.eraseToAnyScheduler()
    store.dependencies.app.dbManager.getDB.run = { .unimplemented }
    store.dependencies.app.messenger.register.run = { _ in throw error }

    store.send(.registerTapped) {
      $0.isRegistering = true
    }

    bgQueue.advance()
    mainQueue.advance()

    store.receive(.failed(error.localizedDescription)) {
      $0.isRegistering = false
      $0.failure = error.localizedDescription
    }
  }

  func testRegisterUsernameMismatchFailure() throws {
    let now = Date()
    let username = "registering-username"
    let myContactId = "my-contact-id".data(using: .utf8)!
    let myContactData = "my-contact-data".data(using: .utf8)!
    let myContactUsername = "my-contact-username"
    let myContactEmail = "my-contact-email"
    let myContactPhone = "my-contact-phone"
    let myContactFacts = [
      Fact(type: .username, value: myContactUsername),
      Fact(type: .email, value: myContactEmail),
      Fact(type: .phone, value: myContactPhone),
    ]

    var messengerDidRegisterUsername: [String] = []
    var didGetMyContact: [MessengerMyContact.IncludeFacts?] = []
    var dbDidSaveContact: [XXModels.Contact] = []

    let store = TestStore(
      initialState: RegisterComponent.State(
        username: username
      ),
      reducer: RegisterComponent()
    )
    store.dependencies.app.now = { now }
    store.dependencies.app.mainQueue = .immediate
    store.dependencies.app.bgQueue = .immediate
    store.dependencies.app.messenger.register.run = { username in
      messengerDidRegisterUsername.append(username)
    }
    store.dependencies.app.messenger.myContact.run = { includeFacts in
      didGetMyContact.append(includeFacts)
      var contact = XXClient.Contact.unimplemented(myContactData)
      contact.getIdFromContact.run = { _ in myContactId }
      contact.getFactsFromContact.run = { _ in myContactFacts }
      return contact
    }
    store.dependencies.app.dbManager.getDB.run = {
      var db: Database = .unimplemented
      db.saveContact.run = { contact in
        dbDidSaveContact.append(contact)
        return contact
      }
      return db
    }

    store.send(.registerTapped) {
      $0.focusedField = nil
      $0.isRegistering = true
    }

    XCTAssertNoDifference(messengerDidRegisterUsername, [username])
    XCTAssertNoDifference(dbDidSaveContact, [
      XXModels.Contact(
        id: myContactId,
        marshaled: myContactData,
        username: myContactUsername,
        email: myContactEmail,
        phone: myContactPhone,
        createdAt: now
      )
    ])

    let failure = RegisterComponent.State.Error.usernameMismatch(
      registering: username,
      registered: myContactUsername
    )
    store.receive(.failed(failure.localizedDescription)) {
      $0.isRegistering = false
      $0.failure = failure.localizedDescription
    }
  }
}
