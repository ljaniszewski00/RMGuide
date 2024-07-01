import Foundation

final class EpisodeDetailsViewModel: ObservableObject {
    @Inject private var getRMEpisodeDetailsInteractor: GetRMEpisodeDetailsInteracting
    
    @Published var episode: RMEpisode?
    
    @Published var showLoadingModal: Bool = false
    @Published var showErrorModal: Bool = false
    @Published var errorText: String = ""
    
    let episodeLabel: String
    private let episodeURLString: String
    
    init(episodeLabel: String, episodeURLString: String) {
        self.episodeLabel = episodeLabel
        self.episodeURLString = episodeURLString
        
        Task {
            await fetchEpisodeDetails()
        }
    }
    
    func onRefresh() async {
        await fetchEpisodeDetails()
    }
    
    @MainActor
    private func fetchEpisodeDetails() async {
        guard let episodeNumberString = episodeLabel.components(separatedBy: " ").last else {
            return
        }
        
        let getEpisodeDetailsResult = await getRMEpisodeDetailsInteractor.getRMEpisodeDetails(episodeNumberString: episodeNumberString)
        
        switch getEpisodeDetailsResult {
        case .success(let episode):
            self.episode = episode
        case .failure(let error):
            self.errorText = error.localizedDescription
            self.showErrorModal = true
        }
    }
}
