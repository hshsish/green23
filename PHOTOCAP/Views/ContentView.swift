
import SwiftUI

struct ContentView: View {
    
    @State var imageSel: UIImage? = nil
    @State var cards : Card
    @State var selectedTab : Int = 0
    @State var datamodel : DataModel
    @State var textList: [String] = []
    @EnvironmentObject var dataManager : DataManager
    
    var body: some View{
        ZStack{
            
            if dataManager.data.isFirstLaunch == true {
                
                HelloView()
                
            } else {
                
                VStack{
                    UserCapView()
                    Spacer()
                    TabView(selection: $selectedTab){
                        
                        CapView(optionManager: OptionManager(), card: cards, imageSel: $imageSel)
                            .environmentObject(dataManager)
                            .tabItem{
                                Image(systemName: "sparkles")
                                
                            }
                            .tag(0)
                        
                        FavView(selectedTab: $selectedTab)
                        
                            .tabItem {
                                Image(systemName: "heart")
                            }.tag(1)
                        
                        HistoryView(selectedTab: $selectedTab)                     
                            .tabItem {
                                Image(systemName: "clock.arrow.circlepath")
                            }.tag(2)
                    }
                    .onAppear(){
                        UITabBar.appearance().backgroundColor = .white
                    }
                }
            }
        }.navigationBarBackButtonHidden()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cards: Card(id: 0, image: UIImage(), title: ""), datamodel: DataModel(favourites: [], history: [], isFirstLaunch: Bool()))
            .environmentObject(DataManager())
    }
}
