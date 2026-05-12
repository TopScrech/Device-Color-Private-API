import ScrechKit

struct DeviceColorSwatchCardView: View {
    private let title: String
    private let colorToken: String
    
    init(_ title: String, colorToken: String) {
        self.title = title
        self.colorToken = colorToken
    }
    
    var body: some View {
        HStack {
            Text(title)
                .headline()
            
            Spacer()
            
            Text(colorToken)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.thinMaterial, in: .rect(cornerRadius: 20))
    }
}
