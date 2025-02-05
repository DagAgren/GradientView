import UIKit

/// A view that displays a gradient using a CAGradientLayer, but providing a more
/// convenient API.
@available(iOS 17.0, *)
final public class GradientView: UIView {
	@_documentation(visibility: private)
	public override class var layerClass: AnyClass { return CAGradientLayer.self }

	private var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }

	/// The type of gradient.
	public enum GradientType {
		/// A linear gradient going from ``startPoint`` to ``endPoint``.
		///
		/// ![An example of a linear gradient.](Linear)
		case axial
		/// A circular radial gradient with the centre at ``startPoint`` and ``endPoint`` lying
		/// on the circumference.
		/// - Parameter factor: Controls the "flattening" of the circular gradient. Setting it to
		/// 1 gives a regular circular gradient, while setting it to less moves the starting point
		/// away and adjusts the colour locations to give a less curved gradient if ``startPoint``
		/// is on the edge of the view.
		///
		/// Examples of gradients with `factor` set to 1, 0.75, 0.5 and 0.25:
		/// ![An example of a radial gradient with factor 1.](RadialFactor1)
		/// ![An example of a radial gradient with factor 0.75.](RadialFactor0.75)
		/// ![An example of a radial gradient with factor 0.5.](RadialFactor0.5)
		/// ![An example of a radial gradient with factor 0.25.](RadialFactor0.25)
		case radial(factor: CGFloat)
		/// A conic gradient aroind ``startPoint``, starting at `angle`. ``endPoint`` is ignored.
		/// ``locations`` values are adjusted to make the gradient evenly circular, but interpolation
		/// of colours between locations is not. If you want a correct-looking conic gradient in a
		/// rectangular view, provide a large number of values for ``locations`` and ``colours``.
		///
		/// ![An example of a conic gradient.](Conic)
		///
		/// - Parameter angle: The starting angle of the gradient.
		case conic(angle: CGFloat)
	}

	/// The colours of the gradient, from start to finish. Set at least two.
	public var colours: [UIColor]? { didSet { configureColours() } }

	/// The locations along the gradient of the colours in ``colours``, from 0 at the start to 1
	/// at the end. If not set, the colours will be distributed uniformly along the gradient.
	public var locations: [CGFloat]? { didSet { configure() } }

	/// The starting point of the gradient, in relative coordinates. 0, 0 represents the top left
	/// corner of the view, and 1, 1 represents the bottom right. See ``GradientType`` for more information
	/// about how this value is used for different gradient types.
	public var startPoint: CGPoint = .init(x: 0.5, y: 0) { didSet { configure() } }

	/// The end point of the gradient, in relative coordinates. 0, 0 represents the top left
	/// corner of the view, and 1, 1 represents the bottom right. See ``GradientType`` for more information
	/// about how this value is used for different gradient types.
	public var endPoint: CGPoint = .init(x: 0.5, y: 1) { didSet { configure() } }

	/// The type of the gradient. This is an enum with associated values for the parameters that
	/// only apply to that specific type of gradient.
	public var type: GradientType = .axial { didSet { configure() } }

	override public init(frame: CGRect) {
		super.init(frame: frame)
		configure()
		setupListener()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
		setupListener()
	}

	@_documentation(visibility: private)
	public override func layoutSubviews() {
		configure()
	}

	private func setupListener() {
		registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _) in
			self.configureColours()
		}
	}

	private func configureColours() {
		gradientLayer.colors = colours?.map { $0.cgColor }
	}

	private func configure() {
		let width: CGFloat = frame.width
		let height: CGFloat = frame.height

		let locations = locations ?? colours?.enumerated().map { index, _ in
			CGFloat(index) / CGFloat((colours?.count ?? 0) - 1)
		}

		switch type {
			case .axial:
				gradientLayer.type = .axial
				gradientLayer.locations = locations as [NSNumber]?
				gradientLayer.startPoint = startPoint
				gradientLayer.endPoint = endPoint

			case let .radial(factor):
				let dx: CGFloat = (endPoint.x - startPoint.x) * width
				let dy: CGFloat = (endPoint.y - startPoint.y) * height
				let r: CGFloat = sqrt(dx * dx + dy * dy)
				let startX: CGFloat = endPoint.x + (startPoint.x - endPoint.x) / factor
				let startY: CGFloat = endPoint.y + (startPoint.y - endPoint.y) / factor
				let endX: CGFloat = startX + r / width / factor
				let endY: CGFloat = startY + r / height / factor
				gradientLayer.type = .radial
				gradientLayer.locations = locations?.map { $0 * factor + (1 - factor) } as [NSNumber]?
				gradientLayer.startPoint = .init(x: startX, y: startY)
				gradientLayer.endPoint = .init(x: endX, y: endY)

			case let .conic(angle):
				gradientLayer.type = .conic
				gradientLayer.locations = locations?.map { location in
					let a = angle + location * 2 * .pi
					let b = atan2(sin(a) / height, cos(a) / width) - atan2(sin(angle) / height, cos(angle) / width)
					let c = b / 2 / .pi
					return c - floor(c)
				} as [NSNumber]?
				gradientLayer.startPoint = startPoint
				gradientLayer.endPoint = .init(
					x: startPoint.x + cos(angle) / width,
					y: startPoint.y + sin(angle) / height
				)
		}
	}
}

@available(iOS 18.0, *)
#Preview("Axial gradient") {
    let gradientView = GradientView()
    gradientView.colours = [#colorLiteral(red: 0.2394109989, green: 0.7730839539, blue: 1, alpha: 1), #colorLiteral(red: 0.607675281, green: 0.8927237161, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.7196065661, blue: 0.6126143348, alpha: 1)]
    gradientView.startPoint = .init(x: 0.5, y: 0)
    gradientView.endPoint = .init(x: 0.5, y: 1)
    gradientView.type = .axial
    return gradientView
}

@available(iOS 18.0, *)
#Preview("Radial gradient") {
    let gradientView = GradientView()
    gradientView.colours = [#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
    gradientView.locations = [0.05, 0.15, 1]
    gradientView.startPoint = .init(x: 0.5, y: 1)
    gradientView.endPoint = .init(x: 0, y: 0)
    gradientView.type = .radial(factor: 1)
    return gradientView
}

@available(iOS 18.0, *)
#Preview("Radial gradient with factor") {
    let gradientView = GradientView()
    let a = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    let b = #colorLiteral(red: 0.8103209438, green: 0.9504802514, blue: 1, alpha: 1)
    gradientView.colours = stripeColours(first: a, second: b, count: 6)
    gradientView.locations = stripeLocations(count: 6)
    gradientView.startPoint = .init(x: 1, y: 1)
    gradientView.endPoint = .init(x: 0, y: 0)
    gradientView.type = .radial(factor: 0.75)
    return gradientView
}

@available(iOS 18.0, *)
#Preview("Conic gradient") {
    let gradientView = GradientView()
    let a = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    let b = #colorLiteral(red: 1, green: 0.7098278411, blue: 0.8206208596, alpha: 1)
    gradientView.colours = stripeColours(first: a, second: b, count: 9)
    gradientView.locations = stripeLocations(count: 9)
    gradientView.startPoint = .init(x: 0.5, y: 0.7)
    gradientView.type = .conic(angle: 0.6)
    return gradientView
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
