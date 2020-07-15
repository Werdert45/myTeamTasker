# collaborative_repitition

Application to work of a list of daily tasks in your group

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


---
#TODO
APP-18: Add assign task functionality (IS IT REALLY NECESSARY?_
- Make an automatic function, that assigns a new member every night to all of the repeated_tasks, even if they are not active that day
- Only return the task to the user who it is assigned to.

APP-20: Add record to task
- Set the finished_by object to be an empty list
- If someone signs off a group_task, the name is added to the list
- (Increment the number of tasks completed by the user)
- Set finished to true (happens naturally if I am correct)

APP-21: remove old single tasks
- If single task is finished and was for a previous day, remove it

APP-22: Personal and groups manager / statistics
- Create statistics object in database
- Think about which statistics
- Add statistics