import SwiftUI

// Color extension to support hex strings
extension Color {
    init(faqHex: String) {
        let hex = faqHex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let red, green, blue: Double
        switch hex.count {
        case 6: // #RRGGBB
            red = Double((int >> 16) & 0xFF) / 255.0
            green = Double((int >> 8) & 0xFF) / 255.0
            blue = Double(int & 0xFF) / 255.0
        default:
            red = 1.0
            green = 1.0
            blue = 1.0
        }
        self.init(red: red, green: green, blue: blue)
    }
}

struct FaqListView: View {
    @ObservedObject var viewModel = FaqViewModel()

    var body: some View {
        ZStack {
            // Background gradient with Color(faqHex:)
            LinearGradient(gradient: Gradient(colors: [Color(faqHex: "#003366").opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Title with Color(faqHex:)
                Text("Preguntas Frecuentes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(faqHex: "#003366"))  // Title color
                    .padding(.top, 30)

                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.faqs, id: \.id) { faq in
                            VStack(alignment: .leading, spacing: 10) {
                                // FAQ Question with Color(faqHex:)
                                Text(faq.question)
                                    .font(.headline)
                                    .foregroundColor(Color(faqHex: "#003366"))  // Question color

                                // FAQ Answer with default gray color
                                Text(faq.answer)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .italic()
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(faqHex: "#003366").opacity(0.4), lineWidth: 1)  // Stroke color
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 16)
                }
                .onAppear {
                    viewModel.fetchFAQs()
                }
            }
        }
    }
}
