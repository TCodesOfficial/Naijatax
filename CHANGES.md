# Changelog - Major App Update

## Date: June 25, 2026

---

## 1. AppBar & Navigation Overhaul

### `client/lib/widgets/adaptive_scaffold.dart` (Full Rewrite)

**AppBar:**
- Removed logout button from AppBar (now only in Profile page)
- Removed notification bell icon from AppBar
- Removed desktop navigation links from AppBar
- AppBar now shows only: App logo (bank icon + "NaijaTax Enlighten") + user profile photo
- Profile photo is small (16px radius) to fit in AppBar
- Added `Icons.person` placeholder for users without avatar photos
- Title text is now `Flexible` with `TextOverflow.ellipsis` to prevent overflow

**Desktop Sidebar (width >= 900):**
- Added permanent fixed left sidebar navigation (240px wide)
- Sidebar contains: App logo at top, nav items (Home, Calculator, AI Assistant, Community, Profile) with icons + labels
- Active item highlighted with primary color indicator bar
- User avatar + name displayed at bottom of sidebar
- Sidebar has proper border separation from main content

**Bottom Navigation Bar (mobile):**
- Increased padding from `horizontal: 12, vertical: 10` to `horizontal: 16, vertical: 14`
- Increased gap between tabs from 4 to 8
- Increased icon size from 22 to 24
- Increased text size from 11 to 12
- Added stronger box shadow for better visibility
- "Assistant" tab label shortened from "AI Assistant" to "Assistant"

---

## 2. Chat/Assistant Tab Fix

### `client/lib/screens/ai_chat/chat_screen.dart`

- Chat screen now ALWAYS shows content (welcome message, suggestions, input)
- Guests see the full chat UI but with disabled input field and "Guest Mode" badge
- Send button shows guest restriction dialog instead of failing silently
- Suggestion chips show guest restriction dialog when tapped by guests
- Welcome message is different for guests ("Sign in to chat with AI Tax Assistant")
- Guest users see a "Log In / Sign Up" button in the welcome message
- Desktop layout centers chat in a constrained container (maxWidth: 800)

### `client/lib/core/router/app_router.dart`

- Removed `/chat` from protected routes list (guests can now access chat screen)
- Guests are no longer redirected to `/login` when tapping the Assistant tab

---

## 3. Dashboard Quick Actions Enhancement

### `client/lib/screens/dashboard_screen.dart`

**Quick Action Tiles:**
- PAYE Calculator tile now shows a circular progress indicator with the user's tax ratio (computedTax / annualGross)
- Business Tax tile shows CIT exemption status as a progress indicator
- VAT Guide and AI Assistant tiles keep their default icons
- When no tax profile exists, tiles show default icons (no progress bars)
- Progress labels shown below each progress indicator (e.g., "Tax Ratio", "EXEMPT")
- Tile text is now 13px with max 2 lines and overflow handling

---

## 4. Profile Page "Coming Soon" Badges

### `client/lib/screens/profile/profile_screen.dart`

- Added `_comingSoonBadge()` widget that shows a styled chip with "Coming Soon" text
- **Notification Settings**: Now shows "Coming Soon" badge, tapping shows SnackBar "This feature is coming soon!"
- **Privacy & Security**: Now shows "Coming Soon" badge, tapping shows SnackBar
- **Support Center**: Now shows "Coming Soon" badge, tapping shows SnackBar
- **My Documents** and **Verify Account**: Now visible to all users (not just authenticated)
  - Tapping as guest shows guest restriction dialog
  - Tapping as authenticated user navigates to the screen

---

## 5. Guest Restriction Dialog

### `client/lib/widgets/guest_restriction_dialog.dart` (New File)

- Reusable `showGuestRestrictionDialog()` function
- Shows AlertDialog with:
  - Lock icon in a circular container
  - "Account Required" title
  - Explanatory text: "This feature requires an account..."
  - "Cancel" and "Log In" buttons
  - Log In button navigates to `/login`

### `client/lib/core/router/app_router.dart`

- Removed all guest redirect logic from route guards
- Guest restriction is now handled via dialog popups in each screen

### `client/lib/screens/documents/documents_vault_screen.dart`

- Added guest restriction dialog on screen load for guests

### `client/lib/screens/profile/verify_account_screen.dart`

- Added guest restriction dialog on screen load for guests

---

## 6. Phone Number Authentication

### `server/prisma/schema.prisma`

- Added `phone String? @unique` field to User model
- Added `displayName String? @map("display_name")` field to User model
- Changed `email String` to `email String?` (now optional for phone-based auth)

### `server/prisma/migrations/20260625000000_add_phone_auth/migration.sql` (New File)

- SQL migration to add phone, display_name columns
- Unique constraint on phone column
- Makes email column nullable

### `client/lib/models/user_model.dart`

- Added `phone` field (optional String)
- Added `displayName` field (optional String)
- Changed `email` from required to optional
- Updated `fromJson`/`toJson` to handle new fields

### `client/lib/providers/auth_provider.dart`

- Added `needsOtpVerification` and `pendingPhone` to AuthState
- Added `signInWithPhone(phone)` - sends OTP via Supabase
- Added `verifyOtp(phone, otp)` - verifies OTP and signs in
- Added `signUpWithPhone(phone, password)` - registers with phone + password
- Updated all auth state creation to include phone and displayName fields
- Updated `updateAvatar` to preserve phone and displayName

### `client/lib/screens/auth/login_screen.dart`

- Added Email/Phone toggle switcher at top of form
- Phone mode shows:
  - Country code prefix (+234) + phone number input
  - "Send OTP" button
  - After OTP sent: OTP input field + "Verify & Sign In" button
  - "Change phone number" link to go back
- Email mode remains unchanged (email + password + social logins)
- Social logins still available in both modes

### `client/lib/screens/auth/register_screen.dart`

- Added Email/Phone toggle switcher at top of form
- Phone mode shows:
  - Country code prefix (+234) + phone number input
  - Password + Confirm Password fields
  - "Send OTP" button
  - After OTP sent: OTP input + "Verify & Create Account" button
- Email mode remains unchanged

---

## 7. Profile Photo Placeholder

### Files Updated:
- `client/lib/widgets/adaptive_scaffold.dart` - AppBar profile photo uses `Icons.person`
- `client/lib/screens/profile/profile_screen.dart` - Profile card avatar uses `Icons.person`
- `client/lib/screens/ai_chat/chat_screen.dart` - User chat bubbles use `Icons.person`

All user avatar CircleAvatars now show `Icons.person` silhouette when no avatarUrl is set, instead of showing the first letter of the email.

---

## 8. Utility Updates

### `client/lib/widgets/custom_text_field.dart`

- Added `maxLength` parameter for OTP input fields
- Counter text is hidden (`counterText: ''`)

### `client/lib/screens/dashboard_screen.dart`

- Updated displayName logic to handle nullable email (uses displayName, then email prefix, then "User")

### `client/lib/screens/profile/profile_screen.dart`

- Updated displayName logic to handle nullable email

---

## Files Modified Summary

| File | Change Type |
|------|------------|
| `client/lib/widgets/adaptive_scaffold.dart` | Major Rewrite |
| `client/lib/screens/ai_chat/chat_screen.dart` | Significant Update |
| `client/lib/screens/dashboard_screen.dart` | Updated |
| `client/lib/screens/profile/profile_screen.dart` | Updated |
| `client/lib/screens/auth/login_screen.dart` | Major Rewrite |
| `client/lib/screens/auth/register_screen.dart` | Major Rewrite |
| `client/lib/providers/auth_provider.dart` | Major Update |
| `client/lib/models/user_model.dart` | Updated |
| `client/lib/core/router/app_router.dart` | Updated |
| `client/lib/widgets/custom_text_field.dart` | Updated |
| `client/lib/screens/documents/documents_vault_screen.dart` | Updated |
| `client/lib/screens/profile/verify_account_screen.dart` | Updated |
| `server/prisma/schema.prisma` | Updated |
| `server/prisma/migrations/.../migration.sql` | New File |
| `client/lib/widgets/guest_restriction_dialog.dart` | New File |

---

## Notes

- **Prisma Migration**: The migration SQL file has been created. To apply it to Supabase, run:
  ```bash
  cd server
  npx prisma migrate deploy
  ```
  Or apply the SQL directly in the Supabase SQL Editor.

- **Supabase Phone Auth**: Phone authentication requires Supabase project to have phone provider enabled in Authentication > Providers settings.

- **Breaking Changes**: The `UserModel.email` field is now nullable. All code that previously accessed `user.email` directly now needs null checks. This has been handled in all modified files.
