//
//  Privacy.swift
//  colorwalpapers
//
//  Created by Sakshi Yelmame on 30/09/24.
//

import SwiftUI
import WebKit

struct Privacy: View {
    @State var text = "privacy"
    var body: some View {
        WebView(text: $text)
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
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

#Preview {
    Privacy()
}
