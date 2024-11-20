import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // Icon at the top
                    Image(systemName: "tshirt.fill") // Example icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color(hex: "#6b35e8"))
                        .padding(.top, 60)

                    // App name
                    Text("Induo")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)

                    // Subtitle or tagline
                    Text("Discover your perfect style with the power of AI!")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Navigation button to go to the swiping page
                    NavigationLink(destination: ContentView()) {
                        Text("Shop Your Closet")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#3f13a4").opacity(0.7))
                            .cornerRadius(12)
                            .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 40)
                    }
                    // "Make Profile" button to go to ProfileSetupView
                    NavigationLink(destination: ProfileSetupView()) {
                        Text("Make Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#6b35e8").opacity(0.7))
                            .cornerRadius(12)
                            .shadow(color: Color(hex: "#6b35e8").opacity(0.3), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 40)
                                        }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
