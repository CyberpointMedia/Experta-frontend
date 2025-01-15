///SelectionPopupModel is common model
///used for setting data into dropdowns
class SelectionPopupModel {
  final String id;
  final String title;
  final dynamic value;
  final bool isSelected;

  SelectionPopupModel({
    required this.id,
    required this.title,
    this.value,
    this.isSelected = false,
  });

  @override
  String toString() {
    return 'SelectionPopupModel(id: $id, title: $title, value: $value, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SelectionPopupModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
