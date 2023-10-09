
import SwiftUI
import Foundation

class DataManager: ObservableObject {
    
    let cardDataKey : String = "cardData"
    @Published var labelText1: String = ""
    @Published var labelText2: String = ""
    @Published var titles : [String] = []
    @Published var data: DataModel
    @ObservedObject var cardViewModel = CardViewModel()
    @ObservedObject var optionManager = OptionManager()
    
    @Published var deletedFavString : String = ""
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: cardDataKey),
           let decodedData = try? JSONDecoder().decode(DataModel.self, from: savedData) {
            self.data = decodedData
        } else {
            self.data = DataModel(favourites: [], history: [], isFirstLaunch: true)
            
        }
    }
    
    func getSortedFavouritesWithDate() -> [(String, Date)] {
        var favouritesWithDate: [(String, Date)] = []
        for (index, favourite) in data.favourites.enumerated() {
            if index < data.favourites.count {
                let date = data.favourites[index].date
                favouritesWithDate.append((favourite.favourites, date))
            }
        }
        favouritesWithDate.sort(by: { $0.1 < $1.1 })
        return favouritesWithDate
    }

    func addHistoryItems(titlse: [String]) -> DataModel {
        
        var currentHistory = data.history
        var historyTexts = titlse
        
        let currentDate = Date()
        for historyText in historyTexts {
            let newHistory = DataModel.HistoryData(histories: historyText, date: currentDate)
            currentHistory.append(newHistory)
        }
        
        let updatedDataModel = DataModel(favourites: data.favourites, history: currentHistory, isFirstLaunch: data.isFirstLaunch)
        
        data = updatedDataModel
        
        saveDataModelToUserDefaults(updatedDataModel)
        
        return updatedDataModel
    }
    
    func addItem(favourite: String, date: Date) {
        
        let newFavouriteData = DataModel.FavouriteData(favourites: favourite, date: date)
        
        data.favourites.append(newFavouriteData)
        
        saveDataModelToUserDefaults(data)
        
    }
    
    func saveDataModelToUserDefaults(_ dataModel: DataModel) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(dataModel)
            UserDefaults.standard.set(jsonData, forKey: cardDataKey)
            print("DataModel успешно сохранен в UserDefaults.")
        } catch {
            print("Ошибка при сохранении DataModel в UserDefaults: \(error)")
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        if let firstIndex = offsets.first {
            let deletedCardID = data.favourites[firstIndex].favourites
            deletedFavString = deletedCardID
            data.favourites.remove(atOffsets: offsets)
            saveDataModelToUserDefaults(data)
        }
    }

    
    func getDataModelFromUserDefaults() -> DataModel? {
        if let jsonData = UserDefaults.standard.data(forKey: cardDataKey) {
            let decoder = JSONDecoder()
            do {
                let dataModel = try decoder.decode(DataModel.self, from: jsonData)
                data = dataModel
                print("DataModel была успешно загружена из UserDefaults.")
                return dataModel
            } catch {
                print("Ошибка при декодировании DataModel из UserDefaults: \(error)")
            }
        }
        return nil
    }
}

