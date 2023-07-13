//
//  RiskometerView.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/10/23.
//

import SwiftUI

struct GaugeView: View {
    var rightLabel: String
    var leftLabel: String
    @Binding var value: Double // risk value, range from 0.0 to 1.0
    @Binding var targetRange: ClosedRange<Double>
    let degreesStart:Double
    let degreesEnd:Double
    
    init(rightLabel: String, leftLabel: String, value: Binding<Double>, targetRange: Binding<ClosedRange<Double>>, degreesStart: Double = -15.0, degreesEnd: Double = -165.0) {
        self.rightLabel = rightLabel
        self.leftLabel = leftLabel
        self._value = value
        self._targetRange = targetRange
        self.degreesStart = degreesStart
        self.degreesEnd = degreesEnd
    }

    var body: some View {
        GeometryReader { geometry in
            let gaugeCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height)
            let STROKE = geometry.size.width / 22
            let INSET = geometry.size.width / 18
            ZStack {
                // semicircle gauge
                Path { path in
                    path.addArc(center: gaugeCenter,
                                radius: geometry.size.width / 2 - INSET,
                                startAngle: .degrees(degreesStart),
                                endAngle: .degrees(degreesEnd),
                                clockwise: true)
                }
                .stroke(.black, lineWidth: STROKE)
                
                // Target Range
                Path { path in
                    path.move(to: gaugeCenter)
                    path.addArc(center: gaugeCenter,
                                radius: geometry.size.width / 2 - STROKE/2 - INSET,
                                startAngle: .degrees(-(degreesEnd - degreesStart)*targetRange.lowerBound-180-degreesStart),
                                endAngle: .degrees(-(degreesEnd - degreesStart)*targetRange.upperBound-180-degreesStart),
                                clockwise: false)
                    path.closeSubpath()
                }
                .fill(.black.opacity(0.2))
                
                // Needle
                Path { path in
                    path.move(to: gaugeCenter)
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height - (geometry.size.width / 2 - INSET)+STROKE/2))
                }
                .stroke(Color(red: 0.8, green: 0.0, blue: 0.0), lineWidth: 2)
                .rotationEffect(.degrees(-(degreesEnd - degreesStart) * self.value - 90 - degreesStart), anchor: .bottom)

                // HIGH and LOW labels
                VStack {
                    Spacer()
                    HStack {
                        Text(leftLabel)
                        Spacer()
                        Text(rightLabel)
                    }
                    .font(.system(size: min(geometry.size.width, geometry.size.height)/6))
                }
            }
        }
        .aspectRatio(2/1, contentMode: .fit)
    }
}

struct GaugeView_Previews: PreviewProvider {
    static var previews: some View {
        GaugeView(rightLabel: "HIGH",
                       leftLabel: "LOW",
                       value: .constant(0.66),
                       targetRange: .constant(0.6...0.7))
            .previewLayout(.fixed(width: 600, height: 300))
    }
}
