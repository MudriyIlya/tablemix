//
//  CustomTableView.swift
//  tablemix
//
//  Created by Илья Мудрый on 12.07.2023.
//

import UIKit

final class CustomTableView: UITableView {
	
	override func reloadData() {
		super.reloadData()
		UIView.transition(
			with: self,
			duration: 1,
			options: .transitionCrossDissolve
		) {
			super.reloadData()
		}
	}
}
