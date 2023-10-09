
import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var  dataManager : DataManager
    @State var isHistoryHere : Bool = false
    @Binding var selectedTab: Int
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone.current
        
        return formatter
    }()
    
    var body: some View {
        VStack{
            
            Text("History")
                .font(.custom("MontserratRoman-Bold", size: 25))
            
            if isHistoryHere {
                
                List{
                    ForEach(dataManager.data.history, id: \.self) { favouriteDatePair in
                        VStack {
                            Text(favouriteDatePair.histories.trimmingCharacters(in: .whitespacesAndNewlines))
                                .font(.system(size: 21, weight: .regular, design: .default))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 3)
                            
                            Text("\(dateFormatter.string(from: favouriteDatePair.date))")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 13, weight: .regular, design: .default))
                                .foregroundStyle(.gray)
                        }
                    }      .onDelete(perform: dataManager.deleteItem)
                }
                .listStyle(.inset)
            } else{
                
                Text("Oops... You don't have any history yet.")
                    .padding(.top, 200)
                
                Button {
                    selectedTab = 0
                } label: {
                    Text("Try it now!")
                }
            }
            Spacer()
        }.onAppear{
            isHistoryHere = !dataManager.data.history.isEmpty
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        HistoryView( selectedTab: .constant(0))
    }
}
