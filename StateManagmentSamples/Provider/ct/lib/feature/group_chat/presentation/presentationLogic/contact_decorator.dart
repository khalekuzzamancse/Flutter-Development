import '../../../contact_list/domain/model/contact_model.dart';

class ContactDecorator {
  final ContactModel model;
  final bool isSelected;

  ContactDecorator(this.model, this.isSelected);

  ContactDecorator copyWith({bool? isSelected}) {
    return ContactDecorator(
      model, // keeps the existing actions.dart
      isSelected ?? this.isSelected, // updates isSelected if provided
    );
  }

  static ContactDecorator fromModel(ContactModel model) {
    return ContactDecorator(model, false);
  }
}