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
            ZStack(content: {
                Image(entry.petAssetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)

                Image("console_frame")
                    .resizable()
                    .aspectRatio(contentMode: .fill)

                HStack(alignment: .center, spacing: 8, content: {
                    Button(intent: FeedIntent()) {
                        Image("button_eat")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 56, height: 34)
                    }
                    Button(intent: PlayIntent()) {
                        Image("button_play")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 56, height: 34)
                    }
                })
            })
            .containerBackground(.green, for: .widget)
        }
    }
}
