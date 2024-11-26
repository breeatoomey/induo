import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: InduoAuth
    @Binding var requestLogin: Bool
    
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
                        .foregroundColor(.purple)
                        .padding(.top, 60)

                    // App name
                    Text("Induo")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)

                    // Subtitle or tagline
                    Text("Discover your perfect style with the power of AI!")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if auth.user != nil {
                        Button("Sign Out") {
                            do {
                                try auth.signOut()
                            } catch {
                                // error handling here
                            }
                        }
                        // Navigation button to go to the swiping page
                        NavigationLink(destination: ContentView()) {
                            Text("Shop Your Closet")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple)
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
                                .background(Color.blue)
                                .cornerRadius(12)
                                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                                .padding(.horizontal, 40)
                        }
                        .padding(.bottom, 40)
                    } else {
                        Button("Sign In") {
                            requestLogin = true
                        }
                    }
                    
                }
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var requestLogin = false
    
    static var previews: some View {
        HomeView(requestLogin: $requestLogin)
            .environmentObject(InduoAuth())
    }
}
