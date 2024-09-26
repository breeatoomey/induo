import SwiftUI

struct ContentView: View {
    // Sample data for images (temporary; replace with database items in the future)
    @State private var clothingImages = ["outfit1", "outfit2", "outfit3", "outfit4"]
    @State private var currentIndex = 0 // Track the current card index
    @State private var dragOffset = CGSize.zero // Track drag offset
    @State private var likeAnimation = false // Animation toggle for like
    @State private var dislikeAnimation = false // Animation toggle for dislike
    
    var body: some View {
        ZStack {
            Color.purple.ignoresSafeArea() // Set background color
            
            VStack {
                // "My Closet" button at the top
                NavigationLink(destination: ClosetView()) {
                    Text("My Closet")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
                
                Spacer()
                
                // Swipeable card stack for the clothing images
                ZStack {
                    ForEach(Array(clothingImages.enumerated().reversed()), id: \.element) { index, imageName in
                        if index == currentIndex {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: UIScreen.main.bounds.height * 0.6)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding()
                                .offset(x: dragOffset.width, y: 0)
                                .rotationEffect(.degrees(Double(dragOffset.width / 10)))
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            dragOffset = gesture.translation
                                        }
                                        .onEnded { gesture in
                                            if gesture.translation.width > 150 {
                                                swipeCardRight()
                                            } else if gesture.translation.width < -150 {
                                                swipeCardLeft()
                                            } else {
                                                dragOffset = .zero
                                            }
                                        }
                                )
                                .animation(.spring(), value: dragOffset)
                        }
                    }
                    
                    // Like animation on the right
                    if likeAnimation {
                        Text("❤️")
                            .font(.system(size: 70))
                            .opacity(0.8)
                            .offset(x: 100, y: -150)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        likeAnimation = false
                                    }
                                }
                            }
                    }
                    
                    // Dislike animation on the left
                    if dislikeAnimation {
                        Text("❌")
                            .font(.system(size: 70))
                            .opacity(0.8)
                            .offset(x: -100, y: -150)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        dislikeAnimation = false
                                    }
                                }
                            }
                    }
                }
                
                Spacer()
                
                // MATCH button
                Button(action: {
                    print("MATCH button tapped")
                }) {
                    Text("MATCH")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
            }
        }
    }
    
    // Swipe the card to the right (like)
    private func swipeCardRight() {
        withAnimation {
            dragOffset = CGSize(width: 1000, height: 0)
            likeAnimation = true // Trigger like animation
            dislikeAnimation = false // Ensure dislike animation is off
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            nextCard()
        }
    }
    
    // Swipe the card to the left (dislike)
    private func swipeCardLeft() {
        withAnimation {
            dragOffset = CGSize(width: -1000, height: 0)
            dislikeAnimation = true // Trigger dislike animation
            likeAnimation = false // Ensure like animation is off
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            nextCard()
        }
    }
    
    // Show the next card
    private func nextCard() {
        currentIndex += 1
        dragOffset = .zero
        if currentIndex >= clothingImages.count {
            currentIndex = 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
