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

#Preview {
    Privacy()
}
