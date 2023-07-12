//
//  ViewController.swift
//  tablemix
//
//  Created by Илья Мудрый on 12.07.2023.
//

import UIKit

final class ViewController: UIViewController {

	// MARK: Variables

	private typealias DiffableDataSource = UITableViewDiffableDataSource<Int, Int>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Int>

	private lazy var tableView: CustomTableView = {
		let tableView = CustomTableView(frame: .zero, style: .plain)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
		tableView.delegate = self
		return tableView
	}()
	
	private let reuseIdentifier = "Cell"
	
	private var tableData = Array(0...33)
	
	private var checkedNumbers: Set<Int> = []
	
	private var dataSource: DiffableDataSource?
	
	// MARK: Lifycycle

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "МИКС В ТАБЛИЦЕ"
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Shuffle",
			style: .plain,
			target: self,
			action: #selector(shuffleTable)
		)
		view.backgroundColor = .systemBackground
		configureUI()
		makeDataSource()
		applySnapshot()
	}
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		
		cell.contentView.backgroundColor = .clear
		let isChecked = cell.accessoryType != .none
		if isChecked {
			checkedNumbers.remove(tableData[indexPath.row])
			cell.accessoryType = .none
		} else {
			let element = tableData.remove(at: indexPath.row)
			tableData.insert(element, at: 0)
			checkedNumbers.insert(element)
			cell.accessoryType = .checkmark
			applySnapshot()
		}
	}
}

// MARK: - Private

private extension ViewController {

	func configureUI() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		])
	}

	func makeDataSource() {
		dataSource = DiffableDataSource(tableView: tableView) { [unowned self] tableView, indexPath, itemIdentifier in
			let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
			let isChecked = self.checkedNumbers.contains(itemIdentifier)

			var configuration = cell.defaultContentConfiguration()
			configuration.text = "\(itemIdentifier)"
			cell.contentConfiguration = configuration
			cell.accessoryType = isChecked ? .checkmark : .none

			return cell
		}
		tableView.dataSource = dataSource
	}

	func applySnapshot() {
		var snapshot = Snapshot()
		snapshot.appendSections([0])
		snapshot.appendItems(tableData, toSection: 0)
		dataSource?.apply(snapshot, animatingDifferences: true)
	}
	
	@objc func shuffleTable() {
		tableData.shuffle()
		applySnapshot()
	}
}
