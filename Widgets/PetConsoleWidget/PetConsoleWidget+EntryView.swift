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

        let assetNames: [String] = [
            "frame1", "frame2"
        ]

        var body: some View {
            Image(entry.petAssetName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .containerBackground(.clear, for: .widget)
        }
    }
}
