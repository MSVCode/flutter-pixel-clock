import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class WeatherTile extends StatelessWidget {
  final WeatherCondition _weatherCondition;
  final double size;

  WeatherTile(this._weatherCondition, {this.size = 50});

  Widget _buildIcon() {
    switch (_weatherCondition) {
      case WeatherCondition.cloudy:
        return Icon(CommunityMaterialIcons.weather_cloudy, size: size);
      case WeatherCondition.foggy:
        return Icon(CommunityMaterialIcons.weather_fog, size: size);
      case WeatherCondition.rainy:
        return Icon(CommunityMaterialIcons.weather_rainy, size: size);
      case WeatherCondition.snowy:
        return Icon(CommunityMaterialIcons.weather_snowy, size: size);
      case WeatherCondition.sunny:
        return Icon(CommunityMaterialIcons.weather_sunny, size: size);
      case WeatherCondition.thunderstorm:
        return Icon(CommunityMaterialIcons.weather_lightning_rainy, size: size);
      default:
        return Icon(CommunityMaterialIcons.cloud_question);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: _buildIcon(),
    );
  }
}
