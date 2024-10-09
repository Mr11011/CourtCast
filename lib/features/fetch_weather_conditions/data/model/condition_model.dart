
import '../../domain/entities/condiotion_entity.dart';

class ConditionModel {
  final String condition_text;
  final String condition_icon;

  ConditionModel({required this.condition_text, required this.condition_icon});

  factory ConditionModel.fromJson(Map<String, dynamic> json) {
    return ConditionModel(
      condition_text: json['text'],
      condition_icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': condition_text, 'icon': condition_icon};
  }

  ConditionEntity toEntity() {
    return ConditionEntity(text: condition_text, icon: condition_icon);
  }
}
