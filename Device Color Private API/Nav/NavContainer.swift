import SwiftUI

struct NavContainer: View {
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                DeviceColorsView()
            }
        } else {
            NavigationView {
                DeviceColorsView()
            }
        }
    }
}
