

import SwiftUI

@main
struct PHOTOCAPApp: App {

    @StateObject var dataManager = DataManager()
    @StateObject var api = replicateAPI()
    
    var body: some Scene {
        WindowGroup {
            ContentView(cards: Card(id: 0, image: UIImage(), title: ""), datamodel: DataModel(favourites: [], history: [], isFirstLaunch: Bool()))
                .environmentObject(api)
                .environmentObject(dataManager)
            
        }
    }
}

