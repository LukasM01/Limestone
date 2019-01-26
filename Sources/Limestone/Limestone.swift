//
//  Limestone.swift
//  Limestone
//
//  Created by Lukas Möller on 26.01.19.
//  Copyright © 2019 Lukas Möller. All rights reserved.
//

import Foundation

public enum FontColor {
    case defaultColor
    
    case black
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
    
    case brightBlack
    case brightRed
    case brightGreen
    case brightYellow
    case brightBlue
    case brightMagenta
    case brightCyan
    case brightWhite
    
    static var `default`: FontColor {
        return .defaultColor
    }
}
public enum FontEffect {
    case foregroundColor(FontColor)
    case backgroundColor(FontColor)
    case bold(Bool)
    case underline(Bool)
    case strikethrough(Bool)
    case italic(Bool)
    var type: EffectType {
        switch self {
        case .foregroundColor(_):
            return .foregroundColor
        case .backgroundColor(_):
            return .backgroundColor
        case .bold(_):
            return .bold
        case .underline(_):
            return .underline
        case .strikethrough(_):
            return .strikethrough
        case .italic(_):
            return .italic
        }
    }
}
public enum EffectType {
    case foregroundColor
    case backgroundColor
    case bold
    case underline
    case strikethrough
    case italic
}
public enum FontEffectElement {
    case push(FontEffect)
    case pop(EffectType)
}
public protocol EscapeCodeProvider {
    var enabled: Bool {get}
    func foregroundEscapeCode(for color: FontColor)-> String
    func backgroundEscapeCode(for color: FontColor)-> String
    func boldEscapeCode(_ activated: Bool)-> String
    func underlinedEscapeCode(_ activated: Bool)-> String
    func strikethroughEscapeCode(_ activated: Bool)-> String
    func italicEscapeCode(_ activated: Bool)->String
}
enum ANSIEscapeCode: UInt {
    static var supported: Bool = {
        return ProcessInfo.processInfo.environment["TERM"]?.contains("color") ?? false
    }()
    
    case reset = 0
    case bold
    case faint
    case italic
    case underline
    case slowBlink
    case rapidBlink
    case reverse
    case conceal
    case crossedOut
    
    case primaryFont
    case alternativeFont1
    case alternativeFont2
    case alternativeFont3
    case alternativeFont4
    case alternativeFont5
    case alternativeFont6
    case alternativeFont7
    case alternativeFont8
    case alternativeFont9
    case fraktur
    
    case boldOff
    case normalColor
    case italicOff
    case underlineOff
    case blinkOff
    case unused
    case inverseOff
    case concealOff
    case crossedOutOff
    
    case fgBlack
    case fgRed
    case fgGreen
    case fgYellow
    case fgBlue
    case fgMagenta
    case fgCyan
    case fgWhite
    
    case setFg
    case fgDefault
    
    case bgBlack
    case bgRed
    case bgGreen
    case bgYellow
    case bgBlue
    case bgMagenta
    case bgCyan
    case bgWhite
    
    case setBg
    case bgDefault
    
    case fgBrightBlack = 90
    case fgBrightRed
    case fgBrightGreen
    case fgBrightYellow
    case fgBrightBlue
    case fgBrightMagenta
    case fgBrightCyan
    case fgBrightWhite
    
    case bgBrightBlack = 100
    case bgBrightRed
    case bgBrightGreen
    case bgBrightYellow
    case bgBrightBlue
    case bgBrightMagenta
    case bgBrightCyan
    case bgBrightWhite
}
class ANSIEscapeCodeProvider: EscapeCodeProvider {
    var enabled: Bool {
        return ANSIEscapeCode.supported
    }
    func codeToString(_ code: UInt)-> String {
        return "\u{001B}[\(code)m"
    }
    func foregroundEscapeCode(for color: FontColor) -> String {
        let code: ANSIEscapeCode
        switch color {
        case .defaultColor:
            code = .fgDefault
        case .black:
            code = .fgBlack
        case .red:
            code = .fgRed
        case .green:
            code = .fgGreen
        case .yellow:
            code = .fgYellow
        case .blue:
            code = .fgBlue
        case .magenta:
            code = .fgMagenta
        case .cyan:
            code = .fgCyan
        case .white:
            code = .fgWhite
        case .brightBlack:
            code = .fgBrightBlack
        case .brightRed:
            code = .fgBrightRed
        case .brightGreen:
            code = .fgBrightGreen
        case .brightYellow:
            code = .fgBrightYellow
        case .brightBlue:
            code = .fgBrightBlue
        case .brightMagenta:
            code = .fgBrightMagenta
        case .brightCyan:
            code = .fgBrightCyan
        case .brightWhite:
            code = .fgBrightWhite
        }
        return codeToString(code.rawValue)
    }
    
    func backgroundEscapeCode(for color: FontColor) -> String {
        let code: ANSIEscapeCode
        switch color {
        case .defaultColor:
            code = .bgDefault
        case .black:
            code = .bgBlack
        case .red:
            code = .bgRed
        case .green:
            code = .bgGreen
        case .yellow:
            code = .bgYellow
        case .blue:
            code = .bgBlue
        case .magenta:
            code = .bgMagenta
        case .cyan:
            code = .bgCyan
        case .white:
            code = .bgWhite
        case .brightBlack:
            code = .bgBrightBlack
        case .brightRed:
            code = .bgBrightRed
        case .brightGreen:
            code = .bgBrightGreen
        case .brightYellow:
            code = .bgBrightYellow
        case .brightBlue:
            code = .bgBrightBlue
        case .brightMagenta:
            code = .bgBrightMagenta
        case .brightCyan:
            code = .bgBrightCyan
        case .brightWhite:
            code = .bgBrightWhite
        }
        return codeToString(code.rawValue)
    }
    
    func boldEscapeCode(_ activated: Bool) -> String {
        let code = activated ? ANSIEscapeCode.bold : ANSIEscapeCode.boldOff
        return codeToString(code.rawValue)
    }
    
    func underlinedEscapeCode(_ activated: Bool) -> String {
        let code = activated ? ANSIEscapeCode.underline : ANSIEscapeCode.underlineOff
        return codeToString(code.rawValue)
    }
    
    func strikethroughEscapeCode(_ activated: Bool) -> String {
        let code = activated ? ANSIEscapeCode.crossedOut : ANSIEscapeCode.crossedOutOff
        return codeToString(code.rawValue)
    }
    
    func italicEscapeCode(_ activated: Bool) -> String {
        let code = activated ? ANSIEscapeCode.italic : ANSIEscapeCode.italicOff
        return codeToString(code.rawValue)
    }
}
protocol Countable {
    var count: Int {get}
}
extension String: Countable {
    
}
public struct EffectString: Countable {
    let text: String
    var effects: [Int: [FontEffectElement]]
    static var defaultEspaceCodeProvider = ANSIEscapeCodeProvider()
    public var customEscapeCodeProvider: EscapeCodeProvider? = nil
    public init(_ string: String) {
        text = string
        effects = [:]
    }
    public init(_ string: String, effects: [Int: [FontEffectElement]]) {
        text = string
        self.effects = effects
    }
    var escapeCodeProvider: EscapeCodeProvider {
        return customEscapeCodeProvider ?? EffectString.defaultEspaceCodeProvider
    }
    public var count: Int {
        return text.count
    }
    public var rendered: String {
        if !escapeCodeProvider.enabled {
            return text
        }
        var result = ""
        
        var fg: [FontColor] = []
        var bg: [FontColor] = []
        var bold: [Bool] = []
        var underlined: [Bool] = []
        var strikethrough: [Bool] = []
        var italic: [Bool] = []
        
        var i = 0
        
        while i <= text.count {
            if let entries = effects[i] {
                var fgChanged = false
                var bgChanged = false
                var boldChanged = false
                var underlinedChanged = false
                var strikethroughChanged = false
                var italicChanged = false
                for element in entries {
                    switch element {
                    case .push(let effect):
                        switch effect {
                        case .foregroundColor(let color):
                            fg.append(color)
                            fgChanged = true
                        case .backgroundColor(let color):
                            bg.append(color)
                            bgChanged = true
                        case .bold(let activated):
                            bold.append(activated)
                            boldChanged = true
                        case .underline(let activated):
                            underlined.append(activated)
                            underlinedChanged = true
                        case .strikethrough(let activated):
                            strikethrough.append(activated)
                            strikethroughChanged = true
                        case .italic(let activated):
                            italic.append(activated)
                            italicChanged = true
                        }
                    case .pop(let type):
                        switch type {
                        case .foregroundColor:
                            _ = fg.popLast()
                            fgChanged = true
                        case .backgroundColor:
                            _ = bg.popLast()
                            bgChanged = true
                        case .bold:
                            _ = bold.popLast()
                            boldChanged = true
                        case .underline:
                            _ = underlined.popLast()
                            underlinedChanged = true
                        case .strikethrough:
                            _ = strikethrough.popLast()
                            strikethroughChanged = true
                        case .italic:
                            _ = italic.popLast()
                            italicChanged = true
                        }
                    }
                }
                if fgChanged {
                    let color = fg.last ?? FontColor.default
                    let code = escapeCodeProvider.foregroundEscapeCode(for: color)
                    result += code
                }
                if bgChanged {
                    let color = bg.last ?? FontColor.default
                    let code = escapeCodeProvider.backgroundEscapeCode(for: color)
                    result += code
                }
                if boldChanged {
                    let activated = bold.last ?? false
                    let code = escapeCodeProvider.boldEscapeCode(activated)
                    result += code
                }
                if underlinedChanged {
                    let activated = underlined.last ?? false
                    let code = escapeCodeProvider.underlinedEscapeCode(activated)
                    result += code
                }
                if strikethroughChanged {
                    let activated = strikethrough.last ?? false
                    let code = escapeCodeProvider.strikethroughEscapeCode(activated)
                    result += code
                }
                if italicChanged {
                    let activated = italic.last ?? false
                    let code = escapeCodeProvider.italicEscapeCode(activated)
                    result += code
                }
                if i < text.count {
                    let index = text.index(text.startIndex, offsetBy: i)
                    result.append(text[index])
                }
            }else{
                if i < text.count {
                    let index = text.index(text.startIndex, offsetBy: i)
                    result.append(text[index])
                }
            }
            i += 1
        }
        return result
    }
    public mutating func apply(range: Range<Int>, effect: FontEffect) {
        let type = effect.type
        effects[range.lowerBound, default: []].append(.push(effect))
        effects[range.upperBound, default: []].append(.pop(type))
    }
    public mutating func apply(effect: FontEffect) {
        let type = effect.type
        let range = 0..<text.count
        effects[range.lowerBound, default: []].append(.push(effect))
        effects[range.upperBound, default: []].append(.pop(type))
    }
    public func foreground(_ color: FontColor)->EffectString{
        var new = self
        new.apply(effect: .foregroundColor(color))
        return new
    }
    public func background(_ color: FontColor)->EffectString{
        var new = self
        new.apply(effect: .backgroundColor(color))
        return new
    }
    public func bold()->EffectString{
        var new = self
        new.apply(effect: .bold(true))
        return new
    }
    public func underline()->EffectString{
        var new = self
        new.apply(effect: .underline(true))
        return new
    }
    public func strikethrough()->EffectString{
        var new = self
        new.apply(effect: .strikethrough(true))
        return new
    }
    public func italic()->EffectString{
        var new = self
        new.apply(effect: .italic(true))
        return new
    }
    func appending(other: EffectString)->EffectString {
        let newText = text + other.text
        var newEffects = effects
        for effect in other.effects {
            let newKey = effect.key + text.count
            for e in effect.value {
                newEffects[newKey, default: []].append(e)
            }
        }
        return EffectString(newText, effects: newEffects)
    }
}
extension EffectString: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        text = value
        effects = [:]
    }
}
public protocol TextRenderable {
    var rendered: String {get}
    var count: Int {get}
}
extension String: TextRenderable {
    public var rendered: String {
        return self
    }
}
public extension String {
    public func foreground(_ color: FontColor)->EffectString{
        var new = EffectString(self)
        new.apply(effect: .foregroundColor(color))
        return new
    }
    public func background(_ color: FontColor)->EffectString{
        var new = EffectString(self)
        new.apply(effect: .backgroundColor(color))
        return new
    }
    public func bold()->EffectString{
        var new = EffectString(self)
        new.apply(effect: .bold(true))
        return new
    }
    public func underline()->EffectString{
        var new = EffectString(self)
        new.apply(effect: .underline(true))
        return new
    }
    public func strikethrough()->EffectString{
        var new = EffectString(self)
        new.apply(effect: .strikethrough(true))
        return new
    }
    public func italic()->EffectString{
        var new = EffectString(self)
        new.apply(effect: .italic(true))
        return new
    }
}
extension EffectString: TextRenderable {}
public func +(left: EffectString, right: EffectString)->EffectString {
    return left.appending(other: right)
}
public func +(left: String, right: EffectString)->EffectString {
    return EffectString(left).appending(other: right)
}
public func +(left: EffectString, right: String)->EffectString {
    return left.appending(other: EffectString(right))
}
