import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager

    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var editing: EntryItem?
    @State private var draft: EntryItem = .blank()

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                if store.items.isEmpty {
                    ContentUnavailableView(
                        "No Entries Yet",
                        systemImage: "square.grid.2x2",
                        description: Text("Tap + to add your first entry.")
                    )
                } else {
                    List {
                        ForEach(store.items) { item in
                            Button {
                                draft = item
                                editing = item
                                showingAdd = true
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.bodyArea.isEmpty ? "Untitled" : item.bodyArea)
                                        .font(Theme.bodyFont.weight(.semibold))
                                        .foregroundStyle(Theme.ink)
                                    if !item.severity.isEmpty {
                                        Text(item.severity)
                                            .font(.caption)
                                            .foregroundStyle(Theme.ink.opacity(0.6))
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .accessibilityIdentifier("row_\(item.id.uuidString)")
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets)
                        }
                        .listRowBackground(Color.white.opacity(0.6))
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Sunburn Log")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            draft = .blank()
                            editing = nil
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEditSheet(draft: $draft, isEditing: editing != nil) {
                    if editing != nil {
                        store.update(draft)
                    } else {
                        store.add(draft)
                    }
                    showingAdd = false
                } onCancel: {
                    showingAdd = false
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .tint(Theme.accent)
    }
}

private struct AddEditSheet: View {
    @Binding var draft: EntryItem
    var isEditing: Bool
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Entry Details") {
                TextField("BodyArea", text: $draft.bodyArea)
                    .accessibilityIdentifier("field_bodyArea")
                TextField("Severity", text: $draft.severity)
                    .accessibilityIdentifier("field_severity")
                TextField("HealingDay", text: $draft.healingDay)
                    .accessibilityIdentifier("field_healingDay")
                TextField("Notes", text: $draft.notes)
                    .accessibilityIdentifier("field_notes")
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle(isEditing ? "Edit Entry" : "Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onCancel() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { onSave() }
                        .accessibilityIdentifier("saveButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(PurchaseManager())
}
