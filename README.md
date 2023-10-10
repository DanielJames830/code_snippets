# SafeAlone - You're Safe Alone When You're Safe Together

## Setup Process
- Run `flutter pub get`
- If an error occurs about duplicate resources in the Android main res folder, delete `android/app/src/main/res/values/ic_launcher.xml`.

## Feature Process
- Update the `develop` branch locally.
- Create a branch off the `develop` branch where the name is the ticket number, dash, then a brief summary of the ticket (could be the name of the ticket). For example, "2-onboarding-improvements"
- Write your code and commit to the branch. Commits can be named whatever you want.
- Test your code with "flutter test" and ensure all tests pass.
- Push the branch to Github.
- In Github, create a PR (Pull Request) for the branch. Name the PR the ticket number, colon, then a brief summary of the ticket. For example "2: Onboarding Improvements"
- Wait for the automated Github Actions tests to pass.
- If the Github Actions tests were successful, request a review from me.
