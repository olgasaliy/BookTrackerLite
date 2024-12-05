//
//  CustomSegmentedControl.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 04.12.2024.
//

import SwiftUI

struct CustomSegmentedControl: View {
    var items: [String]
    @Binding var selectedSegmentIndex: Int
    @Namespace private var segmentedControl
    
    // Local @State to ensure proper SwiftUI rendering
    @State private var localSelectedIndex: Int
    
    init(items: [String], selectedSegmentIndex: Binding<Int>) {
        self.items = items
        self._selectedSegmentIndex = selectedSegmentIndex
        // Initialize the local state with the current binding value
        self._localSelectedIndex = State(initialValue: selectedSegmentIndex.wrappedValue)
    }
    
    var body: some View {
        HStack {
            ForEach(items.indices, id: \.self) { index in
                Button {
                    withAnimation {
                        localSelectedIndex = index
                        selectedSegmentIndex = index
                    }
                } label: {
                    Text(items[index])
                        .padding(10)
                        .foregroundStyle(localSelectedIndex == index ? Color.black : .white)
                }
                .matchedGeometryEffect(id: "tab-\(index)",
                                       in: segmentedControl)
            }
        }
        .background(
            Capsule()
                .fill(.background.tertiary)
                .matchedGeometryEffect(id: "tab-\(localSelectedIndex)",
                                       in: segmentedControl,
                                       isSource: false)
        )
        .padding(5)
        
        .background(.indigo)
        .clipShape(.capsule)
        .buttonStyle(.plain)
    }
}

struct CustomSegmentedControlPreview: View {
    @State private var selectedSegmentIndex = 0

    var body: some View {
        CustomSegmentedControl(
            items: ["Option 1", "Option 2", "Option 3"],
            selectedSegmentIndex: $selectedSegmentIndex
        )
        .padding()
    }
}

#Preview {
    CustomSegmentedControlPreview()
}
