import SwiftUI
import CommonCrypto
import WebKit

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif 


let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String


func playHapticFeedback() {
    @AppStorage("hapticFeedback") var hapticFeedback: Bool = true
    guard hapticFeedback else { return }
    let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
    impactHeavy.impactOccurred()
}

struct WebView: UIViewRepresentable {
  @Binding var text: String
   
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
   
  func updateUIView(_ uiView: WKWebView, context: Context) {
      uiView.backgroundColor = .clear
      uiView.isOpaque = false
      
      if let htmlPath = Bundle.main.path(forResource: text, ofType: "html") {
          let url = URL(fileURLWithPath: htmlPath)
          let request = URLRequest(url: url)
          uiView.load(request)
      } else {
          debugPrint("Error: HTML file not found.")
      }
  }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Font Extension

extension Font {
    // MARK: - Nunito Regular
    static func nunitoRegular(size: CGFloat) -> Font {
        .custom("Nunito-Regular", size: size)
    }
    
    static func nunitoItalic(size: CGFloat) -> Font {
        .custom("Nunito-Italic", size: size)
    }
    
    // MARK: - Nunito Light
    static func nunitoLight(size: CGFloat) -> Font {
        .custom("Nunito-Light", size: size)
    }
    
    static func nunitoLightItalic(size: CGFloat) -> Font {
        .custom("Nunito-LightItalic", size: size)
    }
    
    // MARK: - Nunito ExtraLight
    static func nunitoExtraLight(size: CGFloat) -> Font {
        .custom("Nunito-ExtraLight", size: size)
    }
    
    static func nunitoExtraLightItalic(size: CGFloat) -> Font {
        .custom("Nunito-ExtraLightItalic", size: size)
    }
    
    // MARK: - Nunito Bold
    static func nunitoBold(size: CGFloat) -> Font {
        .custom("Nunito-Bold", size: size)
    }
    
    static func nunitoBoldItalic(size: CGFloat) -> Font {
        .custom("Nunito-BoldItalic", size: size)
    }
    
    // MARK: - Nunito SemiBold
    static func nunitoSemiBold(size: CGFloat) -> Font {
        .custom("Nunito-SemiBold", size: size)
    }
    
    static func nunitoSemiBoldItalic(size: CGFloat) -> Font {
        .custom("Nunito-SemiBoldItalic", size: size)
    }
    
    // MARK: - Nunito ExtraBold
    static func nunitoExtraBold(size: CGFloat) -> Font {
        .custom("Nunito-ExtraBold", size: size)
    }
    
    static func nunitoExtraBoldItalic(size: CGFloat) -> Font {
        .custom("Nunito-ExtraBoldItalic", size: size)
    }
    
    // MARK: - Nunito Black
    static func nunitoBlack(size: CGFloat) -> Font {
        .custom("Nunito-Black", size: size)
    }
    
    static func nunitoBlackItalic(size: CGFloat) -> Font {
        .custom("Nunito-BlackItalic", size: size)
    }
}

enum AppSecrets {
    private static func aesDecrypt(base64Encoded input: String, key: String) -> String? {
        guard let data = Data(base64Encoded: input),
              let keyData = Data(base64Encoded: key) else { return nil }

        let bufferSize = data.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        var numBytesDecrypted: size_t = 0

        let cryptStatus = buffer.withUnsafeMutableBytes { bufferBytes in
            data.withUnsafeBytes { dataBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode),
                        keyBytes.baseAddress,
                        kCCKeySizeAES256,
                        nil,
                        dataBytes.baseAddress,
                        data.count,
                        bufferBytes.baseAddress,
                        bufferSize,
                        &numBytesDecrypted
                    )
                }
            }
        }

        if cryptStatus == kCCSuccess {
            let decryptedData = buffer.prefix(numBytesDecrypted)

            // 👇 Clean up null bytes if needed (e.g., from zero-padding encryption)
            let trimmedData = decryptedData.prefix { $0 != 0 }

            return String(data: trimmedData, encoding: .utf8)
        } else {
            print("❌ Decryption failed with status: \(cryptStatus)")
            return nil
        }
    }
    
    private static func loadEncryptedKey() -> String? {
        let aesKey = "5osR3Ugb3r29IKVCma5hvutohQQouFhgrXgmoof0sEc="  // Same key used to encrypt
        return aesDecrypt(base64Encoded: "P4t07173EAds2CfYJmE8mjYIFb0taqr9zGHIFw/NMhATm5EIncaz98HGhgE1BA6u/hQoQmv5QzpPpcF91pyJGA==", key: aesKey)
    }

    static var apiKey: String {
        loadEncryptedKey() ?? ""
    }
}
