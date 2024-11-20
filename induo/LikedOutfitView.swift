import SwiftUI

struct LikedOutfitView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Title button with purple background
                Button(action: {
                    print("Liked Outfit button tapped")
                }) {
                    Text("Liked Outfit")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#6b35e8"))
                        .cornerRadius(15)
                }
                .padding(.bottom, 20)
                
                // Main image with heart icon overlay
                ZStack(alignment: .bottomTrailing) {
                    Image("outfit3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .cornerRadius(15)
                    
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 30, height: 30)
                        .padding(10)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .padding(5)
                }
                .padding()
                
                // Header for clothing items
                Text("From your closet:")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                // List of clothing items
                HStack(spacing: 20) {
                    Image("clothes4")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                    
                    Image("clothes2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer() // Push content to the top for better spacing
            }
            .padding()
        }
    }
}

struct LikedOutfitView_Previews: PreviewProvider {
    static var previews: some View {
        LikedOutfitView()
    }
}
