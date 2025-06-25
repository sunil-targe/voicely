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
                        SettingsRow(icon: "square.and.arrow.up.fill", label: "Invite Friends", setting: .inviteFriends)
                    }
                    .listRowBackground(Color(.secondarySystemBackground))
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
                    .listRowBackground(Color(.secondarySystemBackground))
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
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
            }
        }
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
            .padding(.vertical, 8)
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
            switch setting {
            case .contactUs:
                if MFMailComposeViewController.canSendMail() {
                    self.isShowingMailView.toggle()
                } else {
                    print("Can't send emails from this device")
                }
            case .inviteFriends:
                self.showShareSheet.toggle()
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
            .padding(.vertical, 8)
        }
        .sheet(isPresented: $isShowingMailView, content: {
            MailView(isShowing: self.$isShowingMailView, result: self.$result)
        })
        .sheet(isPresented: $showShareSheet, content: {
            ShareSheet(activityItems: ["Check out Voicely app! 👇\nhttps://apps.apple.com/app/id6746755399"])
                .presentationDetents([.medium, .large])
        })
    }
}

#if DEBUG
#Preview {
    SettingsView(isPresented: .constant(true))
}
#endif
