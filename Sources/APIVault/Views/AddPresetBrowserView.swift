import SwiftUI

struct AddPresetBrowserView: View {
    var viewModel: VaultViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header
                searchField
                presetList
            }
            .padding(34)
            .frame(maxWidth: 760, alignment: .leading)
        }
        .scrollContentBackground(.hidden)
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 18) {
            Image(systemName: "plus")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 72, height: 72)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 24))

            VStack(alignment: .leading, spacing: 6) {
                Text("Add API")
                    .font(.largeTitle.bold())
                Text("Choose a preset")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search APIs", text: Bindable(viewModel).addPresetSearchText)
                .textFieldStyle(.plain)
                .font(.body)

            if !viewModel.addPresetSearchText.isEmpty {
                Button {
                    viewModel.addPresetSearchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .help("Clear search")
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .frame(maxWidth: 520)
        .glassEffect(.regular, in: .rect(cornerRadius: 14))
    }

    private var presetList: some View {
        VStack(alignment: .leading, spacing: 18) {
            ForEach(PresetCategory.allCases) { category in
                let categoryPresets = viewModel.addablePresets(
                    in: category,
                    matching: viewModel.addPresetSearchText
                )

                if !categoryPresets.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(category.rawValue)
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        VStack(spacing: 10) {
                            ForEach(categoryPresets) { preset in
                                AddPresetRow(preset: preset) {
                                    viewModel.openPresetForKeyEntry(preset)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct AddPresetRow: View {
    let preset: Preset
    let onAdd: () -> Void

    var body: some View {
        Button(action: onAdd) {
            HStack(spacing: 14) {
                PresetIconView(preset: preset, size: 28)
                    .frame(width: 48, height: 48)
                    .glassEffect(.regular.tint(preset.accent.color.opacity(0.18)), in: .rect(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 4) {
                    Text(preset.serviceName)
                        .font(.headline)
                    Text(preset.environmentVariable)
                        .font(.callout.monospaced())
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 18))
        }
        .buttonStyle(.plain)
        .help("Add \(preset.serviceName)")
    }
}
