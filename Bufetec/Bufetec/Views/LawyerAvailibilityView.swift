import SwiftUI

struct LawyerAvailabilityView: View {
    @ObservedObject var viewModel = CitasViewModel()   // Bind to the ViewModel
    let lawyer: UserModel
    
    @State private var selectedDate: Date = Date()     // Selected date
    @State private var selectedTime: Date?             // Selected time slot
    @State private var showSuccessPopup: Bool = false  // Control when to show the success pop-up
    @State private var successPopupText: String = ""   // The content of the success pop-up

    var body: some View {
        ZStack {
            VStack {
                Text("Disponibilidad de \(lawyer.name)")
                    .font(.title)
                    .padding(.top, 50)
                    .foregroundColor(Color(hex: "#003366"))

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
                .disabled(selectedTime == nil)
            }
            
            // Custom Pop-up Overlay for Success Message
            if showSuccessPopup {
                successPopupView
                    .transition(.scale)
                    .animation(.easeInOut(duration: 0.5), value: showSuccessPopup)
                    .zIndex(1)  // Ensure the pop-up is on top of everything
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchBookedTimes(for: lawyer.id, on: selectedDate)
        }
        .onReceive(viewModel.$successMessage) { successMessage in
            if let message = successMessage {
                showSuccessPopup(with: message)
            }
        }
    }
    
    // Helper function to format the time as a string
    func timeString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Success Pop-up View
    var successPopupView: some View {
        VStack(spacing: 20) {
            Text("Cita Creada Exitosamente")
                .font(.title2)
                .foregroundColor(.black)
                .padding(.top, 10)
            
            Text(successPopupText)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                withAnimation {
                    showSuccessPopup = false
                }
                viewModel.successMessage = nil  // Clear the success message
            }) {
                Text("OK")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
        }
        .padding()
        .background(Color.white) // White background for the popup
        .cornerRadius(20)
        .shadow(radius: 20)
        .frame(maxWidth: 300)
        .frame(maxHeight: 300)
    }
    
    // Function to show the success pop-up
    func showSuccessPopup(with successMessage: String) {
        let formattedDate = DateFormatter.localizedString(from: selectedTime ?? selectedDate, dateStyle: .medium, timeStyle: .short)
        successPopupText = "Cita con \(lawyer.name) el \(formattedDate)."
        withAnimation {
            showSuccessPopup = true
        }
    }
}
