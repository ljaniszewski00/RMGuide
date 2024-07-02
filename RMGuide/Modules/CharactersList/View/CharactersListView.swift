import SwiftUI

struct CharactersListView: View {
    @StateObject private var charactersListViewModel: CharactersListViewModel = CharactersListViewModel()
    
    var body: some View {
        VStack {
            if charactersListViewModel.displayCharactersList {
                VStack {
                    List {
                        Views.CharactersGrid()
                            .environmentObject(charactersListViewModel)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await charactersListViewModel.onRefresh()
                    }
                }
                .searchable(text: $charactersListViewModel.searchText)
                .modifier(LoadingIndicatorModal(isPresented: $charactersListViewModel.showLoadingModal))
                .modifier(ErrorModal(isPresented: $charactersListViewModel.showErrorModal,
                                     errorDescription: charactersListViewModel.errorText))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            charactersListViewModel.displayOnlyFavoriteCharacters.toggle()
                        } label: {
                            let imageName: String = charactersListViewModel.displayOnlyFavoriteCharacters ?
                            Views.Constants.favoriteImageName : Views.Constants.nonFavoriteImageName
                            Image(systemName: imageName)
                                .foregroundStyle(
                                    .red.opacity(Views.Constants.favoriteButtonImageColorOpacity)
                                )
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            charactersListViewModel.displayCharactersList = false
                        } label: {
                            Image(systemName: Views.Constants.exitButtonImageName)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .navigationTitle(Views.Constants.navigationTitleFullList)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                Views.StartView()
                    .environmentObject(charactersListViewModel)
            }
        }
        .onAppear {
            charactersListViewModel.onAppear()
        }
    }
}

#Preview {
    CharactersListView()
}

private extension Views {
    struct Constants {
        static let startViewVStackSpacing: CGFloat = 15
        static let guideAppText: String = "Guide App"
        static let guideAppLabelBottomPadding: CGFloat = 20
        static let instructionDescription: String = "Click the button below to display full Rick and Morty characters list."
        static let buttonLabel: String = "Show characters list"
        static let HStackPadding: CGFloat = 10
        static let HStackHorizontalPadding: CGFloat = 10
        
        static let exitButtonImageName: String = "rectangle.portrait.and.arrow.right"
        static let nonFavoriteImageName: String = "heart"
        static let favoriteImageName: String = "heart.fill"
        static let favoriteButtonImageColorOpacity: CGFloat = 0.8
        static let navigationTitleFullList: String = "Characters"
        
        static let gridItemMinimumSize: CGFloat = 50
        static let navigationLinkOpacity: CGFloat = 0.0
        static let gridListRowInsetValue: CGFloat = 0
        static let characterGridCellVStackSpacing: CGFloat = 0
        static let characterGridCellImageSize: CGFloat = 120
        static let imagePlaceholderName: String = "person.crop.circle.fill"
        static let favoriteImageWidth: CGFloat = 20
        static let favoriteImageHeight: CGFloat = 17
        static let favoriteImageBackgroundPadding: CGFloat = 10
        static let favoriteImageXOffset: CGFloat = 15
        static let characterNameBackgroundPadding: CGFloat = 10
        static let characterNameHorizontalPadding: CGFloat = 5
        static let characterNameYOffset: CGFloat = -15
    }
    
    struct StartView: View {
        @EnvironmentObject private var charactersListViewModel: CharactersListViewModel
        
        var body: some View {
            VStack(spacing: Views.Constants.startViewVStackSpacing) {
                Spacer()
                
                Image(.rickAndMortyLogo)
                    .resizable()
                    .scaledToFit()
                
                Text(Views.Constants.guideAppText)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.vertical)
                    .padding(.bottom, Views.Constants.guideAppLabelBottomPadding)
                
                Text(Views.Constants.instructionDescription)
                    .font(.headline)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Button {
                    charactersListViewModel.displayCharactersList = true
                } label: {
                    HStack {
                        Text(Views.Constants.buttonLabel)
                            .font(.headline)
                    }
                    .padding()
                    .padding(.horizontal)
                    .background(
                        .ultraThinMaterial,
                        in: Capsule()
                    )
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    struct CharactersList: View {
        var body: some View {
            EmptyView()
        }
    }
    
    struct CharactersGrid: View {
        @EnvironmentObject private var charactersListViewModel: CharactersListViewModel
        
        @State var selectedCharacter: RMCharacter?
        
        private let columns: [GridItem] = [
            GridItem(.flexible(minimum: Views.Constants.gridItemMinimumSize)),
            GridItem(.flexible(minimum: Views.Constants.gridItemMinimumSize))
        ]
        
        var body: some View {
            LazyVGrid(columns: columns) {
                ForEach(charactersListViewModel.charactersToDisplay, id: \.id) { character in
                    Views.CharacterGridCell(character: character)
                        .background {
                            NavigationLink(
                                destination: CharacterDetailsView(character: character),
                                tag: character,
                                selection: $selectedCharacter,
                                label: {
                                    EmptyView()
                            })
                            .opacity(Views.Constants.navigationLinkOpacity)
                        }
                        .onTapGesture {
                            selectedCharacter = character
                        }
                        .environmentObject(charactersListViewModel)
                }
            }
            .padding(.top)
            .listRowInsets(.init(
                top: Views.Constants.gridListRowInsetValue,
                leading: Views.Constants.gridListRowInsetValue,
                bottom: Views.Constants.gridListRowInsetValue,
                trailing: Views.Constants.gridListRowInsetValue
            ))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden)
        }
    }
    
    struct CharacterGridCell: View {
        @EnvironmentObject private var charactersListViewModel: CharactersListViewModel
        let character: RMCharacter
        
        var body: some View {
            let isFavorite: Bool = charactersListViewModel.isCharacterFavorite(characterId: character.id)
            
            VStack(spacing: Views.Constants.characterGridCellVStackSpacing) {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: character.image)) { image in
                        image
                            .characterImageModifier()
                    } placeholder: {
                        Image(systemName: Views.Constants.imagePlaceholderName)
                            .characterImageModifier()
                    }
                    
                    Image(systemName: isFavorite ? Views.Constants.favoriteImageName : Views.Constants.nonFavoriteImageName)
                        .resizable()
                        .frame(width: Views.Constants.favoriteImageWidth,
                               height: Views.Constants.favoriteImageHeight)
                        .foregroundStyle(
                            .red.opacity(Views.Constants.favoriteButtonImageColorOpacity)
                        )
                        .padding(Views.Constants.favoriteImageBackgroundPadding)
                        .background(
                            .ultraThinMaterial,
                            in: Circle()
                        )
                        .onTapGesture {
                            charactersListViewModel.manageCharacterToBeFavorite(characterId: character.id)
                        }
                        .offset(x: Views.Constants.favoriteImageXOffset)
                }
                
                Text(character.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(Views.Constants.characterNameBackgroundPadding)
                    .padding(.horizontal, Views.Constants.characterNameHorizontalPadding)
                    .background(
                        .ultraThinMaterial,
                        in: Capsule()
                    )
                    .offset(y: Views.Constants.characterNameYOffset)
            }
        }
    }
}

private extension Image {
    func characterImageModifier() -> some View {
        self.resizable()
            .frame(width: Views.Constants.characterGridCellImageSize,
                   height: Views.Constants.characterGridCellImageSize)
            .clipShape(Circle())
    }
}
