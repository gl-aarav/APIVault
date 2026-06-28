import Foundation

struct AddedPresetStore {
    private let defaults: UserDefaults
    private let storageKey = "com.aaravgoyal.APIVault.addedPresets.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadPresetIDs() -> Set<Preset.ID>? {
        guard let ids = defaults.array(forKey: storageKey) as? [Preset.ID] else {
            return nil
        }

        return Set(ids)
    }

    func savePresetIDs(_ ids: Set<Preset.ID>) {
        defaults.set(Array(ids).sorted(), forKey: storageKey)
    }
}
