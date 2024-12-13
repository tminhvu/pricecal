class ChangeGroup {
  final String title;
  final List<String> changes;

  const ChangeGroup({required this.title, required this.changes});
}

class Release {
  final String title;
  final List<ChangeGroup> changes;

  const Release({required this.title, required this.changes});
}

class ReleaseNote {
  static String version = '1.0.0';
  static final Map<String, List<Release>> releases = {
    'en': [
      const Release(
        title: "1.0.0",
        changes: [
          ChangeGroup(
            title: "First release",
            changes: [],
          ),
        ],
      ),
    ],
    'vi': [
      const Release(
        title: "1.0.0",
        changes: [
          ChangeGroup(
            title: "Phiên bản đầu tiên",
            changes: [],
          ),
        ],
      ),
    ],
  };
}
