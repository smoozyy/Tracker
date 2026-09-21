import Foundation

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    var paddingWidth: CGFloat {
        leftInset + rightInset + (cellSpacing * CGFloat(cellCount - 1))
    }
}
