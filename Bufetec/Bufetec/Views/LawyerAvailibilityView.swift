import SwiftUI

struct LawyerAvailabilityView: View {
    let lawyer: UserModel
    @State private var selectedDate: Date = Date()   // Selected date
    @State private var availableTimes: [Date] = []   // Lawyer's available times
    @State private var selectedTime: Date?           // Selected time slot

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
                .onChange(of: selectedDate) { oldDate, newDate in
                    fetchAvailableTimes(for: newDate)  // Fetch available times for the new selected date
                }

            Text("Horarios Disponibles")
                .font(.headline)
                .foregroundColor(Color(hex: "#003366"))
                .padding(.top)

            // List of available times
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(availableTimesForDate(selectedDate), id: \.self) { time in
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
        }
        .padding()
        .onAppear {
            fetchAvailableTimes(for: selectedDate)
        }
    }

    // Function to format the available time as a string
    func timeString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    // Function to fetch available times for the lawyer on a given date
    func fetchAvailableTimes(for date: Date) {
        let calendar = Calendar.current
        var times: [Date] = []
        let startHour = 9
        let endHour = 17
        
        for hour in startHour..<endHour {
            if let time = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date) {
                times.append(time)
            }
        }
        availableTimes = times
    }

    // Returns available times filtered for the selected date
    func availableTimesForDate(_ date: Date) -> [Date] {
        let calendar = Calendar.current
        return availableTimes.filter { calendar.isDate($0, inSameDayAs: date) }
    }

    // Function to create a meeting (mocked for now)
    func createMeeting(with lawyer: UserModel, at time: Date) {
        print("Meeting with \(lawyer.name) scheduled at \(time)")
        // Here you would send the meeting details to your backend or save locally
    }
}

#Preview {
    LawyerAvailabilityView(lawyer: UserModel.defaultValue)
}
