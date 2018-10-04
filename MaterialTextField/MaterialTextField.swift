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
	
	private (set) var placeholderMinimized = false {
		didSet {
			guard (oldValue != placeholderMinimized) else { return }
			
			let transform: CGAffineTransform!
			
			if (placeholderMinimized) {
				let k: CGFloat = 0.7;
				let dx = placeHolderLabel.frame.width * (1 - k) / 2;
				transform = CGAffineTransform(translationX: -dx, y: -20).scaledBy(x: k, y: k);
			} else {
				transform = .identity;
			}
			
			UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
				self.placeHolderLabel.layer.setAffineTransform(transform);
			})
		}
	}

	private var isActive = false;

	override var text: String? {
		didSet {
			updateState();
		}
	}

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
		clipsToBounds = false;
		tintColor = textColor;
		placeholderColor = .gray;
		
		addSubview(placeHolderLabel);
		placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false;
		placeHolderLabel.font = font;
		addConstraint(placeHolderLabel.leadingAnchor.constraint(equalTo: leadingAnchor));
		addConstraint(placeHolderLabel.centerYAnchor.constraint(equalTo: centerYAnchor));
		
		addSubview(underLineView);
		underLineView.translatesAutoresizingMaskIntoConstraints = false;
		underLineView.backgroundColor = UIColor.white.withAlphaComponent(0.6);
		var c = NSLayoutConstraint.constraints(withVisualFormat: "|[v]|", options: .alignAllFirstBaseline, metrics: nil, views: ["v": underLineView])
		addConstraints(c);
		c = NSLayoutConstraint.constraints(withVisualFormat: "V:[v(2)]-(-3)-|", options: .alignAllFirstBaseline, metrics: nil, views: ["v": underLineView])
		addConstraints(c);
		
		addTarget(self, action: #selector(didStartEditing), for: .editingDidBegin);
		addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd);
		addTarget(self, action: #selector(editingChanged), for: .editingChanged);
	}

	@objc func didStartEditing() {
		UIView.animate(withDuration: 0.3) {
			self.underLineView.backgroundColor = UIColor.white;
		}
		isActive = true;
		updateState();
	}

	@objc func didEndEditing() {
		UIView.animate(withDuration: 0.3) {
			self.underLineView.backgroundColor = UIColor.white.withAlphaComponent(0.6);
		}
		isActive = false;
		updateState();
	}

	@objc func editingChanged() {
		updateState();
	}

	func updateState() {
		placeholderMinimized = isActive || !text!.isEmpty
	}
}
