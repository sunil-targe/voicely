//
//  AnimatedView.swift
//  tts
//
//  Created by Sunil Targe on 2025/8/22.
//

import SwiftUI
import Lottie

// https://lottiefiles.com/free-animation/speach-to-text-zwSUE91Wgn

struct AnimatedView: View {
    
    let name: String
    let loop: Lottie.LottieLoopMode

    var body: some View {
        LottieView {
            LottieAnimation.named(name)
        }
        .imageProvider(
            BundleImageProvider(bundle: .main, searchPath: nil)
        )
        .configuration(.init(renderingEngine: .mainThread))
        .playing(loopMode: loop)
        .clipped()
    }

    init(name: String, loop: Lottie.LottieLoopMode = .loop) {
        self.name = name
        self.loop = loop
    }
}

#Preview {
    AnimatedView(name: "confetti")
        .ignoresSafeArea()
}
