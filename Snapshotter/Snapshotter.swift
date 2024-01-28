import XCTest
import GradientView

final class Snapshotter: XCTestCase {
    func testSnapshots() throws {
		let path = "../Documentation.docc/Resources"
		let size = CGSize(width: 320, height: 568)

		try snapshotGradientView(name: "Linear", path: path, size: size) { gradientView in
			gradientView.colours = [#colorLiteral(red: 0.2394109989, green: 0.7730839539, blue: 1, alpha: 1), #colorLiteral(red: 0.607675281, green: 0.8927237161, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.7196065661, blue: 0.6126143348, alpha: 1)]
			gradientView.startPoint = .init(x: 0.5, y: 0)
			gradientView.endPoint = .init(x: 0.5, y: 1)
			gradientView.type = .axial
		}

		try snapshotGradientView(name: "Radial", path: path, size: size) { gradientView in
			gradientView.colours = [#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
			gradientView.locations = [0.05, 0.15, 1]
			gradientView.startPoint = .init(x: 0.5, y: 1)
			gradientView.endPoint = .init(x: 0, y: 0)
			gradientView.type = .radial(factor: 1)
		}

		try snapshotGradientView(name: "RadialFactor1", path: path, size: size) { gradientView in
			let a = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
			let b = #colorLiteral(red: 0.8103209438, green: 0.9504802514, blue: 1, alpha: 1)
			gradientView.colours = stripeColours(first: a, second: b, count: 6)
			gradientView.locations = stripeLocations(count: 6)
			gradientView.startPoint = .init(x: 1, y: 1)
			gradientView.endPoint = .init(x: 0, y: 0)
			gradientView.type = .radial(factor: 1)
		}

		try snapshotGradientView(name: "RadialFactor0.75", path: path, size: size) { gradientView in
			let a = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
			let b = #colorLiteral(red: 0.8103209438, green: 0.9504802514, blue: 1, alpha: 1)
			gradientView.colours = stripeColours(first: a, second: b, count: 6)
			gradientView.locations = stripeLocations(count: 6)
			gradientView.startPoint = .init(x: 1, y: 1)
			gradientView.endPoint = .init(x: 0, y: 0)
			gradientView.type = .radial(factor: 0.75)
		}

		try snapshotGradientView(name: "RadialFactor0.5", path: path, size: size) { gradientView in
			let a = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
			let b = #colorLiteral(red: 0.8103209438, green: 0.9504802514, blue: 1, alpha: 1)
			gradientView.colours = stripeColours(first: a, second: b, count: 6)
			gradientView.locations = stripeLocations(count: 6)
			gradientView.startPoint = .init(x: 1, y: 1)
			gradientView.endPoint = .init(x: 0, y: 0)
			gradientView.type = .radial(factor: 0.5)
		}

		try snapshotGradientView(name: "RadialFactor0.25", path: path, size: size) { gradientView in
			let a = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
			let b = #colorLiteral(red: 0.8103209438, green: 0.9504802514, blue: 1, alpha: 1)
			gradientView.colours = stripeColours(first: a, second: b, count: 6)
			gradientView.locations = stripeLocations(count: 6)
			gradientView.startPoint = .init(x: 1, y: 1)
			gradientView.endPoint = .init(x: 0, y: 0)
			gradientView.type = .radial(factor: 0.25)
		}

		try snapshotGradientView(name: "Conic", path: path, size: size) { gradientView in
			let a = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
			let b = #colorLiteral(red: 1, green: 0.7098278411, blue: 0.8206208596, alpha: 1)
			gradientView.colours = stripeColours(first: a, second: b, count: 9)
			gradientView.locations = stripeLocations(count: 9)
			gradientView.startPoint = .init(x: 0.5, y: 0.7)
			gradientView.type = .conic(angle: 0.6)
		}
	}
}

func snapshotGradientView(
	name: String,
	path: String,
	size: CGSize,
	actions: (GradientView) -> Void
) throws {
	let gradientView = GradientView()
	actions(gradientView)
	try snapshot(name: name, path: path, view: gradientView, size: size)
}

func snapshot(
	name: String,
	path: String,
	view: UIView,
	size: CGSize,
	file: StaticString = #file
) throws {
	let fileURL = URL(fileURLWithPath: "\(file)", isDirectory: false)
	let directoryURL = fileURL.deletingLastPathComponent().appending(component: path)

	let bounds = CGRect(origin: .zero, size: size)
	view.frame = bounds
	view.layoutIfNeeded()

	let format = UIGraphicsImageRendererFormat()
	format.scale = 1
	format.opaque = false
	format.preferredRange = .standard
	let imageURL = directoryURL.appending(component: "\(name).png", directoryHint: .notDirectory)
	try UIGraphicsImageRenderer(bounds: bounds, format: format).pngData { context in
		view.layer.render(in: context.cgContext)
	}.write(to: imageURL)

	format.scale = 2
	let imageURL2x = directoryURL.appending(component: "\(name)@2x.png", directoryHint: .notDirectory)
	try UIGraphicsImageRenderer(bounds: bounds, format: format).pngData { context in
		view.layer.render(in: context.cgContext)
	}.write(to: imageURL2x)
}

private func stripeColours(first: UIColor, second: UIColor, count: Int) -> [UIColor] {
	return [first, first, second, second] * count
}

private func stripeLocations(count: Int) -> [CGFloat] {
	return (0 ..< count * 4).map { n in
		let a: Int = (n + 1) / 2
		return CGFloat(a) / CGFloat(count * 2)
	}
}

private extension Array {
	static func *(lhs: Array<Element>, rhs: Int) -> Array<Element> {
		var result: [Element] = []
		for _ in 0 ..< rhs {
			result += lhs
		}

		return result
	}
}
