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
            ZStack {
                VStack {
                    Image(entry.petAssetName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 116, height: 116)
                    Spacer()
                }
                .padding(.top, 4)


                Image("console_frame")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the whole widget view
                    .clipped() // Ensure the image does not overflow the bounds

                VStack {
                    Spacer()
                    HStack(alignment: .center, spacing: 5) {
                        let buttonSize = CGSize(width: 44, height: 35)

                        Button(intent: IdleIntent()) {
                            Image("button_idle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: buttonSize.width, height: buttonSize.height)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(0)

                        Button(intent: HeartIntent()) {
                            Image("button_heart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: buttonSize.width, height: buttonSize.height)
                        }
                        .buttonStyle(PlainButtonStyle()) // Apply plain button style to remove default padding and background
                        .padding(0) // Explicitly set padding to 0 if needed

                        Button(intent: SleepIntent()) {
                            Image("button_sleep")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: buttonSize.width, height: buttonSize.height)
                        }
                        .buttonStyle(PlainButtonStyle()) // Apply plain button style to remove default padding and background
                        .padding(0) // Explicitly set padding to 0 if needed

                    }
                    .padding(.bottom, 4) // 4pt padding from the bottom of the widget
                }
            }
            .edgesIgnoringSafeArea(.all) // If you want the content to fill the entire widget view, including the edges
            .containerBackground(Color(uiColor: UIColor(red: 83/255, green: 180/255, blue: 65/255, alpha: 1.0)), for: .widget)
        }
    }
}
