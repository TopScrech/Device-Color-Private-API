import ScrechKit

struct DeviceColorSwatchCardView: View {
    let title: String
    let colorToken: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .title(.semibold)
            
            Text(colorToken)
                .semibold()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(DeviceColorPalette.color(for: colorToken), in: .rect(cornerRadius: 12))
                .foregroundStyle(DeviceColorPalette.foregroundColor(for: colorToken))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.thinMaterial, in: .rect(cornerRadius: 20))
    }
}
