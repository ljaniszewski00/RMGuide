import SwiftUI

@main
struct RMGuideApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CharactersListView()
            }
            .tint(.red)
            .accentColor(.red)
        }
    }
}
