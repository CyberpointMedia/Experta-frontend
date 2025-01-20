import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:flutter/material.dart';

class WorkExperienceWidget extends StatelessWidget {
  final WorkExperience workExperience;
  final bool edit;
  final VoidCallback? onEdit;

  const WorkExperienceWidget({
    super.key,
    required this.workExperience,
    this.edit = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final experiencePeriod = formatExperiencePeriod(
        workExperience.startDate, workExperience.endDate ?? DateTime.now());
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                workExperience.jobTitle,
                style:
                    theme.textTheme.titleMedium!.copyWith(color: Colors.black),
              ),
              if (edit)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: onEdit,
                ),
            ],
          ),
          const SizedBox(height: 3.0),
          Text(
            workExperience.companyName,
            style: theme.textTheme.titleMedium!.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 3.0),
          Text(
            experiencePeriod,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
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

class EducationWidget extends StatelessWidget {
  final Education education;
  final bool edit;
  final VoidCallback? onEdit;

  const EducationWidget({
    super.key,
    required this.education,
    this.edit = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final educationPeriod =
        formatEducationPeriod(education.startDate, education.endDate);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                education.degree,
                style: CustomTextStyles.titleMediumSFProTextBlack90001,
              ),
              if (edit)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: onEdit,
                ),
            ],
          ),
          const SizedBox(height: 3.0),
          Text(
            education.schoolCollege,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black),
          ),
          const SizedBox(height: 3.0),
          Text(
            educationPeriod,
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

String formatEducationPeriod(DateTime startDate, DateTime endDate) {
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
