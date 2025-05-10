//
//  TodoRow.swift
//  ToDoList
//
//  Created by Ali Alper sever on 10.05.2025.
//


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
