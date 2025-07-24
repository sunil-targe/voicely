//
//  SettingsView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/6/29.
//

import SwiftUI
import MessageUI

enum Settings {
    case contactUs
    case inviteFriends
    case rateUs
}

struct SettingsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Settings List
                List {
                    Section {
                        SettingsRow(icon: "paperplane.fill", label: "Contact Us", setting: .contactUs)
                        SettingsRow(icon: "square.and.arrow.up.fill", label: "Sharing is Caring 💖", setting: .inviteFriends)
                    } footer: {
                        Text("📢 Share Voicely in your group chats — you never know who might love it! 🎧✨ It could be just what someone needs 🚀")
                    }
                    
                    Section {
                        PrivacyAndTermsView(icon: "apps.iphone", label: "What is Voicely?", linkString: "appDescription")
                        SettingsRow(icon: "star.fill", label: "Rate Voicely ⭐️", setting: .rateUs)
                    }
                    
                    Section {
                        PrivacyAndTermsView(icon: "lock.doc.fill", label: "Terms of Use", linkString: "terms")
                        PrivacyAndTermsView(icon: "doc.badge.gearshape.fill", label: "Privacy Policy", linkString: "privacy")
                    } footer: {
                        HStack {
                            Spacer()
                            Text("Version \(appVersion)")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        playHapticFeedback()
                        isPresented = false
                    }) {
                        Image(systemName: "xmark").imageScale(.medium)
                            .foregroundColor(.white)
                            .padding(.trailing, 6)
                    }
                }
            }
        }
        .tint(.indigo)
    }
}

struct PrivacyAndTermsView: View {
    let icon: String
    let label: String
    let linkString: String

    var body: some View {
        NavigationLink {
            Privacy(text: linkString)
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .imageScale(.medium)
                    .foregroundColor(.white.opacity(0.8))
                    .background(Color(.systemGray5).opacity(0.15))
                Text(label)
                    .foregroundColor(.white.opacity(0.8))
                    .fontWeight(.semibold)
                Spacer()
            }
        }
    }
}

struct SettingsRow: View {
    @State var isShowingMailView = false
    @State private var showShareSheet = false
    @State var result: Result<MFMailComposeResult, Error>? = nil

    let icon: String
    let label: String
    let setting: Settings
    
    var body: some View {
        Button {
            playHapticFeedback()
            switch setting {
            case .contactUs:
                if MFMailComposeViewController.canSendMail() {
                    self.isShowingMailView.toggle()
                } else {
                    print("Can't send emails from this device")
                }
            case .inviteFriends:
                self.showShareSheet.toggle()
            case .rateUs:
                let url = URL(string: "itms-apps://itunes.apple.com/app/id6747742724?action=write-review")!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            @unknown default:
                break
            }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .imageScale(.medium)
                    .foregroundColor(.white.opacity(0.8))
                    .background(Color(.systemGray5).opacity(0.15))
                Text(label)
                    .foregroundColor(.white.opacity(0.8))
                    .fontWeight(.semibold)
                Spacer()
            }
        }
        .sheet(isPresented: $isShowingMailView, content: {
            MailView(isShowing: self.$isShowingMailView, result: self.$result)
        })
        .sheet(isPresented: $showShareSheet, content: {
            ShareSheet(activityItems: ["Check out Voicely app! 👇\nhttps://apps.apple.com/app/id6747742724"])
                .presentationDetents([.medium, .large])
        })
    }
}

#if DEBUG
#Preview {
    SettingsView(isPresented: .constant(true))
}
#endif
