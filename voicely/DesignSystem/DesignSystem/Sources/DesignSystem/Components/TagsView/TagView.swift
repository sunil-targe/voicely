//
//  TagView.swift
//  
//
//  Created by Sunil Targe on 08.07.2024.
//

import SwiftUI

public struct TagView: View {

    public var body: some View {
        HStack(spacing: 0) {
            imageView?
                .resizable()
                .frame(width: 12, height: 12)
                .applyReusableForeground(style.borderColor)
                .padding(.leading, 8)
            Text(text)
                .font(fontProvider.font(size: 12, weight: .semibold))
                .applyReusableForeground(style.textColor)
                .padding(.leading, imageView == nil ? 8 : 3)
                .padding(.trailing, 8)
                .padding(.vertical, 2)
        }
        .frame(height: 24)
        .applyReusableBackground(style.backgroundColor)
        .clipShape(
            RoundedRectangle(cornerRadius: style.cornerRadius)
        )
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .strokeBorder(
                    .linearGradient(colors: style.borderColor.colors, startPoint: .leading, endPoint: .trailing),
                    lineWidth: style.borderWidth
                )
        )
        .onTapGesture {
            onTap?()
        }
        .rotationEffect(.degrees(-1))
    }
    
    public init(
        fontProvider: FontProvider,
        imageView: Image?,
        style: Style,
        text: String,
        onTap: (() -> Void)?
    ) {
        self.fontProvider = fontProvider
        self.imageView = imageView
        self.style = style
        self.text = text
        self.onTap = onTap
    }
    
    // MARK: - Private
    
    private let fontProvider: FontProvider
    private let imageView: Image?
    private let style: Style
    private let text: String
    private let onTap: (() -> Void)?
}

#Preview {
    
    VStack {
        VStack {
            Text("Dark background")
                .foregroundColor(.white)
            HStack {
                TagView(
                    fontProvider: .system,
                    imageView: .init(systemName: "paperplane.fill"),
                    style: .highlighted,
                    text: "3some",
                    onTap: nil
                )
                
                TagView(
                    fontProvider: .system,
                    imageView: nil,
                    style: .standard,
                    text: "Just joined!",
                    onTap: nil
                )
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black)
        
        VStack {
            Text("Light background")
            HStack {
                TagView(
                    fontProvider: .system,
                    imageView: .init(systemName: "paperplane.fill"),
                    style: .highlighted,
                    text: "3some",
                    onTap: nil
                )
                
                TagView(
                    fontProvider: .system,
                    imageView: nil,
                    style: .standard,
                    text: "Just joined!",
                    onTap: nil
                )
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
