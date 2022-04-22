
import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value(for key: String) throws -> String {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) as? String else {
            throw Error.missingKey
        }
        return object
    }

    static var apiKey: String {
        return try! Configuration.value(for: "API_KEY")
    }
}
