import SwiftUI

struct DeviceColorToolbarModifier: ViewModifier {
    private let report: DeviceColorReport?
    
    init(_ report: DeviceColorReport?) {
        self.report = report
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content.toolbar {
                if let report {
                    ShareLink(item: report.shareText) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
        } else {
            content
        }
    }
}
