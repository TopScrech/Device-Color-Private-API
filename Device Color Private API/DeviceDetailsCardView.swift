import ScrechKit

struct DeviceDetailsCardView: View {
    private let report: DeviceColorReport
    
    init(_ report: DeviceColorReport) {
        self.report = report
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(report.deviceName)
                .headline()
            
            Text(report.modelCode)
                .secondary()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.thinMaterial, in: .rect(cornerRadius: 20))
    }
}
