class MapWidget extends HookWidget {
  final LatLng userLatLong;
  final LatLng? center;
  final String userId;
  final MapController mapController;
  final Function(MapPosition position, bool hasGesture) onPositionChanged;
  final Function() onMapReady;
  final List<String>? friends;

  const MapWidget({
    required this.mapController,
    required this.onPositionChanged,
    required this.onMapReady,
    required this.userLatLong,
    this.center,
    this.friends = const [],
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userEntities = useEntities<UserEntity>(friends!);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        onMapReady: onMapReady,
        onPositionChanged: onPositionChanged,
        center: center ?? userLatLong,
        zoom: 13.0,
        interactiveFlags: ~InteractiveFlag.rotate,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              height: 45,
              width: 45,
              point: userLatLong,
              builder: (_) => MapMarker(
                onTapped: () {},
                userId: userId,
              ),
            ),
            ...userEntities.where((element) {
              UserEntity? userEntity = element.value.getOrNull();
              if (userEntity == null) return false;
              return userEntity.value.lastLocationProperty.value != null &&
                  element.value.get().value.alertProperty.value!;
            }).map(
              (userEntity) {
                final location = userEntity.value.get().value.lastLocationProperty.value;
                return Marker(
                  width: 45,
                  height: 45,
                  point: new LatLng(location!.latitudeProperty.value!, location.longitudeProperty.value!),
                  builder: (_) => MapMarker(
                    onTapped: () async {
                      final alert =
                          await AlertNotificationEntity.getAlertNotificationByAlertIdQuery(userEntity.entityId)
                              .first()
                              .get();
                      StyledDialog(
                        titleText: "Alert Details",
                        body: AlertNotificationCard(notificationEntity: alert),
                      ).show(context);
                    },
                    userId: userEntity.entityId,
                  ),
                  rotate: true,
                );
              },
            ),
          ],
        )
      ],
    );
  }
}