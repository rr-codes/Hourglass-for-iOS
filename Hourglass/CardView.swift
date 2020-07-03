//
//  CardView.swift
//  Hourglass
//
//  Created by Richard Robinson on 2020-07-03.
//

import SwiftUI

struct CardView: View {
    let event: Event
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy"
        return df
    }()
    
    var countdownString: String {
        let (d, h, m, s) = event.timeRemaining
        return zip(
            [d, h, m, s],
            [d == 1 ? "1 day, " : "%d days, ", "%02d:", "%02d:", "%02d"]
        ).map { t, format in
            t != 0 ? String(format: format, t) : ""
        }.joined()
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(event.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)

                    Text(dateFormatter.string(from: event.end))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white.opacity(0.75))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                RingView(
                    .init(
                        progress: 0.73,
                        diameter: 40,
                        colors: (start: .white, end: Color.white)
                    )
                )
            }

            Spacer()

            Text(countdownString)
                .font(
                    Font.system(.title, design: .rounded)
                        .monospacedDigit()
                )
                .bold()
                .foregroundColor(.white)
        }
        .padding(.vertical, 33)
        .padding(.horizontal, 19.0)
        .background(
            LinearGradient(
                gradient: event.gradient,
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
        .frame(height: 165)
        .cornerRadius(16)
        .shadow(
            color: event.gradient
                .stops[1]
                .color
                .opacity(0.3),
            radius: 5, x: 0, y: 6
        )
    }
}

extension UIColor {
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

struct SmallCardView: View {
    @State var event: Event
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy"
        return df
    }()
    
    var countdownString: String {
        let (d, h, m, s) = event.timeRemaining
        return d > 1 ? "\(d) days" : "\(h):\(m):\(s)"
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(event.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)

                    Text(dateFormatter.string(from: event.end))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white.opacity(0.75))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Spacer()

            Text(countdownString)
                .font(
                    Font.system(.title, design: .rounded)
                        .monospacedDigit()
                )
                .bold()
                .foregroundColor(.white)
            
            ProgressView(value: 1 - event.progress)
                .accentColor(
                    .white
                )
                //.blendMode(.overlay)
                .blendMode(.plusLighter)
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 19.0)
        .background(
            LinearGradient(
                gradient: event.gradient,
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
        .frame(height: 140)
        .cornerRadius(16)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        SmallCardView(event: Event(
            name: "My Birthday",
            start: .init(),
            end: .init(timeIntervalSinceNow: 1086400),
            gradientIndex: 0
        )).padding(.horizontal, 16).frame(width: 250)
    }
}