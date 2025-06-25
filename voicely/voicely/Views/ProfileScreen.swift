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
                    MembershipCardView()
                    FAQSection()
                }
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        playHapticFeedback()
                        isPresented = false
                    }) {
                        Image(systemName: "xmark").imageScale(.medium)
                            .foregroundColor(.gray)
                            .padding(.trailing, 6)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        playHapticFeedback()
                        showSettings = true
                    }) {
                        Image("ic_menu")
                            .foregroundColor(.gray)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(isPresented: $showSettings)
            }
        }
    }
}

// MembershipCardView Card
struct MembershipCardView: View {
    @EnvironmentObject var purchaseVM: PurchaseViewModel
    @State private var showPaywall = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                if purchaseVM.isPremium {
                    Text("Premium")
                        .font(.title2).fontWeight(.bold)
                        .foregroundColor(.white)
                } else {
                    HStack {
                        Text("Free")
                            .font(.title2).fontWeight(.bold)
                            .foregroundColor(.white)
                        Image("ic_gift")
                    }
                }
                
                Spacer()
                if purchaseVM.isPremium {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                } else {
                    Button(action: {
                        playHapticFeedback()
                        OnboardingViewModel.shared.trackPaywallShown(source: "profile_button")
                        showPaywall = true
                    }) {
                        Text("Try Free")
                            .font(.headline)
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
                
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground).opacity(0.7))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .padding([.horizontal, .top])
    }
}

// TBD
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
                    playHapticFeedback()
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
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.clear)
                .overlay(
                    Rectangle()
                        .stroke(style: StrokeStyle(lineWidth: 0.5, dash: [4]))
                        .foregroundColor(.white.opacity(0.1))
                )
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


struct FAQSection: View {
    @EnvironmentObject var purchaseVM: PurchaseViewModel
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 8) {
            // Header Button
            Button(action: {
                playHapticFeedback()
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "questionmark.bubble.fill")
                        .imageScale(.small)
                    Text("Frequently Asked Questions")
                        .font(.headline)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .imageScale(.small)
                }
                .foregroundStyle(.white.opacity(0.9))
                .padding()
            }

            // Content
            if isExpanded {
                VStack(alignment: .leading) {
                    Text("What is Voicely?").font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                    Text("Voicely is a text-to-speech app powered by the Minimax-02-HD AI model.")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                    Divider()
                    Text("Use Cases:").font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                    Text("For content creators (i.e. “influencers”):\n🎙️ Generate voices in various formats\n\n👪 For parents:\n📖 Generates random nighttime stories to put their kids to sleep\n\n🌍 For others:\n🎧 Fun and educational voiceovers for presentations, videos, etc.").font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                    Divider()
                    Text("What is the USP?")
                        .foregroundStyle(.white.opacity(0.9))
                        .font(.subheadline)
                    Text("💸 Cheaper than all other text-to-speech services 🤷‍♂️.")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                    if !purchaseVM.isPremium {
                        Divider()
                        Text("🎁 A Special Gift for You!\n✨ Unlock 7 Days of Premium Access — Absolutely FREE! 🚀 Don’t miss it!")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
                .padding([.horizontal, .bottom])
                .foregroundColor(.white)
            }
        }
        .background(Color(.secondarySystemBackground).opacity(0.7))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

#if DEBUG
#Preview {
    ProfileScreen(isPresented: .constant(true)).environmentObject(PurchaseViewModel.shared)
}
#endif

