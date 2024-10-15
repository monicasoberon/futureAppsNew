import SwiftUI

struct CaseListView: View {
    @StateObject var viewModel = CaseViewModel()
    @State private var isVisible: [Bool] = [] // Array para rastrear la visibilidad de cada elemento
    @State private var showCreateCaseView = false // Variable de estado para mostrar la vista de creación de casos

    var body: some View {
        ZStack {
            // Fondo degradado
            gradientBackground()
            
            VStack(alignment: .leading) {
                headerView()
                caseListView()
                createCaseButton() // Muestra el botón si es abogado
            }
        }
        .sheet(isPresented: $showCreateCaseView) {
            CreateCaseView(abogadoId: viewModel.userId)
        }
        .onAppear {
            viewModel.fetchUserId() // Obtener el _id del usuario
            initializeVisibility()  // Inicializar la visibilidad de las animaciones
        }
        .onChange(of: viewModel.cases) { _ in
            initializeVisibility()
        }
    }
    
    // Gradiente de fondo
    private func gradientBackground() -> some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                       startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
    
    // Encabezado de la vista
    private func headerView() -> some View {
        Text("Mis Casos")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(Color(hex: "#003366"))
            .padding(.top, 20)
            .padding(.leading, 16)
    }
    
    // Lista de casos
    private func caseListView() -> some View {
        List {
            ForEach(Array(viewModel.cases.enumerated()), id: \.element.id) { index, legalCase in
                NavigationLink(destination: CaseDetailView(legalCase: legalCase, isAbogado: viewModel.isAbogado)) { // Pasa `isAbogado` al destino
                    CaseRowView(legalCase: legalCase)
                        .opacity(isVisibleForIndex(index))
                        .offset(y: offsetForIndex(index))
                        .animation(animationForIndex(index), value: isVisible.indices.contains(index) ? isVisible[index] : false)
                        .onAppear {
                            setVisible(index: index)
                        }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(Color.clear)
        .scrollContentBackground(.hidden)
    }
    
    // Botón para crear un caso si es abogado
    @ViewBuilder
    private func createCaseButton() -> some View {
        if viewModel.isAbogado {
            Button(action: {
                showCreateCaseView = true
            }) {
                Text("Crear nuevo caso")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
            .transition(.opacity)
        }
    }

    // Funciones auxiliares para la animación y visibilidad
    private func isVisibleForIndex(_ index: Int) -> Double {
        isVisible.indices.contains(index) && isVisible[index] ? 1 : 0
    }

    private func offsetForIndex(_ index: Int) -> CGFloat {
        isVisible.indices.contains(index) && isVisible[index] ? 0 : 10
    }

    private func animationForIndex(_ index: Int) -> Animation {
        .easeOut(duration: 0.6).delay(Double(index) * 0.1)
    }

    private func setVisible(index: Int) {
        if index < isVisible.count {
            withAnimation {
                isVisible[index] = true
            }
        }
    }

    private func initializeVisibility() {
        DispatchQueue.main.async {
            self.isVisible = Array(repeating: false, count: viewModel.cases.count)
        }
    }
}
