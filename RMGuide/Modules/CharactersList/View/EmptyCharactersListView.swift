import SwiftUI

struct EmptyCharactersListView: View {
    @State private var shouldChangeToCharactersList: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(Views.Constants.welcomeText)
                .font(.title)
                .padding(.bottom)
            
            Text(Views.Constants.instructionDescription)
            
            Spacer()
            
            NavigationLink(isActive: $shouldChangeToCharactersList) {
                CharactersView()
            } label: {
                HStack {
                    Text("Tap to Proceed")
                }
                .padding(Views.Constants.HStackPadding)
                .padding(.horizontal, Views.Constants.HStackHorizontalPadding)
                .background(
                    .ultraThinMaterial,
                    in: Capsule()
                )
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(Views.Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EmptyCharactersListView()
}

private extension Views {
    struct Constants {
        static let welcomeText: String = "Welcome!"
        static let instructionDescription: String = "Click the button below to display full Rick and Morty characters list."
        static let buttonLabel: String = "Show characters list"
        static let navigationTitle: String = "Rick and Morty Guide"
        
        static let HStackPadding: CGFloat = 10
        static let HStackHorizontalPadding: CGFloat = 10
    }
}
