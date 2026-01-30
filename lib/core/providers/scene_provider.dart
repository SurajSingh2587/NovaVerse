import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Source {
  final String id;
  final String name;
  final SourceType type;
  bool isVisible;
  bool isMuted;
  Offset position;
  Size size;
  int zIndex;
  Map<String, dynamic> settings;

  Source({
    String? id,
    required this.name,
    required this.type,
    this.isVisible = true,
    this.isMuted = false,
    this.position = Offset.zero,
    this.size = const Size(200, 150),
    this.zIndex = 0,
    Map<String, dynamic>? settings,
  })  : id = id ?? const Uuid().v4(),
        settings = settings ?? {};

  Source copyWith({
    String? name,
    SourceType? type,
    bool? isVisible,
    bool? isMuted,
    Offset? position,
    Size? size,
    int? zIndex,
    Map<String, dynamic>? settings,
  }) {
    return Source(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      isVisible: isVisible ?? this.isVisible,
      isMuted: isMuted ?? this.isMuted,
      position: position ?? this.position,
      size: size ?? this.size,
      zIndex: zIndex ?? this.zIndex,
      settings: settings ?? this.settings,
    );
  }

  IconData get icon {
    switch (type) {
      case SourceType.camera:
        return Icons.videocam_rounded;
      case SourceType.screenCapture:
        return Icons.screen_share_rounded;
      case SourceType.image:
        return Icons.image_rounded;
      case SourceType.text:
        return Icons.text_fields_rounded;
      case SourceType.audio:
        return Icons.mic_rounded;
      case SourceType.browser:
        return Icons.web_rounded;
      case SourceType.video:
        return Icons.movie_rounded;
      case SourceType.gameCapture:
        return Icons.sports_esports_rounded;
    }
  }

  Color get color {
    switch (type) {
      case SourceType.camera:
        return const Color(0xFF6C5CE7);
      case SourceType.screenCapture:
        return const Color(0xFF00D9FF);
      case SourceType.image:
        return const Color(0xFF00F5A0);
      case SourceType.text:
        return const Color(0xFFFF9F43);
      case SourceType.audio:
        return const Color(0xFFFF6B9D);
      case SourceType.browser:
        return const Color(0xFF54A0FF);
      case SourceType.video:
        return const Color(0xFFFECA57);
      case SourceType.gameCapture:
        return const Color(0xFFFF6B6B);
    }
  }
}

enum SourceType {
  camera,
  screenCapture,
  image,
  text,
  audio,
  browser,
  video,
  gameCapture,
}

class Scene {
  final String id;
  String name;
  List<Source> sources;
  bool isActive;
  Color color;
  String? thumbnailPath;

  Scene({
    String? id,
    required this.name,
    List<Source>? sources,
    this.isActive = false,
    Color? color,
    this.thumbnailPath,
  })  : id = id ?? const Uuid().v4(),
        sources = sources ?? [],
        color = color ?? const Color(0xFF6C5CE7);

  Scene copyWith({
    String? name,
    List<Source>? sources,
    bool? isActive,
    Color? color,
    String? thumbnailPath,
  }) {
    return Scene(
      id: id,
      name: name ?? this.name,
      sources: sources ?? this.sources,
      isActive: isActive ?? this.isActive,
      color: color ?? this.color,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }
}

class SceneProvider extends ChangeNotifier {
  List<Scene> _scenes = [];
  String? _activeSceneId;
  String? _selectedSourceId;

  SceneProvider() {
    _initializeDefaultScenes();
  }

  void _initializeDefaultScenes() {
    _scenes = [
      Scene(
        name: 'Main Scene',
        isActive: true,
        sources: [
          Source(
            name: 'Camera',
            type: SourceType.camera,
            position: const Offset(20, 20),
            size: const Size(320, 240),
            zIndex: 1,
          ),
        ],
        color: const Color(0xFF6C5CE7),
      ),
      Scene(
        name: 'Gaming',
        sources: [
          Source(
            name: 'Game Capture',
            type: SourceType.gameCapture,
            position: Offset.zero,
            size: const Size(1920, 1080),
            zIndex: 0,
          ),
          Source(
            name: 'Facecam',
            type: SourceType.camera,
            position: const Offset(1580, 820),
            size: const Size(320, 240),
            zIndex: 1,
          ),
        ],
        color: const Color(0xFFFF6B6B),
      ),
      Scene(
        name: 'Just Chatting',
        sources: [
          Source(
            name: 'Webcam',
            type: SourceType.camera,
            position: Offset.zero,
            size: const Size(1920, 1080),
            zIndex: 0,
          ),
        ],
        color: const Color(0xFF00D9FF),
      ),
      Scene(
        name: 'BRB',
        sources: [
          Source(
            name: 'BRB Image',
            type: SourceType.image,
            position: Offset.zero,
            size: const Size(1920, 1080),
            zIndex: 0,
          ),
        ],
        color: const Color(0xFFFF9F43),
      ),
    ];
    _activeSceneId = _scenes.first.id;
  }

  // Getters
  List<Scene> get scenes => _scenes;
  Scene? get activeScene => _scenes.firstWhere(
        (s) => s.id == _activeSceneId,
        orElse: () => _scenes.first,
      );
  String? get activeSceneId => _activeSceneId;
  String? get selectedSourceId => _selectedSourceId;
  
  Source? get selectedSource {
    if (_selectedSourceId == null || activeScene == null) return null;
    try {
      return activeScene!.sources.firstWhere((s) => s.id == _selectedSourceId);
    } catch (_) {
      return null;
    }
  }

  // Scene management
  void addScene(String name, {Color? color}) {
    final scene = Scene(
      name: name,
      color: color ?? const Color(0xFF6C5CE7),
    );
    _scenes.add(scene);
    notifyListeners();
  }

  void removeScene(String sceneId) {
    if (_scenes.length <= 1) return; // Keep at least one scene
    _scenes.removeWhere((s) => s.id == sceneId);
    if (_activeSceneId == sceneId) {
      _activeSceneId = _scenes.first.id;
    }
    notifyListeners();
  }

  void setActiveScene(String sceneId) {
    if (_activeSceneId == sceneId) return;
    
    // Update previous active scene
    final previousIndex = _scenes.indexWhere((s) => s.id == _activeSceneId);
    if (previousIndex != -1) {
      _scenes[previousIndex] = _scenes[previousIndex].copyWith(isActive: false);
    }
    
    // Set new active scene
    final newIndex = _scenes.indexWhere((s) => s.id == sceneId);
    if (newIndex != -1) {
      _scenes[newIndex] = _scenes[newIndex].copyWith(isActive: true);
      _activeSceneId = sceneId;
      _selectedSourceId = null; // Clear source selection
    }
    notifyListeners();
  }

  void renameScene(String sceneId, String newName) {
    final index = _scenes.indexWhere((s) => s.id == sceneId);
    if (index != -1) {
      _scenes[index] = _scenes[index].copyWith(name: newName);
      notifyListeners();
    }
  }

  void reorderScenes(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final scene = _scenes.removeAt(oldIndex);
    _scenes.insert(newIndex, scene);
    notifyListeners();
  }

  // Source management
  void addSource(SourceType type, String name) {
    if (activeScene == null) return;
    
    final source = Source(
      name: name,
      type: type,
      position: const Offset(100, 100),
      size: const Size(320, 240),
      zIndex: activeScene!.sources.length,
    );
    
    activeScene!.sources.add(source);
    _selectedSourceId = source.id;
    notifyListeners();
  }

  void removeSource(String sourceId) {
    if (activeScene == null) return;
    activeScene!.sources.removeWhere((s) => s.id == sourceId);
    if (_selectedSourceId == sourceId) {
      _selectedSourceId = null;
    }
    notifyListeners();
  }

  void selectSource(String? sourceId) {
    _selectedSourceId = sourceId;
    notifyListeners();
  }

  void updateSourcePosition(String sourceId, Offset position) {
    if (activeScene == null) return;
    final index = activeScene!.sources.indexWhere((s) => s.id == sourceId);
    if (index != -1) {
      activeScene!.sources[index] = activeScene!.sources[index].copyWith(
        position: position,
      );
      notifyListeners();
    }
  }

  void updateSourceSize(String sourceId, Size size) {
    if (activeScene == null) return;
    final index = activeScene!.sources.indexWhere((s) => s.id == sourceId);
    if (index != -1) {
      activeScene!.sources[index] = activeScene!.sources[index].copyWith(
        size: size,
      );
      notifyListeners();
    }
  }

  void toggleSourceVisibility(String sourceId) {
    if (activeScene == null) return;
    final index = activeScene!.sources.indexWhere((s) => s.id == sourceId);
    if (index != -1) {
      final source = activeScene!.sources[index];
      activeScene!.sources[index] = source.copyWith(
        isVisible: !source.isVisible,
      );
      notifyListeners();
    }
  }

  void toggleSourceMute(String sourceId) {
    if (activeScene == null) return;
    final index = activeScene!.sources.indexWhere((s) => s.id == sourceId);
    if (index != -1) {
      final source = activeScene!.sources[index];
      activeScene!.sources[index] = source.copyWith(
        isMuted: !source.isMuted,
      );
      notifyListeners();
    }
  }

  void moveSourceUp(String sourceId) {
    if (activeScene == null) return;
    final sources = activeScene!.sources;
    final index = sources.indexWhere((s) => s.id == sourceId);
    if (index < sources.length - 1) {
      final source = sources.removeAt(index);
      sources.insert(index + 1, source);
      _updateZIndices();
      notifyListeners();
    }
  }

  void moveSourceDown(String sourceId) {
    if (activeScene == null) return;
    final sources = activeScene!.sources;
    final index = sources.indexWhere((s) => s.id == sourceId);
    if (index > 0) {
      final source = sources.removeAt(index);
      sources.insert(index - 1, source);
      _updateZIndices();
      notifyListeners();
    }
  }

  void _updateZIndices() {
    if (activeScene == null) return;
    for (int i = 0; i < activeScene!.sources.length; i++) {
      activeScene!.sources[i] = activeScene!.sources[i].copyWith(zIndex: i);
    }
  }

  void duplicateSource(String sourceId) {
    if (activeScene == null) return;
    try {
      final source = activeScene!.sources.firstWhere((s) => s.id == sourceId);
      final newSource = Source(
        name: '${source.name} (Copy)',
        type: source.type,
        isVisible: source.isVisible,
        isMuted: source.isMuted,
        position: source.position + const Offset(20, 20),
        size: source.size,
        zIndex: activeScene!.sources.length,
        settings: Map.from(source.settings),
      );
      activeScene!.sources.add(newSource);
      _selectedSourceId = newSource.id;
      notifyListeners();
    } catch (_) {}
  }
}
