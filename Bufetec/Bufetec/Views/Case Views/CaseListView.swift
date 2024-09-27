import SwiftUI

struct CaseListView: View {
    @StateObject var viewModel = CaseViewModel()
    @State private var isVisible: [Bool] = [] // Array para rastrear la visibilidad de cada elemento
    
    var body: some View {
        NavigationView {
            List(viewModel.cases.indices, id: \.self) { index in
                let legalCase = viewModel.cases[index]
                NavigationLink(destination: CaseDetailView(legalCase: legalCase)) {
                    CaseRowView(legalCase: legalCase)
                        .opacity(isVisible.indices.contains(index) && isVisible[index] ? 1 : 0) // Controlar visibilidad
                        .offset(y: isVisible.indices.contains(index) && isVisible[index] ? 0 : 20) // Animación de desplazamiento
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
                // Actualiza el array isVisible solo cuando los casos se actualizan
                isVisible = Array(repeating: false, count: newCases.count)
            }
            .navigationTitle("Mis Casos")
        }
    }
}
