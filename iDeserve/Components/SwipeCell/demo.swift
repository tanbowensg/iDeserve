//
//  demo.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/17.
//

import SwiftUI

struct SwipeCellDemoView: View {
    
    var slidableContent: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.secondary)
            .frame(height: 60)
            
            VStack(alignment: .leading) {
                Text("Enes Karaosman")
                .fontWeight(.semibold)
            
                Text("eneskaraosman53@gmail.com")
                .foregroundColor(.secondary)
            }
        }.padding()
    }
    
    var slots = [
        // First item
        Slot(
            image: {
                Image(systemName: "envelope.open.fill")
            },
            title: {
                Text("Read")
                .foregroundColor(.white)
                .font(.footnote)
                .fontWeight(.semibold)
                .embedInAnyView()
            },
            action: { print("Read Slot tapped") },
            style: .init(background: .orange)
        ),
        // Second item
        Slot(
            image: {
                Image(systemName: "hand.raised.fill")
            },
            title: {
                Text("Block")
                .foregroundColor(.white)
                .font(.footnote)
                .fontWeight(.semibold)
                .embedInAnyView()
            },
            action: { print("Block Slot Tapped") },
            style: .init(background: .blue, imageColor: .red)
        )
    ]
    
    var left2Right: some View {
        slidableContent
        .frame(height: 60)
        .padding()
        .onSwipe(leading: slots)
    }
    
    var right2Left: some View {
        slidableContent
        .frame(height: 60)
        .padding()
        .onSwipe(trailing: slots)
    }
    
    var leftAndRight: some View {
        slidableContent
        .frame(height: 60)
        .padding()
        .onSwipe(leading: slots, trailing: slots)
    }
    
    var items: [AnyView] {
        [
            left2Right.embedInAnyView(),
            right2Left.embedInAnyView(),
            leftAndRight.embedInAnyView()
        ]
    }
    
    var body: some View {
        NavigationView {
            LazyVStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { idx in
                    self.items[idx]
                }.listRowInsets(EdgeInsets())
            }.navigationBarTitle("Messages")
        }
    }
    
}

struct SwipeCellDemoView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCellDemoView()
    }
}
