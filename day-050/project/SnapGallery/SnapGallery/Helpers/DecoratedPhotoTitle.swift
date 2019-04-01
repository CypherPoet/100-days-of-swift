//
//  DecoratedPhotoTitle
//  SnapGallery
//
//  Created by Brian Sipple on 3/31/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

enum DecoratedPhotoTitle {
    static let fontColors: [UIColor] = [
        #colorLiteral(red: 0.2031772137, green: 0.8313577175, blue: 0.5219504833, alpha: 1),
        #colorLiteral(red: 0.9995842576, green: 0.2897895277, blue: 0.4240698218, alpha: 1),
        #colorLiteral(red: 1, green: 0.3941466212, blue: 0.5425403714, alpha: 1),
        #colorLiteral(red: 0, green: 1, blue: 1, alpha: 1),
        #colorLiteral(red: 0.9421440363, green: 0.3172782362, blue: 0.2171499133, alpha: 1),
        #colorLiteral(red: 0.96075207, green: 0.9607582688, blue: 0.9649814963, alpha: 1),
        #colorLiteral(red: 0.576300323, green: 0.7319527268, blue: 1, alpha: 1),
        #colorLiteral(red: 0.9447145462, green: 0.9790630937, blue: 0.5492269397, alpha: 1),
        #colorLiteral(red: 0.5436455607, green: 0.456489861, blue: 0.9988589883, alpha: 1),
        #colorLiteral(red: 0, green: 0.4889892936, blue: 1, alpha: 1),
        #colorLiteral(red: 0.69, green: 0.96, blue: 0.4, alpha: 1),
        #colorLiteral(red: 1, green: 0.3038279712, blue: 0.4778062105, alpha: 1),
        #colorLiteral(red: 0.29, green: 0.95, blue: 0.63, alpha: 1)
    ]

    static func makeAttributedString(for text: String) -> NSAttributedString {
        let attributes = makeAttributes(for: text)
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    static func makeAttributes(for title: String) -> [NSAttributedString.Key: Any] {
        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            //            .strokeWidth: CGFloat.random(in: (font.pointSize / 10.0) ... (font.pointSize / 4.0)),
            .obliqueness: CGFloat.random(in: -0.2...0.2),
            .shadow: shadow,
            .kern: CGFloat.random(in: 0...2),
            //            .backgroundColor: randomLightColor,
            .strokeColor: DecoratedPhotoTitle.fontColors.randomElement()!,
            .foregroundColor: DecoratedPhotoTitle.fontColors.randomElement()!,
        ]
        
        //        let color = DecoratedString.fontColors.randomElement()!
        //        let colorKey: NSAttributedString.Key = Int.random(in: 0...1) == 1 ? .strokeColor : .foregroundColor
        
        //        attributes[colorKey] = color
        
        return attributes
    }
    
    static func randomLightColor() -> UIColor {
        return UIColor(
            hue: CGFloat.random(in: 0...1.0),
            saturation: CGFloat.random(in: 0...1.0),
            brightness: CGFloat.random(in: 0.8...1.0),
            alpha: 1.0
        )
    }
    
    
    static func randomDarkColor() -> UIColor {
        return UIColor(
            hue: CGFloat.random(in: 0...1),
            saturation: CGFloat.random(in: 0...1),
            brightness: CGFloat.random(in: 0...0.4),
            alpha: 1.0
        )
    }
    
    
    static var fontSize: CGFloat {
        return CGFloat.random(in: 12...28)
    }
    
    
    static var fontWeight: UIFont.Weight {
        return [
            .bold, .black, .heavy, .light, .medium, .regular, .semibold, .thin, .ultraLight
        ].randomElement()!
    }
    
    static var shadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = randomDarkColor()
        shadow.shadowBlurRadius = CGFloat.random(in: 0...4)
        shadow.shadowOffset = CGSize(width: CGFloat.random(in: 0...4), height: CGFloat.random(in: 0...4))
        
        return shadow
    }
    
    
    static var unnamedTitleString: NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.lightText
        ]
        
        return NSAttributedString(string: "Unnamed Image", attributes: attributes)
    }
}

