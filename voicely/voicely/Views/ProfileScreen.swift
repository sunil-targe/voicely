import SwiftUI
import RevenueCat
import RevenueCatUI

struct ProfileScreen: View {
    @EnvironmentObject var purchaseVM: PurchaseViewModel
    @Binding var isPresented: Bool
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Free Credits Card
                    CreditCardView()
                }
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark").imageScale(.medium)
                            .foregroundColor(.white)
                            .padding(.trailing, 6)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(isPresented: $showSettings)
            }
        }
    }
}

// Free Credits Card
struct CreditCardView: View {
    @EnvironmentObject var purchaseVM: PurchaseViewModel
    @State private var showPaywall = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Free")
                    .font(.title2).fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    showPaywall = true
                }) {
                    Text("Upgrade")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
                .fullScreenCover(isPresented: $showPaywall) {
                    purchaseVM.refreshPurchaseStatus()
                } content: {
                    PaywallView()
                }
            }
            Divider().background(Color.white.opacity(0.1))
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(.white)
                    Text("Credits")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Menu {
                        Text("Get started with this FREE credit 💎")
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }

                    Spacer()
                    Text("10000")
                        .foregroundColor(.white)
                        .font(.title3).fontWeight(.bold)
                }
                Text("Free credits")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding(.leading, 28)
                HStack {
                    Image(systemName: "waveform")
                        .foregroundColor(.white)
                    Text("Used credits")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("0")
                        .foregroundColor(.white)
                        .font(.title3).fontWeight(.bold)
                }
                .padding(.top, 10)
                Text("You have used to generate voice")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding(.leading, 28)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground).opacity(0.7))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

#if DEBUG
#Preview {
    ProfileScreen(isPresented: .constant(true))
}
#endif
