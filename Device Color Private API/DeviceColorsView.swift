import SwiftUI

struct DeviceColorsView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var report: DeviceColorReport?
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if isLoading {
                    ProgressView()
                        .controlSize(.large)
                        .padding(.top, 64)
                } else if let report {
                    DeviceDetailsCardView(report: report)
                    DeviceColorSwatchCardView(title: "DeviceColor", colorToken: report.deviceColor)
                    DeviceColorSwatchCardView(title: "DeviceEnclosureColor", colorToken: report.deviceEnclosureColor)
                } else {
                    if #available(iOS 17, *) {
                        ContentUnavailableView("No Device Data", systemImage: "exclamationmark.triangle")
                            .padding(.top, 64)
                    } else {
                        VStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 28))
                                .foregroundStyle(.secondary)
                            Text("No Device Data")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 64)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .navigationTitle("Device Colors")
        .toolbar {
            if let report {
                ShareLink(item: report.shareText) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
        .background(
            LinearGradient(
                colors: backgroundColors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .task {
            await loadReport()
        }
    }
    
    private var backgroundColors: [Color] {
        if colorScheme == .dark {
            [
                Color(uiColor: .systemBackground),
                Color(uiColor: .secondarySystemBackground)
            ]
        } else {
            [
                Color(uiColor: .systemGroupedBackground),
                Color(uiColor: .systemBackground)
            ]
        }
    }
    
    private func loadReport() async {
        isLoading = true
        report = await DeviceColorRepository.loadReport()
        isLoading = false
    }
}
