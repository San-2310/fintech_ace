// EnrolledCoursesScreen.dart
import 'package:fintech_ace/views/course_screen/course_service.dart';
import 'package:flutter/material.dart';

import 'course.dart';
import 'course_detail.dart';

class EnrolledCoursesScreen extends StatelessWidget {
  const EnrolledCoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
      ),
      body: StreamBuilder<List<Course>>(
        stream: CourseService().getEnrolledCourses(''),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('You haven\'t enrolled in any courses yet'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final course = snapshot.data![index];
              return EnrolledCourseCard(course: course);
            },
          );
        },
      ),
    );
  }
}

class EnrolledCourseCard extends StatelessWidget {
  final Course course;
  const EnrolledCourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(
                course: course,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: course.completedUsers.contains('') ? 1.0 : 0.0,
                backgroundColor: Colors.grey[200],
                color: Colors.purple,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    course.completedUsers.contains('')
                        ? 'Completed'
                        : 'In Progress',
                    style: TextStyle(
                      color: course.completedUsers.contains('')
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text('Enrolled'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
