//
//  Firework.swift

import SwiftUI

struct Firework<Content: View>: View {
    var size: CGFloat
    var disabled: Bool
    var onTap: () -> Void
    var content: Content
    let duration = 0.4

    @State private var isShow = false
    @State private var isFade = false
    
    init (
        size: CGFloat = 100,
        disabled: Bool = false,
        onTap: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.size = size
        self.disabled = disabled
        self.onTap = onTap
        self.content = content()
    }
    

    var body: some View {
        Button(action: {
            withAnimation(.none) {
                isFade = false
                isShow = false
            }
            
            withAnimation(Animation.easeIn(duration: duration)) {
                isShow = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration / 2) {
                withAnimation(Animation.easeIn(duration: duration)) {
                    isFade = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                onTap()
            }
        }) {
            ZStack {
    //            Image("twitter_like")
    //            Image(systemName: "heart") // Heart icon: outline
    //                .frame(width: 26, height: 26)
    //                .foregroundColor(.white)
    //                //.offset(x: 50, y: 340)
                content
                    .zIndex(-1)

    //            Circle()
    //                .strokeBorder(lineWidth: showStrokeBorder ? 1 : 35/2, antialiased: false)
    ////                .opacity(showStrokeBorder ? 0 : 1)
    //                .frame(width: 35, height: 35)
    //                .foregroundColor(.purple)
    //                .scaleEffect(showStrokeBorder ? 1 : 0)
    //                //.offset(x: 50, y: 340)
    //                .animation(Animation.easeInOut(duration: duration))
    //                .onAppear() {
    //                    self.showStrokeBorder.toggle()
    //            }
    //                .zIndex(1)

                Image("splash") // Splash
                    .resizable()
                    .opacity(isFade ? 0 : 1)
                    .frame(width: size, height: size)
                    .scaleEffect(isShow ? 1 : 0)
                    //.offset(x: 50, y: 340)
    //                .scaleEffect(2)
                    .zIndex(1)
                
                Image("splash_tilted") // Splash: tilted
                    .resizable()
                    .opacity(isFade ? 0 : 1)
                    .frame(width: size, height: size)
                    .scaleEffect(isShow ? 1.1 : 0)
                    .scaleEffect(1.1)
    //                .offset(x: 50, y: 340)
    //                .scaleEffect(2)
                    
                        .zIndex(1)
                
    //            Image(systemName: "heart.fill") // Heart icon: filled
    //                .frame(width: 26, height: 26)
    //                .foregroundColor(.pink)
    //                .scaleEffect(showHeart ? 1.1 : 0)
    //                //.offset(x: 50, y: 340)
    //                .animation(Animation.interactiveSpring().delay(0.2))
    //                .onAppear() {
    //                            self.showHeart.toggle()
    //            }
            }
        }
        .disabled(disabled)
    }
}

struct Firework_Previews: PreviewProvider {
    static var previews: some View {
        Firework(onTap: emptyFunc) { Text("gggg") }
    }
}
