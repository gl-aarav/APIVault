import AppKit
import Foundation
import Observation

@MainActor
@Observable
final class VaultViewModel {
    let presets: [Preset]

    var selectedPresetID: Preset.ID? {
        didSet {
            guard oldValue != selectedPresetID else { return }
            handleSelectedPresetChange()
        }
    }
    var addedPresetIDs: Set<Preset.ID> = []
    var entries: [APIKeyEntry] = []
    var searchText = ""
    var addPresetSearchText = ""
    var isShowingAddPresetBrowser = false
    var draftLabel = ""
    var draftEnvironmentVariable = ""
    var draftKey = ""
    var revealedEntryID: APIKeyEntry.ID?
    var revealedKey: String?
    var isWorking = false
    var statusMessage: String?
    var errorMessage: String?

    private let keychain: KeychainManager
    private let entryStore: VaultEntryStore
    private let addedPresetStore: AddedPresetStore

    init(
        presets: [Preset] = Preset.defaults,
        keychain: KeychainManager = .shared,
        entryStore: VaultEntryStore = VaultEntryStore(),
        addedPresetStore: AddedPresetStore = AddedPresetStore()
    ) {
        self.presets = presets
        self.keychain = keychain
        self.entryStore = entryStore
        self.addedPresetStore = addedPresetStore
        entries = entryStore.loadEntries()
        refreshKeyPresence()
        addedPresetIDs = Self.initialAddedPresetIDs(
            storedIDs: addedPresetStore.loadPresetIDs(),
            entries: entries,
            presets: presets
        )
        selectedPresetID = addedPresets.first?.id
        isShowingAddPresetBrowser = addedPresets.isEmpty
        resetDraftForSelectedPreset()
    }

    var selectedPreset: Preset? {
        guard let selectedPresetID else { return nil }
        return presets.first { $0.id == selectedPresetID }
    }

    var selectedPresetHasStoredKey: Bool {
        !selectedEntries.isEmpty
    }

    var selectedEntries: [APIKeyEntry] {
        guard let selectedPreset else { return [] }
        return entries(for: selectedPreset)
    }

    var addedPresets: [Preset] {
        presets.filter { preset in
            addedPresetIDs.contains(preset.id) && !entries(for: preset).isEmpty
        }
    }

    func presets(in category: PresetCategory) -> [Preset] {
        presets.filter { preset in
            guard preset.category == category else { return false }
            guard !searchText.isEmpty else { return true }

            return preset.serviceName.localizedCaseInsensitiveContains(searchText)
                || preset.environmentVariable.localizedCaseInsensitiveContains(searchText)
        }
    }

    func addedPresets(in category: PresetCategory) -> [Preset] {
        addedPresets.filter { preset in
            guard preset.category == category else { return false }
            guard !searchText.isEmpty else { return true }

            return preset.serviceName.localizedCaseInsensitiveContains(searchText)
                || preset.environmentVariable.localizedCaseInsensitiveContains(searchText)
        }
    }

    func addablePresets(in category: PresetCategory, matching query: String) -> [Preset] {
        presets.filter { preset in
            guard preset.category == category else { return false }
            guard entries(for: preset).isEmpty else { return false }

            let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedQuery.isEmpty else { return true }

            return preset.serviceName.localizedCaseInsensitiveContains(trimmedQuery)
                || preset.environmentVariable.localizedCaseInsensitiveContains(trimmedQuery)
        }
    }

    func presetsWithEntries(in category: PresetCategory) -> [Preset] {
        presets.filter { preset in
            preset.category == category && !entries(for: preset).isEmpty
        }
    }

    func select(_ preset: Preset) {
        isShowingAddPresetBrowser = false
        selectedPresetID = preset.id
    }

    func showAddPresetBrowser() {
        isShowingAddPresetBrowser = true
        addPresetSearchText = ""
    }

    func openPresetForKeyEntry(_ preset: Preset) {
        select(preset)
    }

    func addPreset(_ preset: Preset) {
        addedPresetIDs.insert(preset.id)
        addedPresetStore.savePresetIDs(addedPresetIDs)
        select(preset)
    }

    func refreshKeyPresence() {
        let liveEntries = entries.filter { keychain.containsKey(for: $0) }
        if liveEntries.count != entries.count {
            entries = liveEntries
            persistEntries()
        }
    }

    func entries(for preset: Preset) -> [APIKeyEntry] {
        entries
            .filter { $0.presetID == preset.id }
            .sorted { lhs, rhs in
                if lhs.createdAt == rhs.createdAt {
                    return lhs.label.localizedStandardCompare(rhs.label) == .orderedAscending
                }

                return lhs.createdAt < rhs.createdAt
            }
    }

    func saveSelectedKey() async {
        guard let selectedPreset else { return }
        let trimmedKey = draftKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKey.isEmpty else {
            errorMessage = "Enter an API key before saving."
            return
        }

        let entry = APIKeyEntry(
            id: UUID(),
            presetID: selectedPreset.id,
            label: normalizedDraftLabel(for: selectedPreset),
            environmentVariable: normalizedDraftEnvironmentVariable(for: selectedPreset),
            createdAt: Date()
        )
        let keychain = self.keychain
        await perform("Saved \(entry.label).") {
            try keychain.saveKey(trimmedKey, for: entry, preset: selectedPreset)
        }

        if errorMessage == nil {
            addPreset(selectedPreset)
            entries.append(entry)
            persistEntries()
            draftKey = ""
            draftLabel = ""
            draftEnvironmentVariable = selectedPreset.environmentVariable
            revealedEntryID = nil
            revealedKey = nil
            refreshKeyPresence()
        }
    }

    func revealKey(_ entry: APIKeyEntry) async {
        guard let selectedPreset else { return }

        let keychain = self.keychain
        await perform("Unlocked \(entry.label).") {
            try await keychain.fetchKey(for: entry, preset: selectedPreset)
        } onSuccess: { key in
            revealedEntryID = entry.id
            revealedKey = key
        }
    }

    func hideRevealedKey() {
        revealedEntryID = nil
        revealedKey = nil
        statusMessage = "Key hidden."
        errorMessage = nil
    }

    func deleteKey(_ entry: APIKeyEntry) async {
        let deletedLabel = entry.label

        let keychain = self.keychain
        await perform("Deleted \(deletedLabel).") {
            try keychain.deleteKey(for: entry)
        }

        if errorMessage == nil {
            entries.removeAll { $0.id == entry.id }
            persistEntries()
            if revealedEntryID == entry.id {
                revealedEntryID = nil
                revealedKey = nil
            }
            refreshKeyPresence()
        }
    }

    func copyExportCommand(for entry: APIKeyEntry) async {
        guard let selectedPreset else { return }
        await copyExportCommand(for: entry, preset: selectedPreset)
    }

    func copyExportCommand(for entry: APIKeyEntry, preset: Preset) async {
        let keychain = self.keychain
        await perform("Copied export command for \(entry.label).") {
            let key = try await keychain.fetchKey(for: entry, preset: preset)
            let command = "export \(entry.environmentVariable)=\"\(Self.shellEscaped(key))\""
            return command
        } onSuccess: { command in
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(command, forType: .string)
        }
    }

    func exportTemplate(for entry: APIKeyEntry) -> String {
        entry.exportTemplate
    }

    private func perform<Result: Sendable>(
        _ successMessage: String,
        operation: @escaping @Sendable () async throws -> Result,
        onSuccess: (Result) -> Void = { _ in }
    ) async {
        isWorking = true
        errorMessage = nil
        statusMessage = nil

        do {
            let result = try await Task.detached {
                try await operation()
            }.value
            onSuccess(result)
            statusMessage = successMessage
        } catch let error as KeychainError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }

        isWorking = false
    }

    nonisolated private static func shellEscaped(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "$", with: "\\$")
            .replacingOccurrences(of: "`", with: "\\`")
    }

    private func resetDraftForSelectedPreset() {
        draftLabel = ""
        draftKey = ""
        draftEnvironmentVariable = selectedPreset?.environmentVariable ?? ""
    }

    private func handleSelectedPresetChange() {
        revealedEntryID = nil
        revealedKey = nil
        resetDraftForSelectedPreset()
        errorMessage = nil
        statusMessage = nil
    }

    private func normalizedDraftLabel(for preset: Preset) -> String {
        let trimmedLabel = draftLabel.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedLabel.isEmpty {
            return trimmedLabel
        }

        return "\(preset.serviceName) Key \(entries(for: preset).count + 1)"
    }

    private func normalizedDraftEnvironmentVariable(for preset: Preset) -> String {
        let trimmedTag = draftEnvironmentVariable.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedTag.isEmpty ? preset.environmentVariable : trimmedTag
    }

    private func persistEntries() {
        do {
            try entryStore.saveEntries(entries)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private static func initialAddedPresetIDs(
        storedIDs: Set<Preset.ID>?,
        entries: [APIKeyEntry],
        presets: [Preset]
    ) -> Set<Preset.ID> {
        let validPresetIDs = Set(presets.map(\.id))
        let entryPresetIDs = Set(entries.map(\.presetID)).intersection(validPresetIDs)

        guard let storedIDs else {
            return entryPresetIDs
        }

        return storedIDs.intersection(validPresetIDs).union(entryPresetIDs)
    }
}
