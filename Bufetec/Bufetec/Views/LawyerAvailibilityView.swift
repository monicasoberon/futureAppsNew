import SwiftUI

struct LawyerAvailabilityView: View {
    @ObservedObject var viewModel = CitasViewModel()   // Bind to the ViewModel
    let lawyer: UserModel
    
    @State private var selectedDate: Date = Date()     // Selected date
    @State private var selectedTime: Date?             // Selected time slot

    var body: some View {
        VStack {
            Text("Disponibilidad de \(lawyer.name)")
                .font(.title)
                .padding(.top, 50)
                .foregroundColor(Color(hex: "#003366"))

            // Date picker to choose a date
            DatePicker("Selecciona una fecha", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .onChange(of: selectedDate) { newDate in
                    viewModel.fetchBookedTimes(for: lawyer.id, on: newDate)
                }

            if viewModel.isLoading {
                ProgressView("Cargando horarios...")
                    .padding()
            } else {
                Text("Horarios Disponibles")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#003366"))
                    .padding(.top)

                // List of available times
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.availableTimes, id: \.self) { time in
                            Button(action: {
                                selectedTime = time
                            }) {
                                Text(timeString(for: time))
                                    .foregroundColor(selectedTime == time ? .white : .blue)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(selectedTime == time ? Color.blue : Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }

            Spacer()

            // Button to confirm and create the meeting
            Button(action: {
                if let selectedTime = selectedTime {
                    viewModel.createMeeting(with: lawyer, at: selectedTime)
                }
            }) {
                Text("Confirmar")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedTime != nil ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(selectedTime == nil)  // Disable if no time is selected
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.successMessage != nil },
                set: { _ in viewModel.successMessage = nil }
            )) {
                Alert(title: Text("Cita creada"), message: Text(viewModel.successMessage ?? ""), dismissButton: .default(Text("OK")))
            }

            // Error message alert using `showErrorAlert`
            .alert(isPresented: $viewModel.showErrorAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchBookedTimes(for: lawyer.id, on: selectedDate)
        }
    }
    
    // Helper function to format the time as a string
    func timeString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
