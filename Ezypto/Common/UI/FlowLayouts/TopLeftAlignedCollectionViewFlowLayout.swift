//
//  TopLeftAlignedCollectionViewFlowLayout.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/2.
//

import UIKit

final class TopLeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    var adjustToSameHeight: Bool = false

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attrs = super.layoutAttributesForElements(in: rect) {
            var baseline: CGFloat = -2
            var sameLineElements = [UICollectionViewLayoutAttributes]()
            var leftMargin = sectionInset.left
            var maxY: CGFloat = -1.0
            for element in attrs {
                guard element.representedElementCategory == .cell else { continue }

                // Align to top
                let frame = element.frame
                let centerY = frame.midY
                if abs(centerY - baseline) > 1 {
                    baseline = centerY
                    alignToTopForSameLineElements(&sameLineElements)
                    sameLineElements.removeAll()
                }
                sameLineElements.append(element)

                // Align to left
                guard let collectionView = collectionView,
                      let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
                    continue
                }
                let indexPath = element.indexPath
                let sectionEdgeInset = delegate.collectionView?(
                    collectionView,
                    layout: self,
                    insetForSectionAt: indexPath.section
                )
                    ?? sectionInset
                let interItemSpacing = delegate.collectionView?(
                    collectionView,
                    layout: self,
                    minimumInteritemSpacingForSectionAt: indexPath.section
                )
                    ?? minimumInteritemSpacing
                if element.frame.origin.y >= maxY {
                    leftMargin = sectionEdgeInset.left
                }
                element.frame.origin.x = leftMargin
                leftMargin += element.frame.width + interItemSpacing
                maxY = max(element.frame.maxY, maxY)
            }
            alignToTopForSameLineElements(&sameLineElements) // align one more time for the last line
            return attrs
        }
        return nil
    }

    private func alignToTopForSameLineElements(_ sameLineElements: inout [UICollectionViewLayoutAttributes]) {
        if sameLineElements.count < 1 {
            return
        }

        sameLineElements.sort { obj1, obj2 -> Bool in
            let height1 = obj1.frame.size.height
            let height2 = obj2.frame.size.height
            let delta = height1 - height2
            return delta <= 0
        }

        if let tallest = sameLineElements.last {
            for obj in sameLineElements {
                if adjustToSameHeight {
                    obj.frame = CGRect(
                        x: obj.frame.origin.x, y: tallest.frame.origin.y,
                        width: obj.frame.width, height: tallest.frame.height
                    )
                } else {
                    obj.frame = obj.frame.offsetBy(dx: 0, dy: tallest.frame.origin.y - obj.frame.origin.y)
                }
            }
        }
    }
}
