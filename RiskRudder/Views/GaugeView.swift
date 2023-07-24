//
//  RiskometerView.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/10/23.
//

import SwiftUI

// Custom gauge view component
struct GaugeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // Labels for the right and left sides of the gauge.
    var rightLabel: String
    var leftLabel: String

    // Binding for the risk value, which ranges from 0.0 to 1.0.
    let value: Double
    
    // Binding for the target risk range.
    var targetRange: ClosedRange<Double>

    // The degrees to start and end the gauge.
    let degreesStart:Double
    let degreesEnd:Double
    
    // Initializer to configure the gauge view.
    init(rightLabel: String,
         leftLabel: String,
         value: Double,
         targetRange: ClosedRange<Double>,
         degreesStart: Double = -20.0,
         degreesEnd: Double = -160.0) {
        self.rightLabel = rightLabel
        self.leftLabel = leftLabel
        self.value = value
        self.targetRange = targetRange
        self.degreesStart = degreesStart
        self.degreesEnd = degreesEnd
    }

    var body: some View {
        GeometryReader { geometry in
            let gaugeCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height)
            let STROKE = geometry.size.width / 70
            let TICK_STROKE = geometry.size.width / 200
            let TICK_LEN = geometry.size.width / 50
            let INSET = geometry.size.width / 18
            ZStack {
                // Semicircle gauge
                Path { path in
                    path.addArc(center: gaugeCenter,
                                radius: geometry.size.width / 2 - INSET,
                                startAngle: .degrees(degreesStart),
                                endAngle: .degrees(degreesEnd),
                                clockwise: true)
                }
                .stroke(colorScheme == .dark ? .white : .black, lineWidth: STROKE)
                
                // The ticks on the gauge
                ForEach(0..<10) { tick in
                    let position: Double = Double(tick) / Double(10 - 1)
                    
                    Path { path in
                        path.move(to: CGPoint(x: geometry.size.width / 2,
                                              y: geometry.size.height - (geometry.size.width / 2 - INSET)+STROKE/2 + TICK_LEN))
                        path.addLine(to: CGPoint(x: geometry.size.width / 2,
                                                 y: geometry.size.height - (geometry.size.width / 2 - INSET)-STROKE/2))
                    }
                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: tick == 0 || tick == 9 ? STROKE : TICK_STROKE)
                    .rotationEffect(.degrees(-(degreesEnd - degreesStart)*position+degreesEnd+90), anchor: .bottom)
                }

                // The target range indicator inside the gauge.
                Path { path in
                    path.move(to: gaugeCenter)
                    path.addArc(center: gaugeCenter,
                                radius: geometry.size.width / 2 - STROKE/2 - INSET,
                                startAngle: .degrees(-(degreesEnd - degreesStart)*targetRange.lowerBound+degreesEnd),
                                endAngle: .degrees(-(degreesEnd - degreesStart)*targetRange.upperBound+degreesEnd),
                                clockwise: false)
                    path.closeSubpath()
                }
                .fill((colorScheme == .dark ? .white.opacity(0.2) : .black.opacity(0.2)))
                
                // The needle pointing to the current value on the gauge.
                Path { path in
                    path.move(to: gaugeCenter)
                    path.addLine(to: CGPoint(x: geometry.size.width / 2,
                                             y: geometry.size.height - (geometry.size.width / 2 - INSET)+STROKE/2))
                }
                .stroke(Color(red: colorScheme == .dark ? 0.8 : 1, green: 0.0, blue: 0.0), lineWidth: 2)
                .rotationEffect(.degrees(-(degreesEnd - degreesStart)*self.value+degreesEnd+90), anchor: .bottom)

                // Labels for high and low values.
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

// Preview for the GaugeView.
struct GaugeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GaugeView(rightLabel: "HIGH",
                      leftLabel: "LOW",
                      value: 1.0,
                      targetRange: 0.0...1.0)
                .previewLayout(.fixed(width: 600, height: 300))

            GaugeView(rightLabel: "$13M",
                      leftLabel: "",
                      value: 1.0,
                      targetRange: 0.0...1.0,
                      degreesEnd: -180)
                .previewLayout(.fixed(width: 600, height: 300))
        }
    }
}
