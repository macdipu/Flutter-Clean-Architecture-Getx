# clean_architecture_getx

A Flutter project with Clean Architecture and automated feature generation.

---

## 🚀 Quick Start - Feature Generator

Generate complete feature modules in seconds!

```bash
dart generate_feature.dart <feature_name>
```

**Example:**
```bash
dart generate_feature.dart user_profile
```

**What it generates:**
- ✅ Complete folder structure (8 folders)
- ✅ All necessary files (10 files, ~700 lines)
- ✅ Clean Architecture setup
- ✅ GetX state management
- ✅ Cache implementation
- ✅ HTTP client integration
- ✅ Dependency injection

**Time saved:** 93% faster (40 minutes → 3 minutes)

---

## 📋 4-Step Setup Process

After generation, customize these 4 things (takes 2-3 minutes):

### 1️⃣ Update Entity
**File:** `domain/entity/<feature>_item.dart`

```dart
class UserProfileItem {
  String? id;
  String? email;
  String? fullName;
  // Add your fields here
  
  UserProfileItem({this.id, this.email, this.fullName});
  
  UserProfileItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['fullName'];
  }
  
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'fullName': fullName};
  }
}
```

---

### 2️⃣ Update Response Model
**File:** `data/model/item_list_response.dart`

```dart
class ItemData {
  // Match API field names (usually PascalCase)
  ItemData.fromJson(dynamic json) {
    _id = json['Id'];           // ← API field name
    _email = json['Email'];     // ← API field name
    _fullName = json['FullName']; // ← API field name
  }
}
```

**Your API Response Format:**
```json
{
  "Success": true,
  "Data": [
    {
      "Id": "123",
      "Email": "user@example.com",
      "FullName": "John Doe"
    }
  ],
  "ErrorMessage": null
}
```

---

### 3️⃣ Update HTTP Implementation
**File:** `data/repo_impl/<feature>_http_impl.dart`

**Step A:** Add endpoint to `lib/core/data/http/urls/api_urls.dart`:
```dart
class ApiUrl {
  String get getAllUserProfile => "/api/users/profile";
}
```

**Step B:** Update HTTP implementation:
```dart
@override
ResultFuture<UserProfileItemList> getUserProfileList() async {
  try {
    final response = await client.authorizedGet(urls.getAllUserProfile);
    
    if (response.messageCode == 200) {
      ItemListResponse itemList = ItemListResponse.fromJson(response.response);
      
      List<UserProfileItem> list = [];
      for (var item in itemList.data!) {
        list.add(UserProfileItem(
          id: item.id,
          email: item.email,
          fullName: item.fullName,
        ));
      }
      
      return Right(UserProfileItemList(userProfileItems: list));
    }
    return const Left(ConnectionFailure("Failed to fetch data"));
  } catch (e) {
    return Left(ConnectionFailure(e.toString()));
  }
}
```

---

### 4️⃣ Register Routes

**Step A:** Add route constant - `lib/res/routes/app_routes.dart`:
```dart
class AppRoutes {
  static const String login = '/login';
  static const String trades = '/trades';
  static const String userProfile = '/user_profile';  // ← Add
}
```

**Step B:** Register pages - `lib/res/routes/app_pages.dart`:
```dart
import 'package:aminul_haque/features/user_profile/presentation/pages.dart';

class AppPages {
  static final List<GetPage> routes = [
    ...AuthPages.routes,
    ...UserProfilePages.routes,  // ← Add
  ];
}
```

---

## ✅ Final Checklist

```
□ Generated feature folder
□ Updated entity with fields
□ Updated response model with API fields
□ Added API endpoint in api_urls.dart
□ Updated HTTP implementation
□ Added route constant in app_routes.dart
□ Imported and registered in app_pages.dart
□ Customized UI screen
□ Tested screen loads
□ Tested data fetches
□ Tested pull-to-refresh
```

---

## 📝 Naming Convention Examples

| Feature Name | Entity Class | Controller | Route Constant |
|--------------|-------------|------------|----------------|
| `user_profile` | `UserProfileItem` | `UserProfileScreenController` | `userProfile` |
| `product_list` | `ProductListItem` | `ProductListScreenController` | `productList` |
| `order_history` | `OrderHistoryItem` | `OrderHistoryScreenController` | `orderHistory` |

---

## 🎨 Bonus: Customize UI

**File:** `presentation/screens/<feature>_screen.dart`

```dart
class _ListTile extends StatelessWidget {
  const _ListTile({required this.item});
  final UserProfileItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(item.fullName?[0] ?? '?'),
        ),
        title: Text(item.fullName ?? 'N/A'),
        subtitle: Text(item.email ?? ''),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to detail screen
        },
      ),
    );
  }
}
```

---

## 🧪 Test Navigation

```dart
// Navigate to your new feature
Get.toNamed(AppRoutes.userProfile);

// Or with arguments
Get.toNamed(AppRoutes.userProfile, arguments: {'id': '123'});
```

---

## 🆘 Common Errors

**Error: Route not found**
→ Check route name in `app_routes.dart` matches `pages.dart`

**Error: Dependency not found**
→ Verify binding is added in `pages.dart`

**Error: Type mismatch**
→ Entity fields must match response model fields

**Error: 401/403**
→ Use `client.authorizedGet()` not `client.get()`

---

## 📚 File Reference

```
features/<feature_name>/
├── data/
│   ├── model/
│   │   └── item_list_response.dart      ← Step 2
│   └── repo_impl/
│       ├── <feature>_http_impl.dart      ← Step 3
│       └── <feature>_cache_impl.dart     
├── domain/
│   ├── entity/
│   │   └── <feature>_item.dart           ← Step 1
│   ├── repo/
│   └── usecase/
└── presentation/
    ├── bindings/
    ├── controller/
    ├── screens/
    │   └── <feature>_screen.dart         ← UI customization
    └── pages.dart                        ← Step 4B
```

---

## 🎯 That's It!

Just **4 steps** to a fully working feature:
1. Entity fields
2. Response model
3. HTTP endpoint
4. Route registration

**Reference:** Check `lib/features/trades/` for a complete example.

---

## 📖 Complete Documentation

For more detailed information, see:
- **QUICK_START_CHEAT_SHEET.md** - Fast 4-step guide
- **FEATURE_SETUP_GUIDE.md** - Complete walkthrough with examples
- **ARCHITECTURE_OVERVIEW.md** - Deep dive into clean architecture
- **VISUAL_SUMMARY.md** - Visual workflow and diagrams
- **INDEX.md** - Documentation navigation hub

---

## 🏗️ Clean Architecture Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                          │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Screen (UI)                                                 │   │
│  │  • Displays data                                             │   │
│  │  • Handles user input                                        │   │
│  │  • Shows loading/error states                                │   │
│  └────────────────────────┬─────────────────────────────────────┘   │
│                           │ Observes                                │
│                           ▼                                         │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Controller (GetX)                                           │   │
│  │  • Manages UI state                                          │   │
│  │  • Calls use cases                                           │   │
│  │  • Handles business logic                                    │   │
│  └────────────────────────┬─────────────────────────────────────┘   │
│                           │ Calls                                   │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Binding (Dependency Injection)                              │   │
│  │  • Initializes dependencies                                  │   │
│  │  • Manages lifecycle                                         │   │
│  └─────────────────────────────────────────────────────────────┘   │
└────────────────────────────┬────────────────────────────────────────┘
                             │
┌────────────────────────────┼────────────────────────────────────────┐
│                         DOMAIN LAYER                                │
│                            │                                         │
│  ┌─────────────────────────▼─────────────────────────────────────┐ │
│  │  Use Case                                                      │ │
│  │  • Contains business rules                                     │ │
│  │  • Orchestrates data flow                                      │ │
│  │  • Returns Either<Failure, Data>                               │ │
│  └────────────────────────┬───────────────────────────────────────┘ │
│                           │ Calls                                   │
│  ┌─────────────────────────▼─────────────────────────────────────┐ │
│  │  Repository Interface                                          │ │
│  │  • Defines contract                                            │ │
│  │  • Abstract methods                                            │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  Entity                                                       │  │
│  │  • Pure business objects                                      │  │
│  │  • No dependencies                                            │  │
│  └──────────────────────────────────────────────────────────────┘  │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
┌────────────────────────────┼─────────────────────────────────────────┐
│                         DATA LAYER                                  │
│                            │                                         │
│  ┌─────────────────────────▼─────────────────────────────────────┐ │
│  │  Cache Implementation                                          │ │
│  │  • Checks local cache first                                    │ │
│  │  • Falls back to HTTP if needed                                │ │
│  │  • Saves data locally                                          │ │
│  └────────────────────────┬───────────────────────────────────────┘ │
│                           │ Delegates to                            │
│  ┌─────────────────────────▼─────────────────────────────────────┐ │
│  │  HTTP Implementation                                           │ │
│  │  • Makes API calls                                             │ │
│  │  • Handles network errors                                      │ │
│  │  • Maps response to entity                                     │ │
│  └────────────────────────┬───────────────────────────────────────┘ │
│                           │ Uses                                    │
│  ┌─────────────────────────▼─────────────────────────────────────┐ │
│  │  Response Model                                                │ │
│  │  • Maps API JSON                                               │ │
│  │  • Handles serialization                                       │ │
│  └────────────────────────┬───────────────────────────────────────┘ │
│                           │                                         │
└────────────────────────────┼─────────────────────────────────────────┘
                             │
                             ▼
                    ┌────────────────┐
                    │   REST API     │
                    │   (Backend)    │
                    └────────────────┘
```

---

## 📊 Project Structure

```
lib/
├── features/
│   ├── trades/              ← Example feature (reference this!)
│   ├── authentication/
│   └── your_feature/        ← Generated features go here
├── core/
│   ├── data/
│   │   ├── cache/
│   │   └── http/
│   ├── domain/
│   │   ├── usecase/
│   │   └── error/
│   └── presentation/
│       └── widgets/
└── res/
    ├── routes/
    │   ├── app_routes.dart  ← Add route constants here
    │   └── app_pages.dart   ← Register pages here
    └── strings/
```

---

## 💡 Key Principles

### 1. Separation of Concerns
- **Presentation**: What user sees
- **Domain**: What app does
- **Data**: Where data comes from

### 2. Dependency Rule
- Domain doesn't depend on anything
- Data depends on domain
- Presentation depends on domain

### 3. Testability
- Each layer can be tested independently
- Mock interfaces for testing
- No tight coupling

### 4. Maintainability
- Change API? Update data layer only
- Change UI? Update presentation only
- Change business logic? Update domain only

---

## 🚀 Getting Started

1. **Clone the repository**
2. **Run:** `flutter pub get`
3. **Generate a feature:** `dart generate_feature.dart my_feature`
4. **Follow the 4-step setup process above**
5. **Run the app:** `flutter run`

---

## 📚 Additional Resources

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [GetX Documentation](https://pub.dev/packages/get)
- [Dartz for Functional Programming](https://pub.dev/packages/dartz)

---

## 🤝 Contributing

1. Generate your feature using the CLI tool
2. Follow the established patterns
3. Test thoroughly
4. Submit your PR

---

**Generate → Update → Register → Test** 🚀

Made with ❤️ for fast Flutter development


