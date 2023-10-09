
import SwiftUI

struct AlertView: View {
    
    @State var optionManager : OptionManager
    
    var body: some View {
        VStack{
            
            Text(optionManager.alertTitle)
                .foregroundColor(.blue)
                .padding()
        
        }
        .background(
            Color.white
                .aspectRatio(contentMode: .fill)
                .blur(radius: 55)
                .frame(width: 300, height: 45)) .cornerRadius(25)
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(optionManager: OptionManager())
    }
}
