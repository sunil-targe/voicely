//
//  TooltipView.swift
//
//
//  Created by Sunil Targe on 23.08.2024.
//

import SwiftUI

public extension Tooltip {
    struct ViewConfig {
        public let verticalAlignment: VerticalAlignment
        public let horizontalAlignment: HorizontalAlignment
        public let width: Double?
        public let cornerRadius: Double
        public let arrowSize: CGSize
        public let timeout: DispatchTimeInterval?
        
        public init(
            verticalAlignment: VerticalAlignment,
            horizontalAlignment: HorizontalAlignment = .center,
            width: Double? = nil,
            cornerRadius: Double = 10,
            arrowSize: CGSize = .init(width: 13, height: 8),
            timeout: DispatchTimeInterval? = nil
        ) {
            self.verticalAlignment = verticalAlignment
            self.horizontalAlignment = horizontalAlignment
            self.width = width
            self.cornerRadius = cornerRadius
            self.arrowSize = arrowSize
            self.timeout = timeout
        }
    }
}

struct TooltipViewModifier<ContentView: View>: ViewModifier {
    
    let tooltipView: ContentView
    @ObservedObject var viewModel: Tooltip.ViewModel
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear.onAppear {
                        viewModel.contentViewSize = geometry.size
                    }
                }
            )
            .overlay(
                TooltipContentView(
                    content: tooltipView,
                    verticalAlignment: viewModel.config.verticalAlignment.inverted(),
                    horizontalAlignment: viewModel.config.horizontalAlignment,
                    background: .white,
                    arrowSize: viewModel.config.arrowSize,
                    cornerRadius: viewModel.config.cornerRadius
                )
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            viewModel.tooltipViewSize = geometry.size
                        }
                    }
                )
                .offset(
                    x: viewModel.xOffset,
                    y: viewModel.yOffset
                )
                .fixedSize(horizontal: viewModel.config.width == nil, vertical: true)
                .conditionIfLet(viewModel.config.width) {
                    $0.frame(width: $1)
                }
                .onTapGesture(perform: viewModel.onTap)
            )
            .onAppear { [weak viewModel] in
                guard let timeout = viewModel?.config.timeout else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak viewModel] in
                    viewModel?.onTap()
                }
            }
    }
}

extension View {
    
    public func tooltip<T: View>(
        _ tooltipView: T,
        config: Tooltip.ViewConfig,
        onTap: @escaping () -> Void
    ) -> some View {
        
        ModifiedContent(
            content: self,
            modifier: TooltipViewModifier(
                tooltipView: tooltipView,
                viewModel: .init(config: config, onTap: onTap)
            )
        )
    }
}

struct TooltipView_Previews: PreviewProvider {
    
    @ViewBuilder
    static var regularTooltip: some View {
        Text("Long tooltip message is here")
            .foregroundColor(.black)
    }
    
    static var previews: some View {
        VStack(spacing: 64) {
            
            HStack(spacing: 80) {
                Text("OIO")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .tooltip(
                        Text("top leading")
                            .background(Color.white)
                            .foregroundColor(.black),
                        config: .init(
                            verticalAlignment: .top,
                            horizontalAlignment: .trailing
                        ),
                        onTap: {}
                    )
                
                Text("OIO")
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .tooltip(
                        Text("O")
                            .background(Color.white)
                            .foregroundColor(.black),
                        config: .init(
                            verticalAlignment: .top,
                            horizontalAlignment: .leading
                        ),
                        onTap: {}
                    )
            }
            
            HStack(spacing: 80) {
                Text("OIO")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .tooltip(
                        Text("top leading")
                            .background(Color.white)
                            .foregroundColor(.black),
                        config: .init(
                            verticalAlignment: .bottom,
                            horizontalAlignment: .leading
                        ),
                        onTap: {}
                    )
                
                Text("OIO")
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .tooltip(
                        Text("O")
                            .background(Color.white)
                            .foregroundColor(.black),
                        config: .init(
                            verticalAlignment: .bottom,
                            horizontalAlignment: .leading
                        ),
                        onTap: {}
                    )
            }
            
            HStack {
                Text("Freh Faces")
                
                Spacer()
                
                Text("Sample text (leading)")
                    .tooltip(
                        regularTooltip,
                        config: .init(
                            verticalAlignment: .bottom,
                            horizontalAlignment: .trailing,
                            width: 90
                        ),
                        onTap: {}
                    )
            }
            Text("Top bottom tooltip")
                .tooltip(
                    regularTooltip,
                    config: .init(
                        verticalAlignment: .bottom,
                        horizontalAlignment: .center
                    ),
                    onTap: {}
                )
            Text("Top bottom tooltip")
                .tooltip(
                    regularTooltip,
                    config: .init(
                        verticalAlignment: .bottom,
                        horizontalAlignment: .leading
                    ),
                    onTap: {}
                )
            
            Text("")
            
            Text("Top leading tooltip")
                .tooltip(
                    regularTooltip,
                    config: .init(
                        verticalAlignment: .top,
                        horizontalAlignment: .leading
                    ),
                    onTap: {}
                )
            
            Text("Top center tooltip")
                .tooltip(
                    regularTooltip,
                    config: .init(
                        verticalAlignment: .top,
                        horizontalAlignment: .center
                    ),
                    onTap: {}
                )
            Text("Top trailing tooltip")
                .tooltip(
                    regularTooltip,
                    config: .init(
                        verticalAlignment: .top,
                        horizontalAlignment: .trailing
                    ),
                    onTap: {}
                )
        }
    }
}
