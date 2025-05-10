import SwiftUI

struct ContentView: View {
    @StateObject private var todoStore = TodoStore()
    @State private var showingAddTodo = false
    @State private var searchText = ""
    @State private var selectedCategory: Category?
    @State private var sortOption: SortOption = .createdAt
    
    var filteredTodos: [Todo] {
        let searched = todoStore.searchTodos(query: searchText)
        let categorized = selectedCategory == nil ? searched : searched.filter { $0.category == selectedCategory }
        return todoStore.sortTodos(by: sortOption)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Arama ve filtreleme araç çubuğu
                HStack {
                    TextField("Ara...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Menu {
                        ForEach(Category.allCases, id: \.self) { category in
                            Button(category.rawValue) {
                                selectedCategory = category
                            }
                        }
                        Button("Tümü") {
                            selectedCategory = nil
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                    
                    Menu {
                        Button("Öncelik") { sortOption = .priority }
                        Button("Bitiş Tarihi") { sortOption = .dueDate }
                        Button("Oluşturulma Tarihi") { sortOption = .createdAt }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                .padding()
                
                List {
                    ForEach(filteredTodos) { todo in
                        TodoRow(todo: todo, todoStore: todoStore)
                    }
                    .onDelete(perform: todoStore.deleteTodo)
                }
            }
            .navigationTitle("Yapılacaklar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTodo = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView(todoStore: todoStore)
            }
        }
    }
}

struct TodoRow: View {
    let todo: Todo
    let todoStore: TodoStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: {
                    todoStore.toggleTodo(todo)
                }) {
                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(todo.isCompleted ? .green : .gray)
                }
                
                Text(todo.title)
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .gray : .primary)
                
                Spacer()
                
                // Öncelik göstergesi
                Circle()
                    .fill(priorityColor)
                    .frame(width: 12, height: 12)
            }
            
            HStack {
                // Kategori etiketi
                Text(todo.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                
                // Bitiş tarihi
                if let dueDate = todo.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    var priorityColor: Color {
        switch todo.priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 
