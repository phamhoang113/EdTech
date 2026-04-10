import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/services/mapbox_service.dart';

/// Full-screen bản đồ với marker kéo thả + search bar.
/// Tham khảo web MapPickerModal component.
class MapPickerScreen extends StatefulWidget {
  final String initialAddress;

  const MapPickerScreen({super.key, this.initialAddress = ''});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  static const _defaultCenter = LatLng(10.7769, 106.7009); // HCM

  final _mapController = MapController();
  final _searchController = TextEditingController();

  LatLng _markerPosition = _defaultCenter;
  String _currentAddress = 'Chưa chọn vị trí';
  bool _loadingAddress = false;
  bool _searching = false;
  List<PlaceResult> _searchResults = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress.isNotEmpty) {
      _currentAddress = widget.initialAddress;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  /// Tap bản đồ → di chuyển marker + reverse geocode.
  Future<void> _onMapTap(TapPosition tapPosition, LatLng point) async {
    setState(() {
      _markerPosition = point;
      _loadingAddress = true;
    });

    final address = await MapboxService.reverseGeocode(point.latitude, point.longitude);
    if (!mounted) return;

    setState(() {
      _currentAddress = address;
      _loadingAddress = false;
    });
  }

  /// Search địa chỉ.
  Future<void> _handleSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _searching = true);
    final results = await MapboxService.searchAddress(query);
    if (!mounted) return;

    setState(() {
      _searchResults = results;
      _searching = false;
    });
  }

  /// Chọn kết quả search → bay đến vị trí + reverse geocode.
  Future<void> _selectSearchResult(PlaceResult result) async {
    final point = LatLng(result.lat, result.lon);

    setState(() {
      _markerPosition = point;
      _currentAddress = result.displayName;
      _searchResults = [];
      _searchController.clear();
    });

    _mapController.move(point, 16);
  }

  void _confirmAddress() {
    Navigator.of(context).pop(_currentAddress);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // ── Bản đồ ──
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _markerPosition,
              initialZoom: 14,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(urlTemplate: MapboxService.tileUrl),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _markerPosition,
                    width: 40,
                    height: 40,
                    child: const _MapPinIcon(),
                  ),
                ],
              ),
            ],
          ),

          // ── Search bar (floating) ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Column(
                children: [
                  _buildSearchBar(theme),
                  if (_searchResults.isNotEmpty) _buildSearchResults(theme),
                ],
              ),
            ),
          ),

          // ── Footer: địa chỉ + nút xác nhận ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildFooter(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, size: 22),
          ),
          // Search input
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _handleSearch(),
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm vị trí...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (_searching)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              onPressed: _handleSearch,
              icon: const Icon(Icons.search),
              color: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      constraints: const BoxConstraints(maxHeight: 260),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _searchResults.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: theme.dividerColor.withAlpha(30)),
        itemBuilder: (_, index) {
          final result = _searchResults[index];
          final parts = result.displayName.split(',');
          final mainText = parts.first;
          final subText =
              parts.length > 1 ? parts.sublist(1).join(',').trim() : '';

          return ListTile(
            dense: true,
            leading: Icon(Icons.location_on,
                size: 20, color: theme.colorScheme.primary),
            title: Text(mainText,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
            subtitle: subText.isNotEmpty
                ? Text(subText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant))
                : null,
            onTap: () => _selectSearchResult(result),
          );
        },
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 14, 16, MediaQuery.of(context).padding.bottom + 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('Địa chỉ đã chọn:',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              )),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on,
                  size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: _loadingAddress
                    ? Text('Đang xác định...',
                        style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic))
                    : Text(_currentAddress,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Huỷ
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Huỷ'),
                ),
              ),
              const SizedBox(width: 12),
              // Xác nhận
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: _confirmAddress,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Xác nhận địa chỉ'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Marker icon giống web (indigo pin).
class _MapPinIcon extends StatelessWidget {
  const _MapPinIcon();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withAlpha(80),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.location_on, color: Colors.white, size: 16),
        ),
        // Pin stem
        Container(
          width: 3,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF6366F1),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(2)),
          ),
        ),
      ],
    );
  }
}
