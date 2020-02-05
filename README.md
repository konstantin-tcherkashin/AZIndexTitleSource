# AZIndexTitleSource
A helper struct, converting plain array into structure, usable for UITableView with sectionIndex titles

### Usage:

- Conform your model to AZRepresentable protocol

        protocol AZRepresentable {
            var letter: String { get }
            var title: String { get }
        }

- Create an instance of AZIndexTitleSource with your array of data

        var splittedSource: AZIndexTitleSource<SampleObject>! = AZIndexTitleSource(source: data)

- Use it in UITableViewDataSource methods

        override func numberOfSections(in tableView: UITableView) -> Int {
            return splittedSource?.sectionsCount ?? 0
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            do {
                return try splittedSource.numberOfItems(in: section)
            } catch {
                print(error)
                return 0
            }
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            do {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SampleTableViewCell
                cell.update(try splittedSource.item(at: indexPath))
                return cell
            } catch {
                print(error)
                return UITableViewCell()
            }
        }

        override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            return splittedSource.keys
        }

        override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
            return index
        }

        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return  try? splittedSource.key(forSection: section)
        }

- That's it!

