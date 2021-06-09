//
//  ArrayExtension.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/2/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

