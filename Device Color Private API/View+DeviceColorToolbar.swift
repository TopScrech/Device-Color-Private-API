import SwiftUI

extension View {
    func deviceColorToolbar(_ report: DeviceColorReport?) -> some View {
        modifier(DeviceColorToolbarModifier(report))
    }
}
