class BlueprintSelections {
  static String style = 'Traditional';
  static List<String> selectedFloors = [];
  static int landsize = 1000;

  static List<String> bathroomTypeSelections = [];
  static List<String> kitchenFloorSelections = [];

  static final Map<String, List<String>> bedroomSelectionsByFloor = {};
  static final Map<String, List<String>> bathroomSelectionsByFloor = {};
  static final Map<String, List<String>> livingRoomSelectionsByFloor = {};

  static int get floors {
    if (selectedFloors.isEmpty) return 1;
    final first = selectedFloors.first.toLowerCase();
    if (first.contains('single')) return 1;
    if (first.contains('double')) return 2;
    if (first.contains('triple')) return 3;
    if (first.contains('quadruple')) return 4;
    return 1;
  }

  static int get bedrooms {
    final total = bedroomSelectionsByFloor.values.fold<int>(
      0,
      (sum, selections) => sum + maxRoomSelectionValue(selections),
    );
    return total > 0 ? total : 1;
  }

  static int get bathrooms {
    final attachedTotal = bathroomSelectionsByFloor.values.fold<int>(
      0,
      (sum, selections) => sum + selections.length,
    );

    if (attachedTotal > 0) return attachedTotal;
    if (bathroomTypeSelections.isNotEmpty) return 1;
    return 1;
  }

  static int get kitchens {
    if (kitchenFloorSelections.isEmpty) return 1;
    return kitchenFloorSelections.length;
  }

  static int get livingRooms {
    // Fixed to 1 living room as per requirements
    return 1;
  }

  static int maxRoomSelectionValue(List<String> selections) {
    if (selections.isEmpty) return 0;
    var maxValue = 0;

    for (final selection in selections) {
      final normalized = selection.toLowerCase();
      int value;

      if (normalized.contains('single')) {
        value = 1;
      } else if (normalized.contains('double')) {
        value = 2;
      } else if (normalized.contains('triple')) {
        value = 3;
      } else if (normalized.contains('quadruple')) {
        value = 4;
      } else {
        final match = RegExp(r'\d+').firstMatch(selection);
        value = match != null ? int.tryParse(match.group(0) ?? '') ?? 0 : 0;
      }

      if (value > maxValue) {
        maxValue = value;
      }
    }

    return maxValue;
  }
}
