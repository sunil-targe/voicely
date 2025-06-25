import SwiftUI

enum FilterOptionType: Identifiable {
    case emotion, language, channel
    var id: Int { hashValue }
    var header: String {
        switch self {
        case .emotion: return "Speech emotion"
        case .language: return "Enhance recognition of specific languages and dialects"
        case .channel: return "Number of audio channels"
        }
    }
}

struct FilterScreen: View {
    @Binding var isPresented: Bool
    @Binding var selectedVoice: Voice
    private let emotions = ["auto", "neutral", "happy", "sad", "angry", "fearful", "disgusted", "surprised"]
    private let languages = [
        "None", "Automatic", "Chinese", "Chinese,Yue", "English", "Hindi", "Arabic", "Russian", "Spanish", "French", "Portuguese", "German", "Turkish", "Dutch", "Ukrainian", "Vietnamese", "Indonesian", "Japanese", "Italian", "Korean", "Thai", "Polish", "Romanian", "Greek", "Czech", "Finnish"
    ]
    private let channels = ["mono", "stereo"]
    @State private var activePicker: FilterOptionType? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Emotion section
                    FilterRow(title: "Emotion", value: selectedVoice.emotion.capitalized, onTap: { activePicker = .emotion })
                    Divider()
                    // Language section
                    FilterRow(title: "Language Boost", value: selectedVoice.language, onTap: { activePicker = .language })
                    Divider()
                    // Channel section
                    FilterRow(title: "Channel", value: selectedVoice.channel, onTap: { activePicker = .channel })
                }
                .padding(.horizontal)
            }
            .navigationTitle("Filters")
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
            }
            .sheet(item: $activePicker) { pickerType in
                switch pickerType {
                case .emotion:
                    OptionPickerSheet(
                        title: "Emotion", headerText: FilterOptionType.emotion.header,
                        options: emotions,
                        selected: selectedVoice.emotion,
                        onSelect: { selected in
                            selectedVoice.emotion = selected
                            activePicker = nil
                        }
                    )
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                case .language:
                    OptionPickerSheet(
                        title: "Language Boost",
                        headerText: FilterOptionType.language.header,
                        options: languages,
                        selected: selectedVoice.language,
                        onSelect: { selected in
                            selectedVoice.language = selected
                            activePicker = nil
                        }
                    )
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                case .channel:
                    OptionPickerSheet(
                        title: "Channel",
                        headerText: FilterOptionType.channel.header,
                        options: channels,
                        selected: selectedVoice.channel,
                        onSelect: { selected in
                            selectedVoice.channel = selected
                            activePicker = nil
                        }
                    )
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                }
            }
        }
    }
}

struct FilterRow: View {
    let title: String
    let value: String
    let onTap: () -> Void
    var body: some View {
        Button(action: {
            playHapticFeedback()
            onTap()
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.headline)
                    Text(value.capitalized)
                        .foregroundColor(Color(.systemGray2))
                        .font(.subheadline)
                        .font(.subheadline)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(.systemGray2))
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
    }
}

struct OptionPickerSheet: View {
    let title: String
    let headerText: String
    let options: [String]
    let selected: String
    let onSelect: (String) -> Void
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                Text(headerText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                List {
                    ForEach(options, id: \.self) { option in
                        Button(action: { 
                            playHapticFeedback()
                            onSelect(option) 
                        }) {
                            HStack {
                                Text(option.capitalized)
                                    .foregroundColor(.white)
                                Spacer()
                                if selected == option {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { 
                        playHapticFeedback()
                        onSelect(selected) 
                    }
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    FilterScreen(
        isPresented: .constant(true),
        selectedVoice: .constant(Voice.default)
    )
}
#endif 
