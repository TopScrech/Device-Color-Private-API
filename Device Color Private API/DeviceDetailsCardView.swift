import ScrechKit

struct DeviceDetailsCardView: View {
    let report: DeviceColorReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(report.deviceName)
                .title(.semibold)
            
            Text(report.modelCode)
                .secondary()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.thinMaterial, in: .rect(cornerRadius: 20))
    }
}
