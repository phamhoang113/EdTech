import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/mapbox_service.dart';
import 'map_picker_screen.dart';

/// Trường nhập địa chỉ với autocomplete + nút mở bản đồ.
/// Tham khảo web MapAddressInput component.
class MapboxAddressField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const MapboxAddressField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<MapboxAddressField> createState() => _MapboxAddressFieldState();
}

class _MapboxAddressFieldState extends State<MapboxAddressField> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();

  List<PlaceResult> _suggestions = [];
  bool _loading = false;
  Timer? _debounce;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(MapboxAddressField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    }
  }

  void _onTextChanged(String text) {
    widget.onChanged(text);
    _debounce?.cancel();

    if (text.trim().length < 2) {
      _updateSuggestions([]);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (!mounted) return;
      setState(() => _loading = true);

      final results = await MapboxService.searchAddress(text);
      if (!mounted) return;

      setState(() => _loading = false);
      _updateSuggestions(results);
    });
  }

  void _updateSuggestions(List<PlaceResult> results) {
    _suggestions = results;
    if (results.isEmpty) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _selectSuggestion(PlaceResult result) {
    _controller.text = result.displayName;
    widget.onChanged(result.displayName);
    _focusNode.unfocus();
    _removeOverlay();
  }

  void _openMapPicker() async {
    _focusNode.unfocus();
    _removeOverlay();

    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(initialAddress: _controller.text),
      ),
    );

    if (result != null && mounted) {
      _controller.text = result;
      widget.onChanged(result);
    }
  }

  // ── Overlay management ──

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (_) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: _SuggestionList(
              suggestions: _suggestions,
              onSelect: _selectSuggestion,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onTextChanged,
        decoration: InputDecoration(
          labelText: 'Địa chỉ *',
          hintText: 'Nhập địa chỉ để tìm kiếm...',
          prefixIcon: const Icon(Icons.location_on_outlined),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              IconButton(
                onPressed: _openMapPicker,
                icon: const Icon(Icons.map_outlined),
                tooltip: 'Chọn trên bản đồ',
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        maxLines: 2,
      ),
    );
  }
}

/// Danh sách gợi ý địa chỉ — style giống web rcm-suggestions.
class _SuggestionList extends StatelessWidget {
  final List<PlaceResult> suggestions;
  final ValueChanged<PlaceResult> onSelect;

  const _SuggestionList({
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 240),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: theme.dividerColor.withAlpha(30)),
        itemBuilder: (_, index) {
          final result = suggestions[index];
          final parts = result.displayName.split(',');
          final mainText = parts.first;
          final subText = parts.length > 1 ? parts.sublist(1).join(',').trim() : '';

          return InkWell(
            onTap: () => onSelect(result),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mainText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subText.isNotEmpty)
                          Text(
                            subText,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
