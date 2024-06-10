import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:flutter/material.dart';

class WorkExperienceWidget extends StatelessWidget {
  final WorkExperience workExperience;

  const WorkExperienceWidget({super.key, required this.workExperience});

  @override
  Widget build(BuildContext context) {
    final experiencePeriod = formatExperiencePeriod(
        workExperience.startDate, workExperience.endDate);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workExperience.jobTitle,
            style: CustomTextStyles.titleMediumSFProTextBlack90001,
          ),
          const SizedBox(height: 3.0),
          Text(
            workExperience.companyName,
            style: theme.textTheme.bodyLarge!.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 3.0),
          Text(
            experiencePeriod,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3.0),
          const Divider(),
        ],
      ),
    );
  }
}

String formatExperiencePeriod(DateTime startDate, DateTime endDate) {
  final now = DateTime.now();
  final end = endDate.isAfter(now) ? now : endDate;

  final startMonth = startDate.month;
  final startYear = startDate.year;
  final endMonth = end.month;
  final endYear = end.year;

  final duration = end.difference(startDate);
  final years = (duration.inDays / 365).floor();
  final months = ((duration.inDays % 365) / 30).floor();

  final startMonthName = _getMonthName(startMonth);
  final endMonthName = _getMonthName(endMonth);

  final endDateString =
      endDate.isAfter(now) ? 'Present' : '$endMonthName $endYear';

  return '$startMonthName $startYear - $endDateString · $years yrs $months mos';
}

String _getMonthName(int month) {
  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return monthNames[month - 1];
}
