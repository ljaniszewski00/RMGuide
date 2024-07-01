import SwiftUI

struct CharactersView: View {
    @StateObject private var charactersViewModel: CharactersViewModel = CharactersViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(charactersViewModel.charactersToDisplay, id: \.id) { character in
                    NavigationLink {
                        CharacterDetailsView(character: character)
                    } label: {
                        HStack {
                            Image(systemName: Views.Constants.nonFavoriteImageName)
                                .foregroundStyle(.blue)
                                .onTapGesture {
                                    
                                }

                            Text(character.name)
                        }
                    }
                }
            }
            .refreshable {
                await charactersViewModel.onRefresh()
            }
        }
        .searchable(text: $charactersViewModel.searchText)
        .modifier(LoadingIndicatorModal(isPresented: $charactersViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $charactersViewModel.showErrorModal,
                             errorDescription: charactersViewModel.errorText))
        .navigationTitle(Views.Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CharactersView()
}

private extension Views {
    struct Constants {
        static let nonFavoriteImageName: String = "star"
        static let favoriteImageName: String = "star.fill"
        static let navigationTitle: String = "Characters"
    }
}
