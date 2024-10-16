import SwiftUI

// Identifiable error for showing error alerts in SwiftUI
struct IdentifiableError: Identifiable {
    var id = UUID()  // Each error gets a unique ID
    var message: String  // The error message to display in the alert
}

struct LawyerAvailabilityView: View {
    let lawyer: UserModel
    @State private var selectedDate: Date = Date()   // Selected date
    @State private var bookedTimes: [Date] = []      // Lawyer's booked times (unavailable slots)
    @State private var availableTimes: [Date] = []   // Lawyer's available times (9 AM - 5 PM)
    @State private var selectedTime: Date?           // Selected time slot
    @State private var isLoading = false             // Loading state for fetching times
    @State private var showConfirmation = false      // State to show confirmation alert
    @State private var apiErrorMessage: IdentifiableError? // State for API error handling
    @State private var successMessage: String?       // State for success message when cita is created

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
                    fetchBookedTimes(for: newDate)
                }

            if isLoading {
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
                        ForEach(availableTimes, id: \.self) { time in
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
                    createMeeting(with: lawyer, at: selectedTime)
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
            .alert(isPresented: $showConfirmation) {
                Alert(title: Text("Cita creada"), message: Text(successMessage ?? "Tu cita ha sido creada exitosamente."), dismissButton: .default(Text("OK")))
            }

            // Error message alert
            .alert(item: $apiErrorMessage) { identifiableError in
                Alert(title: Text("Error"), message: Text(identifiableError.message), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
        .onAppear {
            fetchBookedTimes(for: selectedDate)
        }
    }

    // Function to generate time slots (9 AM to 5 PM) and exclude booked times
    func generateAvailableTimes() {
        var slots: [Date] = []
        let calendar = Calendar.current
        
        // Generate slots between 9:00 AM and 5:00 PM
        for hour in 9..<17 {
            if let slot = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: selectedDate) {
                slots.append(slot)
            }
        }
        
        // Filter out booked times
        availableTimes = slots.filter { !bookedTimes.contains($0) }
    }

    // Fetch booked times for the lawyer from the backend
    func fetchBookedTimes(for date: Date) {
        isLoading = true
        bookedTimes = []  // Clear existing booked times
        
        // Format the date as YYYY-MM-DD to send to the backend
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: date)
        
        // Backend API to fetch booked times for the lawyer
        let urlString = "http://localhost:3000/api/citas/lawyers/\(lawyer.id)/availability?date=\(formattedDate)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL for lawyer booked times")
            return
        }

        // API call to fetch booked times
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                print("Error fetching booked times: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.apiErrorMessage = IdentifiableError(message: "Error al obtener horarios: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                print("No data returned")
                DispatchQueue.main.async {
                    self.apiErrorMessage = IdentifiableError(message: "No se recibió respuesta del servidor.")
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                // Decode booked times
                let times = try decoder.decode([Date].self, from: data)
                
                DispatchQueue.main.async {
                    self.bookedTimes = times
                    self.generateAvailableTimes()  // Generate available times after fetching booked times
                }
            } catch {
                print("Failed to decode booked times: \(error)")
                DispatchQueue.main.async {
                    self.apiErrorMessage = IdentifiableError(message: "Error al decodificar horarios: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    // Function to format the time as a string
    func timeString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    // Create a meeting (POST request to backend)
    func createMeeting(with lawyer: UserModel, at time: Date) {
        // Mock user ID (replace with actual logged-in user info)
        let userId = "currentUserId"

        // Backend API endpoint to create a new appointment
        let urlString = "http://localhost:3000/api/citas"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL for creating meeting")
            return
        }

        // Create request body with selected lawyer and time
        let meetingDetails: [String: Any] = [
            "cliente_id": userId,
            "abogado_id": lawyer.id,
            "hora": ISO8601DateFormatter().string(from: time)
        ]

        // Convert meeting details to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: meetingDetails) else {
            print("Failed to serialize meeting details")
            return
        }

        // Create the POST request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error creating meeting: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.apiErrorMessage = IdentifiableError(message: "Error al crear cita: \(error.localizedDescription)")
                }
                return
            }

            // Check the response status code to confirm success
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Successfully created the meeting
                DispatchQueue.main.async {
                    // Create a user-friendly success message
                    if let selectedTime = selectedTime {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        formatter.timeStyle = .short
                        let formattedTime = formatter.string(from: selectedTime)
                        self.successMessage = "Tu cita con \(lawyer.name) ha sido creada para el \(formattedTime)."
                    }
                    self.showConfirmation = true  // Show confirmation alert
                }
            } else {
                // Handle non-201 status codes
                DispatchQueue.main.async {
                    self.apiErrorMessage = IdentifiableError(message: "Error al crear cita: Código de estado \(response.debugDescription)")
                }
            }
        }.resume()
    }
}

#Preview {
    LawyerAvailabilityView(lawyer: UserModel.defaultValue)
}
