
import SwiftUI

struct FavView: View {
    
    @StateObject var viewModel = MyViewModel()
    @EnvironmentObject var  dataManager : DataManager
    @State var isFavoritesHere : Bool = false
    @Binding var selectedTab: Int
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone.current
        
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Favourites")
                    .font(.custom("MontserratRoman-Bold", size: 25))
                
                if isFavoritesHere {
                    List{
                        ForEach(dataManager.getSortedFavouritesWithDate(), id: \.0) { favouriteDatePair in
                            VStack{
                                
                                Text(favouriteDatePair.0)
                                    .font(.system(size: 21, weight: .regular, design: .default))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 3)
                                
                                Text("\(dateFormatter.string(from: favouriteDatePair.1))")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 13, weight: .regular, design: .default))
                                    .foregroundStyle(.gray)
                            }
                        }.onDelete(perform: dataManager.deleteItem)
                    }
                    .listStyle(.inset)
                } else{
                    
                    Text("Oops... You don't have any favorites yet.")
                        .padding(.top, 200)
                    
                    Button {
                        selectedTab = 0
                    } label: {
                        Text("Try it now!")
                    }
                }
                
                Spacer()
            }
            .onAppear {
                isFavoritesHere = !dataManager.data.favourites.isEmpty
            }
        }
    }
}

struct FavView_Previews: PreviewProvider {
    static var previews: some View {
        FavView(selectedTab: .constant(0))
    }
}

class MyViewModel: ObservableObject {
    @Published var generatedText: [String]  = []
}
