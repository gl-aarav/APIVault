import SwiftUI

struct SidebarView: View {
    var viewModel: VaultViewModel

    var body: some View {
        List {
            ForEach(PresetCategory.allCases) { category in
                let categoryPresets = viewModel.addedPresets(in: category)
                if !categoryPresets.isEmpty {
                    Section(category.rawValue) {
                        ForEach(categoryPresets) { preset in
                            PresetSidebarRow(
                                preset: preset,
                                storedKeyCount: viewModel.entries(for: preset).count,
                                isSelected: viewModel.selectedPresetID == preset.id && !viewModel.isShowingAddPresetBrowser
                            )
                            .onTapGesture {
                                viewModel.select(preset)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("API Vault")
        .toolbar(removing: .sidebarToggle)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.showAddPresetBrowser()
                } label: {
                    Label("Add API", systemImage: "plus")
                }
                .labelStyle(.iconOnly)
                .help("Add API")
            }
        }
    }
}

private struct PresetSidebarRow: View {
    let preset: Preset
    let storedKeyCount: Int
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            PresetIconView(preset: preset, size: 19)
                .opacity(storedKeyCount > 0 ? 1 : 0.7)

            VStack(alignment: .leading, spacing: 2) {
                Text(preset.serviceName)
                    .font(.body.weight(.medium))
                Text(preset.environmentVariable)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            if storedKeyCount > 0 {
                Text("\(storedKeyCount)")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.gray.opacity(0.22))
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .help(storedKeyCount > 0 ? "\(storedKeyCount) keychain item(s)" : "No key saved yet")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}
