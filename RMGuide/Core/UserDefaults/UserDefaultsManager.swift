import Foundation

final class UserDefaultsManager<T> {
    private let userDefaults = UserDefaults.standard
    private let key: UserDefaultsKey
    
    init(key: UserDefaultsKey) {
        self.key = key
    }
    
    func getData() -> T? {
        userDefaults.value(forKey: key.rawValue) as? T
    }
    
    func addData(_ data: T) {
        userDefaults.set(data, forKey: key.rawValue)
    }
}
