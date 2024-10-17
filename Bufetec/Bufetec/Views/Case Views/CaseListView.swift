import SwiftUI

struct CaseListView: View {
    @StateObject var viewModel = CaseViewModel()
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
            ForEach(viewModel.cases, id: \.id) { legalCase in
                NavigationLink(destination: CaseDetailView(legalCase: legalCase, isAbogado: viewModel.isAbogado)) {
                    CaseRowView(legalCase: legalCase)
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
}
