//
//  PetConsoleWidget+EntryView.swift
//  WidgetsExtension
//
//  Created by Jo Hsu on 2024/2/20.
//

import Foundation
import SwiftUI

extension PetConsoleWidget {

    struct EntryView: View {
        let entry: Entry

        var body: some View {
//            ZStack(content: {
//                Image(entry.petAssetName)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//
//                Image("console_frame")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//
//                HStack(alignment: .center, spacing: 8, content: {
//                    Button(intent: FeedIntent()) {
//                        Image("button_eat")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 56, height: 34)
//                    }
//                    Button(intent: PlayIntent()) {
//                        Image("button_play")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 56, height: 34)
//                    }
//                })
//            })
//            .containerBackground(.green, for: .widget)
            ZStack {
                    Image(entry.petAssetName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the whole widget view
                        .clipped() // Ensure the image does not overflow the bounds

                    Image("console_frame")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the whole widget view
                        .clipped() // Ensure the image does not overflow the bounds

                    VStack {
                        Spacer() // Pushes the HStack to the bottom
                        HStack(alignment: .center, spacing: 8) {
                            Button(intent: FeedIntent()) {
                                Image("button_eat")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 56, height: 34)
                            }
                            .buttonStyle(PlainButtonStyle()) // Apply plain button style to remove default padding and background
                            .padding(0) // Explicitly set padding to 0 if needed

                            Button(intent: PlayIntent()) {
                                Image("button_play")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 56, height: 34)
                            }
                            .buttonStyle(PlainButtonStyle()) // Apply plain button style to remove default padding and background
                            .padding(0) // Explicitly set padding to 0 if needed

                        }
                        .padding(.bottom, 4) // 4pt padding from the bottom of the widget
                    }
                }
                .edgesIgnoringSafeArea(.all) // If you want the content to fill the entire widget view, including the edges
                .containerBackground(.green, for: .widget)
        }
    }
}
