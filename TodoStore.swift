import Foundation

enum SortOption {
    case priority
    case dueDate
    case createdAt
}

class TodoStore: ObservableObject {
    @Published var todos: [Todo] = []
    private let saveKey = "SavedTodos"
    
    init() {
        loadTodos()
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
        saveTodos()
    }
    
    func deleteTodo(at indexSet: IndexSet) {
        todos.remove(atOffsets: indexSet)
        saveTodos()
    }
    
    func toggleTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    func filterTodos(by category: Category?) -> [Todo] {
        if let category = category {
            return todos.filter { $0.category == category }
        }
        return todos
    }
    
    func searchTodos(query: String) -> [Todo] {
        if query.isEmpty {
            return todos
        }
        return todos.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
    
    func sortTodos(by sortOption: SortOption) -> [Todo] {
        switch sortOption {
        case .priority:
            return todos.sorted { $0.priority.rawValue > $1.priority.rawValue }
        case .dueDate:
            return todos.sorted { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) }
        case .createdAt:
            return todos.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    private func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadTodos() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Todo].self, from: data) {
            todos = decoded
        }
    }
} 
