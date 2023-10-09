
import Foundation
import SwiftUI


struct DataModel: Codable, Equatable {
    
    var favourites: [FavouriteData]
    var history: [HistoryData]
    var isFirstLaunch: Bool
    
    init(favourites: [FavouriteData], history: [HistoryData], isFirstLaunch: Bool) {
        self.favourites = favourites
        self.history = history
        self.isFirstLaunch = isFirstLaunch
    }
    
    struct FavouriteData: Codable, Equatable {
        
        var favourites: String
        var date: Date
    
        init(favourites: String, date: Date) {
            self.favourites = favourites
            self.date = date
        }
    }
    
    struct HistoryData: Codable, Hashable, Equatable {
        
        var histories: String
        var date: Date
        
        init(histories: String, date: Date) {
            self.histories = histories
            self.date = date
        }
    }
    
    func updateCompletion() -> DataModel {
          return DataModel(favourites: [], history: [], isFirstLaunch: isFirstLaunch)
      }
}

struct Card : Identifiable, Hashable {
    
    var id: Int
    var image : UIImage
    var title: String
}
