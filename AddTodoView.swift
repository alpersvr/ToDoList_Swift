import SwiftUI

struct AddTodoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var todoStore: TodoStore
    @State private var todoTitle = ""
    @State private var selectedPriority = Priority.medium
    @State private var selectedCategory = Category.personal
    @State private var dueDate: Date = Date()
    @State private var hasDueDate = false
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detaylar")) {
                    TextField("Görev başlığı", text: $todoTitle)
                    
                    Picker("Öncelik", selection: $selectedPriority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    
                    Picker("Kategori", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                Section(header: Text("Bitiş Tarihi")) {
                    Toggle("Bitiş tarihi ekle", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("Tarih", selection: $dueDate, displayedComponents: .date)
                    
                    }
                }
                
                Section(header: Text("Notlar")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Yeni Görev")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    if !todoTitle.isEmpty {
                        let todo = Todo(
                            title: todoTitle,
                            priority: selectedPriority,
                            category: selectedCategory,
                            dueDate: hasDueDate ? dueDate : nil,
                            notes: notes.isEmpty ? nil : notes
                        )
                        todoStore.addTodo(todo)
                        dismiss()
                    }
                }
                .disabled(todoTitle.isEmpty)
            )
        }
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView(todoStore: TodoStore())
    }
} 
