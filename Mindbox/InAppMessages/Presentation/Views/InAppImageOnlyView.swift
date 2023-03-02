//
//  InAppImageOnlyView.swift
//  Mindbox
//
//  Created by Максим Казаков on 07.09.2022.
//

import UIKit

final class InAppImageOnlyView: UIView {

    var onClose: (() -> Void)?
    let imageView = UIImageView()
    let closeButton = UIButton(frame: .zero)
    let uiModel: InAppMessageUIModel

    init(uiModel: InAppMessageUIModel) {
        self.uiModel = uiModel
        super.init(frame: .zero)
        customInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func customInit() {
        let bundle = Bundle(for: InAppImageOnlyView.self)
        let image = UIImage(data: uiModel.imageData)
        imageView.contentMode = .scaleAspectFill
        imageView.image = image

        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)

        let closeImage = UIImage(named: "cross", in: bundle, compatibleWith: nil)
        closeButton.setImage(closeImage, for: .normal)
        closeButton.contentVerticalAlignment = .fill
        closeButton.contentHorizontalAlignment = .fill
        closeButton.imageView?.contentMode = .scaleAspectFill
        closeButton.addTarget(self, action: #selector(onTapCloseButton), for: .touchUpInside)
        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        layer.masksToBounds = true
    }

    @objc func onTapCloseButton() {
        self.onClose?()
    }
}
