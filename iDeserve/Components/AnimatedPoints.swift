//
//  AnimatedPoints.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/8.
//

import SwiftUI

struct AnimatedPoints: View {
    var points: Int
    @State var realPoints: Int
    @State var animationTrigger = false
    
    init (points: Int) {
        _realPoints = State(initialValue: points)
        self.points = points
    }

    var body: some View {
        return Text(String(realPoints))
            .font(.titleCustom)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .colorMultiply(animationTrigger ? .yellow : .rewardGold)
            .scaleEffect(animationTrigger ? 1.1 : 1)
            .onChange(of: points, perform: { value in
                let animationDuraing = 0.5
                let delta = value - points
                let timePerFrame = animationDuraing / Double(abs(delta))
    
                for i in 0..<abs(delta)  {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timePerFrame * Double(i)) {
                        if (delta > 0) {
                            realPoints += 1
                        } else {
                            realPoints -= 1
                        }
                    }
                }
                
                let shiningDuring = 0.2
                let animation = Animation
                    .easeIn(duration: shiningDuring)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuraing) {
                    withAnimation(animation, {
                        animationTrigger.toggle()
                    })
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuraing + shiningDuring) {
                    withAnimation(animation, {
                        animationTrigger.toggle()
                    })
                }
            })
    }
}

struct AnimatedPoints_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedPoints(points: 333)
    }
}
