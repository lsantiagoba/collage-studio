# Win USB Boot

## Snap package

The Snap bundles `wimtools`, `parted`, `dosfstools`, `rsync`, and `util-linux`,
so the host does not need to install the USB-writing tools separately. Build it
from the project root with:

```bash
snapcraft pack
```

The Snap uses classic confinement because writing boot media requires invoking
the host's PolicyKit elevation flow and privileged disk utilities:

```bash
sudo snap install --dangerous --classic <snap-file>
```

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
