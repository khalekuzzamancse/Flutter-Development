# Run configuration
- Create new configuration-> Select the dart entry point as the file `apps/lib/main`
- Or `cd apps`-> `flutter run`
# Cleaning
- Clean each package(root, apps, features) separately, or use the following command:
  - ```flutter clean && cd apps && flutter clean && cd .. && cd features && flutter clean```