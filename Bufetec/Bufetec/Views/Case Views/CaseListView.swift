import SwiftUI

struct CaseListView: View {
    @StateObject var viewModel = CaseViewModel()
    @State private var isVisible: [Bool] = [] // Array to track visibility of each element
    
    var body: some View {
        VStack(alignment: .leading) {
            // Custom Title
            Text("Contactar")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#003366"))
                .padding(.top, 20)
                .padding(.leading, 16) // Add some padding to align with the list
            
            ZStack {
                List(viewModel.cases.indices, id: \.self) { index in
                    let legalCase = viewModel.cases[index]
                    NavigationLink(destination: CaseDetailView(legalCase: legalCase)) {
                        CaseRowView(legalCase: legalCase)
                            .opacity(isVisible.indices.contains(index) && isVisible[index] ? 1 : 0) // Control visibility
                            .offset(y: isVisible.indices.contains(index) && isVisible[index] ? 0 : 20) // Offset animation
                            .animation(.easeOut(duration: 1.5).delay(Double(index) * 0.3), value: isVisible)
                            .onAppear {
                                if index < isVisible.count {
                                    withAnimation {
                                        isVisible[index] = true
                                    }
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .onAppear {
                    viewModel.fetchCases()
                }
                .onChange(of: viewModel.cases) { newCases in
                    // Update isVisible array only when cases are updated
                    isVisible = Array(repeating: false, count: newCases.count)
                }
            }
        }
    }
}
