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
                    .containerBackground(.green, for: .widget)

                HStack(alignment: .center, spacing: 8, content: {

                })
            })
        }
    }
}
