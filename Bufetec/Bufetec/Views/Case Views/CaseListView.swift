import SwiftUI

struct CaseListView: View {
    @StateObject var viewModel = CaseViewModel()
    @State private var isVisible: [Bool] = [] // Array to track visibility of each element

    var body: some View {
        ZStack {
            // Full-screen background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea() // Extend the gradient across the entire view

            VStack(alignment: .leading) {
                // Custom Title
                Text("Mis Casos")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#003366"))
                    .padding(.top, 20)
                    .padding(.leading, 16)

                // Custom List background
                List {
                    ForEach(viewModel.cases.indices, id: \.self) { index in
                        let legalCase = viewModel.cases[index]
                        NavigationLink(destination: CaseDetailView(legalCase: legalCase)) {
                            CaseRowView(legalCase: legalCase)
                                .opacity(isVisible.indices.contains(index) && isVisible[index] ? 1 : 0)
                                .offset(y: isVisible.indices.contains(index) && isVisible[index] ? 0 : 20)
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
                }
                .background(Color.clear) // Ensure List has clear background to reveal gradient
                .scrollContentBackground(.hidden) // Hide default background of the List
                .onAppear {
                    viewModel.fetchCases()
                    isVisible = Array(repeating: false, count: viewModel.cases.count)
                }
                .onChange(of: viewModel.cases) { newCases in
                    isVisible = Array(repeating: false, count: newCases.count)
                }
            }
        }
    }
}

#Preview {
    CaseListView()
}
