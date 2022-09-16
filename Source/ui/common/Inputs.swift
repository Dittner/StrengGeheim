import SwiftUI
import Combine

extension NSTextField {
    func becomeFirstResponderWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            self.becomeFirstResponder()
        }
    }
}

struct TextInput: NSViewRepresentable {
    private static var focusedField: NSTextField?
    public static let tf: NSTextField = NSTextField()

    public let title: String
    @Binding var text: String
    public let textColor: NSColor
    public let font: NSFont
    public let alignment: NSTextAlignment
    public var isFocused: Bool
    public let isSecure: Bool
    public let format: String?
    public let isEditable: Bool
    public let onEnterAction: (() -> Void)?

    func makeNSView(context: Context) -> NSTextField {
        let tf = isSecure ? NSSecureTextField() : NSTextField()
        tf.isBordered = false
        tf.backgroundColor = nil
        tf.focusRingType = .none
        tf.textColor = textColor
        tf.placeholderString = title
        tf.allowsEditingTextAttributes = false
        tf.alignment = alignment
        tf.isEditable = isEditable
        tf.delegate = context.coordinator

        return tf
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        // print("TextInput: updateNSView \(title)")

        context.coordinator.parent = self
        nsView.isEditable = isEditable
        nsView.stringValue = text
        nsView.font = font

        if isFocused && TextInput.focusedField != nsView {
            // print("TextInput: set focus to \(title)")
            TextInput.focusedField = nsView
            nsView.becomeFirstResponderWithDelay()
        }
    }

    func makeCoordinator() -> Coordinator {
        // print("TextInput makeCoordinator, title: \(title)")
        return Coordinator(self)
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: TextInput

        init(_ parent: TextInput) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                if let format = parent.format, textField.stringValue.count > 0, !textField.stringValue.matches(predicate: format.asPredicate) {
                    textField.stringValue = parent.text
                } else if parent.text != textField.stringValue {
                    parent.text = textField.stringValue
                }
            }
        }

        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(NSResponder.insertNewline(_:)) {
                parent.onEnterAction?()
            }
            return false
        }
    }
}
struct MultilineInput: View {
    @ObservedObject private var notifier = HeightDidChangeNotifier()
    @Binding var text: String
    public let width: CGFloat
    public let textColor: NSColor
    public let font: NSFont
    public let isEditing: Bool
    public var minHeight: CGFloat = 60
    public var horizontalPadding: CGFloat = 0
    public var highlightedText: String = ""
    public var fontLineHeight: CGFloat = 30
    public var firstLineHeadIndent: CGFloat = 0
    public var onSelectionChange: ((_ range: NSRange) -> Void)? = nil
    public var onBeginTyping: (() -> Void)? = nil
    public var onEndTyping: (() -> Void)? = nil

    var body: some View {
        TextArea(text: $text, height: $notifier.height, width: width, textColor: textColor, font: font, isEditable: isEditing, highlightedText: highlightedText, firstLineHeadIndent: firstLineHeadIndent, lineHeight: fontLineHeight, onSelectionChange: onSelectionChange, onBeginTyping: onBeginTyping, onEndTyping: onEndTyping)
            .layoutPriority(-1)
            .saturation(0)
            .colorScheme(.dark)
            .offset(x: -5, y: -1)
            .padding(.horizontal, horizontalPadding)
            .frame(width: width, height: max(minHeight - 5, notifier.height), alignment: .topLeading)
            .background(Color.SG.black.cornerRadius(6))
    }
}

class HeightDidChangeNotifier: ObservableObject {
    @Published var height: CGFloat = 0
}

struct TextArea: NSViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    let width: CGFloat
    let textColor: NSColor
    let font: NSFont
    let isEditable: Bool
    let highlightedText: String
    let firstLineHeadIndent: CGFloat
    let lineHeight: CGFloat?
    let onSelectionChange: ((_ range: NSRange) -> Void)?
    let onBeginTyping: (() -> Void)?
    let onEndTyping: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> CustomNSTextView {
        let tv = CustomNSTextView()
        tv.delegate = context.coordinator
        tv.textColor = textColor
        tv.font = font
        tv.allowsUndo = true
        tv.isEditable = isEditable
        tv.isSelectable = isEditable
        tv.defaultParagraphStyle = getStyle()
        tv.backgroundColor = NSColor(rgb: 0x000000, alpha: 0.000001)
        tv.isVerticallyResizable = false
        tv.canDrawSubviewsIntoLayer = true
        tv.string = "Ag"
        return tv
    }

    func getStyle() -> NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.firstLineHeadIndent = firstLineHeadIndent
        style.lineBreakMode = .byWordWrapping
        style.lineSpacing = 0

        if let lineHeight = lineHeight {
            style.minimumLineHeight = lineHeight
            style.maximumLineHeight = lineHeight
            style.lineHeightMultiple = lineHeight
        }

        return style
    }

    func updateNSView(_ textArea: CustomNSTextView, context: Context) {
        textArea.isEditable = isEditable
        textArea.isSelectable = isEditable
        // need update parent, otherwise will be updated text from prev binding
        context.coordinator.parent = self
        if textArea.curHighlightedText != highlightedText {
            textArea.curHighlightedText = highlightedText
        }

        if textArea.string != text {
            textArea.string = text
        }

        if textArea.font != font {
            textArea.font = font
        }

        updateHeight(textArea)
    }

    func updateHeight(_ textArea: CustomNSTextView) {
        textArea.textContainer?.containerSize.width = width
        let updatedHeight = textArea.contentSize.height
        if height != updatedHeight {
            print("updatedHeight = ", updatedHeight)
            height = updatedHeight
        }
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: TextArea

        init(_ textArea: TextArea) {
            parent = textArea
        }

        func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
            return true
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? CustomNSTextView else { return }
            parent.text = textView.string
        }
        
        func textDidBeginEditing(_ notification: Notification) {
            parent.onBeginTyping?()
        }
        
        func textDidEndEditing(_ notification: Notification) {
            parent.onEndTyping?()
        }

        func textView(_ textView: NSTextView, willChangeSelectionFromCharacterRange oldSelectedCharRange: NSRange, toCharacterRange newSelectedCharRange: NSRange) -> NSRange {
            parent.onSelectionChange?(newSelectedCharRange)
            return newSelectedCharRange
        }
    }
}

class CustomNSTextView: NSTextView {
    var curHighlightedText: String = ""

    override func paste(_ sender: Any?) {
        pasteAsPlainText(sender)
    }

    var contentSize: CGSize {
        guard let layoutManager = layoutManager, let textContainer = textContainer else {
            return .zero
        }

        layoutManager.ensureLayout(for: textContainer)
        return layoutManager.usedRect(for: textContainer).size
    }
}



//####### #########



struct MacEditorTextView: NSViewRepresentable {
    @Binding var text: String
    var isEditable: Bool = true
    var font: NSFont?    = .systemFont(ofSize: 14, weight: .regular)
    
    var onEditingChanged: () -> Void       = {}
    var onCommit        : () -> Void       = {}
    var onTextChange    : (String) -> Void = { _ in }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> CustomTextView {
        let textView = CustomTextView(
            text: text,
            isEditable: isEditable,
            font: font
        )
        textView.delegate = context.coordinator
        
        return textView
    }
    
    func updateNSView(_ view: CustomTextView, context: Context) {
        view.text = text
        view.selectedRanges = context.coordinator.selectedRanges
    }
}

// MARK: - Preview
#if DEBUG

struct MacEditorTextView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MacEditorTextView(
                text: .constant("{ \n    planets { \n        name \n    }\n}"),
                isEditable: true,
                font: .userFixedPitchFont(ofSize: 14)
            )
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark Mode")
            
            MacEditorTextView(
                text: .constant("{ \n    planets { \n        name \n    }\n}"),
                isEditable: false
            )
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light Mode")
        }
    }
}

#endif

// MARK: - Coordinator
extension MacEditorTextView {
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: MacEditorTextView
        var selectedRanges: [NSValue] = []
        
        init(_ parent: MacEditorTextView) {
            self.parent = parent
        }
        
        func textDidBeginEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            
            self.parent.text = textView.string
            self.parent.onEditingChanged()
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            
            self.parent.text = textView.string
            self.selectedRanges = textView.selectedRanges
        }
        
        func textDidEndEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            
            self.parent.text = textView.string
            self.parent.onCommit()
        }
    }
}

// MARK: - CustomTextView
final class CustomTextView: NSView {
    private var isEditable: Bool
    private var font: NSFont?
    
    weak var delegate: NSTextViewDelegate?
    
    var text: String {
        didSet {
            textView.string = text
        }
    }
    
    var selectedRanges: [NSValue] = [] {
        didSet {
            guard selectedRanges.count > 0 else {
                return
            }
            
            textView.selectedRanges = selectedRanges
        }
    }
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.isFindBarVisible = false
        scrollView.rulersVisible = false
        scrollView.scrollerKnobStyle = .dark
        scrollView.drawsBackground = false
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.hasVerticalRuler = false
        scrollView.autoresizingMask = [.width, .height]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var textView: NSTextView = {
        let contentSize = scrollView.contentSize
        let textStorage = NSTextStorage()
        
        
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        
        let textContainer = NSTextContainer(containerSize: scrollView.frame.size)
        textContainer.widthTracksTextView = true
        textContainer.containerSize = NSSize(
            width: contentSize.width,
            height: CGFloat.greatestFiniteMagnitude
        )
        
        layoutManager.addTextContainer(textContainer)
        
        
        let textView                     = NSTextView(frame: .zero, textContainer: textContainer)
        textView.autoresizingMask        = .width
        textView.backgroundColor         = NSColor.SG.black
        textView.delegate                = self.delegate
        textView.drawsBackground         = true
        textView.font                    = self.font
        textView.isEditable              = self.isEditable
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable   = true
        textView.maxSize                 = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.minSize                 = NSSize(width: 0, height: contentSize.height)
        textView.textColor               = NSColor.SG.text
        textView.allowsUndo              = true
        
        return textView
    }()
    
    // MARK: - Init
    init(text: String, isEditable: Bool, font: NSFont?) {
        self.font       = font
        self.isEditable = isEditable
        self.text       = text
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewWillDraw() {
        super.viewWillDraw()
        
        setupScrollViewConstraints()
        setupTextView()
    }
    
    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    func setupTextView() {
        scrollView.documentView = textView
    }
}
