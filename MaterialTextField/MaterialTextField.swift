//
//  MaterialTextField.swift
//
//  Created by Andrey Yarosh on 07/08/2017.
//  https://github.com/bingosoft/swift/tree/master/MaterialTextField
//

import Foundation
import UIKit

@IBDesignable
class MaterialTextField : UITextField
{
	private var placeHolderLabel = UILabel();
	private var underLineView = UIView();

	@IBInspectable override var placeholder: String! {
		set {
			placeHolderLabel.text = newValue;
			placeHolderLabel.sizeToFit();
		}
		get {
			return placeHolderLabel.text
		}
	}

	@IBInspectable var placeholderColor: UIColor! {
		didSet {
			placeHolderLabel.textColor = placeholderColor;
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
		var c: [NSLayoutConstraint]!
		clipsToBounds = false;
		
		addSubview(placeHolderLabel);
		tintColor = textColor;
		placeholderColor = .gray;
		placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false;
		placeHolderLabel.font = font;
		c = NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[label]", options: .alignAllFirstBaseline, metrics: nil, views: ["label": placeHolderLabel])
		addConstraints(c);
		addConstraint(placeHolderLabel.centerYAnchor.constraint(equalTo: centerYAnchor));
		addConstraints(c);
		
		addSubview(underLineView);
		underLineView.translatesAutoresizingMaskIntoConstraints = false;
		underLineView.backgroundColor = UIColor.white.withAlphaComponent(0.6);
		c = NSLayoutConstraint.constraints(withVisualFormat: "|[v]|", options: .alignAllFirstBaseline, metrics: nil, views: ["v": underLineView])
		addConstraints(c);
		c = NSLayoutConstraint.constraints(withVisualFormat: "V:[v(2)]-(-3)-|", options: .alignAllFirstBaseline, metrics: nil, views: ["v": underLineView])
		addConstraints(c);
		
		addTarget(self, action: #selector(didStartEditing), for: .editingDidBegin);
		addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd);
	}
	
	func didStartEditing() {
		let k: CGFloat = 0.7;
		let dx = placeHolderLabel.frame.width * (1 - k) / 2;
		let t = CGAffineTransform(translationX: -dx, y: -20).scaledBy(x: k, y: k);

		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
			if (self.text?.isEmpty ?? true) {
        		self.placeHolderLabel.layer.setAffineTransform(t);
			}
			self.underLineView.backgroundColor = UIColor.white;
		});
	}
	
	
	func didEndEditing() {
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
			if (self.text?.isEmpty ?? true) {
        		self.placeHolderLabel.layer.setAffineTransform(.identity);
			}
    		self.underLineView.backgroundColor = UIColor.white.withAlphaComponent(0.6);
		})
	}
	
}
