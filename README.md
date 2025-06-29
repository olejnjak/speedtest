# Ubiquity Speed Test

Project is too complicated for a test task but showcases aspects that are important for my projects:
- good testability - code necessarily does not have to be tested, but has to be testable
- projects should use reasonable modularization to ensure a module depends on other's module interface, not implementation
- understandable documentation - try to produce self-documenting code, use (doc) comments where necessary
- use view composition to prevent massive views

Some important stuff is missing, like:
- tests (snapshots, unit tests)
- CI
- better error handling

## Tuist

For project maintenance [Tuist](https://tuist.dev) is used, to ensure project can be easily used, 
Xcode project file is commited, even though it is not necessary.